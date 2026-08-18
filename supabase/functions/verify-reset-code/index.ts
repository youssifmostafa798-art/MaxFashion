// supabase/functions/verify-reset-code/index.ts
// Supabase Edge Function to verify OTP code for password recovery
//
// This function validates the OTP without updating the password.
// It increments attempt_count on failure and enforces max_attempts.
//
// To deploy:
//   supabase functions deploy verify-reset-code

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

const MAX_ATTEMPTS = 5;

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { email, code } = await req.json();

    if (!email || !code) {
      return new Response(
        JSON.stringify({ error: "Email and code are required" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Look up the code record for this email
    const { data: codeRecord, error: queryError } = await supabase
      .from("password_reset_codes")
      .select("id, code, used, expires_at, attempt_count")
      .eq("email", email.toLowerCase())
      .eq("used", false)
      .order("created_at", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (queryError) {
      return new Response(
        JSON.stringify({ error: "Failed to verify code" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // No active code found for this email
    if (!codeRecord) {
      return new Response(
        JSON.stringify({ error: "No active reset code found. Please request a new code." }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Check if code is expired
    if (new Date(codeRecord.expires_at) <= new Date()) {
      return new Response(
        JSON.stringify({ error: "Code has expired. Please request a new code." }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Check if max attempts already reached
    if (codeRecord.attempt_count >= MAX_ATTEMPTS) {
      // Mark as used to prevent further attempts
      await supabase
        .from("password_reset_codes")
        .update({ used: true })
        .eq("id", codeRecord.id);

      return new Response(
        JSON.stringify({ error: "Too many attempts. Please request a new code." }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Check if the provided code matches the stored code
    if (codeRecord.code !== code) {
      // Increment attempt_count
      const newAttemptCount = codeRecord.attempt_count + 1;

      if (newAttemptCount >= MAX_ATTEMPTS) {
        // Max attempts reached — mark code as used
        await supabase
          .from("password_reset_codes")
          .update({ used: true, attempt_count: newAttemptCount })
          .eq("id", codeRecord.id);

        return new Response(
          JSON.stringify({ error: "Too many attempts. Please request a new code." }),
          { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }

      // Increment attempt counter
      await supabase
        .from("password_reset_codes")
        .update({ attempt_count: newAttemptCount })
        .eq("id", codeRecord.id);

      return new Response(
        JSON.stringify({ error: "Invalid verification code." }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Code is valid — return success
    // Note: The code is NOT marked as used here. It will be marked as used
    // by the reset-password function after the password is updated.
    return new Response(
      JSON.stringify({ success: true, message: "Code verified successfully." }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
