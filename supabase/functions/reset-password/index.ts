// supabase/functions/reset-password/index.ts
// Supabase Edge Function to update password after OTP verification
//
// This function performs defense-in-depth OTP validation and updates the password.
// The primary OTP verification and attempt tracking is handled by verify-reset-code.
//
// After a successful password update, ALL existing sessions for the user are
// invalidated via admin.signOut so the client is forced to authenticate
// with the new credentials. This prevents stale-session bypass.
//
// To deploy:
//   supabase functions deploy reset-password

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders, handleCORS } from "../_shared/cors.ts";

const MAX_ATTEMPTS = 5;
const AUTH_USER_PAGE_SIZE = 1000;
const MAX_AUTH_USER_SCAN_PAGES = 100;

async function hashOTP(code: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(code);
  const hashBuffer = await crypto.subtle.digest("SHA-256", data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map((b) => b.toString(16).padStart(2, "0")).join("");
}

async function findAuthUserByEmail(
  supabase: ReturnType<typeof createClient>,
  normalizedEmail: string,
) {
  for (let page = 1; page <= MAX_AUTH_USER_SCAN_PAGES; page++) {
    const { data, error } = await supabase.auth.admin.listUsers({
      page,
      perPage: AUTH_USER_PAGE_SIZE,
    });

    if (error) {
      throw error;
    }

    const users = data?.users ?? [];
    const authUser = users.find(
      (user) => user.email?.toLowerCase() === normalizedEmail
    );

    if (authUser) {
      return authUser;
    }

    if (users.length < AUTH_USER_PAGE_SIZE) {
      return null;
    }

    const lastPage = data?.lastPage ?? 0;
    if (lastPage > 0 && page >= lastPage) {
      return null;
    }
  }

  throw new Error("Auth user lookup exceeded scan limit");
}

serve(async (req) => {
  const corsResponse = handleCORS(req);
  if (corsResponse) return corsResponse;

  try {
    const { email, code, new_password } = await req.json();

    if (
      !email ||
      typeof email !== "string" ||
      !code ||
      typeof code !== "string" ||
      !new_password ||
      typeof new_password !== "string"
    ) {
      return new Response(
        JSON.stringify({ error: "Email, code, and new password are required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const normalizedEmail = email.trim().toLowerCase();
    if (!/^\d{6}$/.test(code)) {
      return new Response(
        JSON.stringify({ error: "Invalid verification code." }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    if (new_password.length < 6) {
      return new Response(
        JSON.stringify({ error: "Password must be at least 6 characters" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Defense-in-depth: Verify the code is valid (not used, not expired, matches hash)
    // Note: attempt_count is NOT incremented here — it's handled by verify-reset-code
    const submittedHash = await hashOTP(code);
    const { data: codeRecord, error: queryError } = await supabase
      .from("password_reset_codes")
      .select("id, attempt_count")
      .eq("email", normalizedEmail)
      .eq("code_hash", submittedHash)
      .eq("used", false)
      .gt("expires_at", new Date().toISOString())
      .maybeSingle();

    if (queryError || !codeRecord) {
      return new Response(
        JSON.stringify({ error: "Invalid or expired verification code." }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    if (codeRecord.attempt_count >= MAX_ATTEMPTS) {
      return new Response(
        JSON.stringify({ error: "Too many attempts. Please request a new code." }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Find user by exact email using the Admin API.
    // NOTE: .from("auth.users") does NOT work — PostgREST only exposes the public schema.
    // NOTE: supabase-js listUsers() accepts only pagination params; it does not
    // forward a filter param, so the match must be checked explicitly.
    let authUser;
    try {
      authUser = await findAuthUserByEmail(supabase, normalizedEmail);
    } catch (error) {
      console.error(
        `[reset-password] Auth user lookup failed: ${
          error instanceof Error ? error.message : "unknown error"
        }`
      );
      return new Response(
        JSON.stringify({ error: "Failed to process request" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    if (!authUser) {
      return new Response(
        JSON.stringify({ error: "User not found" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Update password via Supabase Auth Admin API.
    // This changes the encrypted_password in auth.users and invalidates
    // existing refresh tokens — but does NOT immediately kill active
    // access tokens already cached on the client.
    const { data: updateData, error: updateError } = await supabase.auth.admin.updateUserById(
      authUser.id,
      { password: new_password }
    );

    const updatedUser = updateData?.user ?? null;
    if (
      updateError ||
      !updatedUser ||
      updatedUser.id !== authUser.id ||
      updatedUser.email?.toLowerCase() !== normalizedEmail
    ) {
      console.error(
        `[reset-password] Auth password update failed: userId=${authUser.id}, error=${
          updateError?.message ?? "missing or mismatched updated user"
        }`
      );
      return new Response(
        JSON.stringify({ error: "Failed to update password" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // CRITICAL: Invalidate ALL existing sessions for this user immediately.
    //
    // updateUserById() invalidates refresh tokens, but existing access tokens
    // (JWT) remain valid until they expire (~1 hour by default). This means
    // the client can still use a stale session to bypass the password change.
    //
    // admin.signOut(userId, { scope: "global" }) immediately revokes all
    // active sessions in the auth.sessions table, so the next request
    // using the old access token will receive 401 Unauthorized.
    //
    // If this call fails, we log a warning but do NOT block the response —
    // the password IS already changed and the refresh token IS invalidated.
    // The worst-case is that the old access token stays valid until it expires.
    try {
      const { error: signOutError } = await supabase.auth.admin.signOut(
        authUser.id,
        "global"
      );
      if (signOutError) {
        console.warn(
          `[reset-password] Session invalidation warning (non-fatal): userId=${authUser.id}, error=${signOutError.message}`
        );
      } else {
        console.log(
          `[reset-password] All sessions invalidated for userId=${authUser.id}`
        );
      }
    } catch (signOutErr) {
      // Non-fatal: password is changed; refresh tokens are invalidated by updateUserById
      console.warn(
        `[reset-password] Session invalidation exception (non-fatal): ${
          signOutErr instanceof Error ? signOutErr.message : "unknown"
        }`
      );
    }

    // Mark code as used (consumed).
    // This is done AFTER the password update succeeds — if the password
    // update failed we returned an error above and the code remains active
    // so the user can retry (e.g., with a corrected password).
    const { error: markUsedError } = await supabase
      .from("password_reset_codes")
      .update({ used: true })
      .eq("id", codeRecord.id);

    if (markUsedError) {
      console.error(
        `[reset-password] Failed to mark reset code used: codeId=${codeRecord.id}, error=${markUsedError.message}`
      );
      return new Response(
        JSON.stringify({ error: "Failed to finalize password reset" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    return new Response(
      JSON.stringify({ success: true, message: "Password updated successfully" }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
