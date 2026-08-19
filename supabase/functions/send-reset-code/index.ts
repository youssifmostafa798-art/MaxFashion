// supabase/functions/send-reset-code/index.ts
// Supabase Edge Function to send password reset OTP via email
//
// To deploy:
//   supabase functions deploy send-reset-code
//
// Required environment variables (set in Supabase Dashboard → Edge Functions → Secrets):
//   RESEND_API_KEY - Your Resend API key (https://resend.com)
//
// Usage from Flutter:
//   final response = await Supabase.instance.client.functions.invoke(
//     'send-reset-code',
//     body: {'email': 'user@example.com'},
//   );

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders, handleCORS } from "../_shared/cors.ts";

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
    const { email } = await req.json();

    if (!email || typeof email !== "string") {
      return new Response(
        JSON.stringify({ error: "Email is required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const normalizedEmail = email.trim().toLowerCase();

    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(normalizedEmail)) {
      return new Response(
        JSON.stringify({ error: "Invalid email format" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Supabase client with service role key (for DB access)
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Check if user exists in auth using Admin API
    // NOTE: .from("auth.users") does NOT work — PostgREST only exposes the public schema.
    // NOTE: supabase-js listUsers() accepts only pagination params; it does not
    // forward a filter param, so the match must be checked explicitly.
    let authUser;
    try {
      authUser = await findAuthUserByEmail(supabase, normalizedEmail);
    } catch (error) {
      console.log(
        `[send-reset-code] User lookup failed: ${
          error instanceof Error ? error.message : "unknown error"
        }`
      );
      return new Response(
        JSON.stringify({ success: true, message: "If an account exists, a reset code has been sent." }),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // If query fails or user not found, still return success (user enumeration protection)
    if (!authUser) {
      console.log("[send-reset-code] User not found");
      return new Response(
        JSON.stringify({ success: true, message: "If an account exists, a reset code has been sent." }),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Server-side rate limiting: check for active request within last 60 seconds
    const { data: recentCode } = await supabase
      .from("password_reset_codes")
      .select("last_request_at")
      .eq("email", normalizedEmail)
      .eq("used", false)
      .order("created_at", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (recentCode && recentCode.last_request_at) {
      const lastRequestTime = new Date(recentCode.last_request_at).getTime();
      const now = Date.now();
      const secondsSinceLastRequest = (now - lastRequestTime) / 1000;

      if (secondsSinceLastRequest < 60) {
        const waitSeconds = Math.ceil(60 - secondsSinceLastRequest);
        return new Response(
          JSON.stringify({ error: `Please wait ${waitSeconds} seconds before requesting another code.` }),
          { status: 429, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }
    }

    // Invalidate any existing active codes for this email
    await supabase
      .from("password_reset_codes")
      .update({ used: true })
      .eq("email", normalizedEmail)
      .eq("used", false);

    // Generate 6-digit code
    const code = Math.floor(100000 + Math.random() * 900000).toString();

    // Hash the code before storing (never persist plaintext)
    const codeHash = await hashOTP(code);

    // Store hashed code in database (expires in 10 minutes)
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000).toISOString();
    const { error: insertError } = await supabase
      .from("password_reset_codes")
      .insert({
        email: normalizedEmail,
        code_hash: codeHash,
        expires_at: expiresAt,
        used: false,
        attempt_count: 0,
        last_request_at: new Date().toISOString(),
      });

    if (insertError) {
      return new Response(
        JSON.stringify({ error: "Failed to generate reset code" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Send email via Resend
    const resendApiKey = Deno.env.get("RESEND_API_KEY") ?? "";
    if (!resendApiKey) {
      // No email API configured — log code server-side for development only.
      // NEVER return the code in the API response (security: OTP leakage).
      console.log(`[DEV MODE] Reset code for ${email}: ${code}`);
      return new Response(
        JSON.stringify({ success: true, message: "Reset code sent." }),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const emailResponse = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${resendApiKey}`,
      },
      body: JSON.stringify({
        from: "MaxFashion <onboarding@resend.dev>",
        to: [email],
        subject: "Your Password Reset Code",
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
            <h2 style="color: #000; margin-bottom: 20px;">Password Reset Code</h2>
            <p style="color: #333; font-size: 16px; line-height: 1.5;">
              You requested a password reset. Use the following code to reset your password:
            </p>
            <div style="background: #f5f5f5; border-radius: 8px; padding: 20px; text-align: center; margin: 20px 0;">
              <span style="font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #000;">
                ${code}
              </span>
            </div>
            <p style="color: #666; font-size: 14px;">
              This code expires in 10 minutes. If you didn't request this, please ignore this email.
            </p>
            <p style="color: #999; font-size: 12px; margin-top: 30px;">
              MaxFashion Team
            </p>
          </div>
        `,
      }),
    });

    if (!emailResponse.ok) {
      const errorData = await emailResponse.text();
      console.error(`[send-reset-code] Resend error (status ${emailResponse.status}):`, errorData);
      return new Response(
        JSON.stringify({ error: "Failed to send email" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const emailResult = await emailResponse.json();
    console.log(`[send-reset-code] Resend accepted: id=${emailResult.id}, to=${email}`);

    return new Response(
      JSON.stringify({ success: true, message: "Reset code sent successfully." }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
