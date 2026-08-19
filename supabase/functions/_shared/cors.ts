// supabase/functions/_shared/cors.ts
// Shared CORS configuration for all Edge Functions
//
// SECURITY NOTE: Wildcard origin (*) is used intentionally because:
// 1. This is a Flutter mobile app — mobile HTTP clients do NOT enforce CORS
// 2. CORS is a browser-only security mechanism; it has no effect on mobile clients
// 3. The Supabase anon key is already exposed in the Flutter app (by design)
// 4. Edge Functions are protected by the anon key validation, not by CORS
//
// If a web version is added in the future:
// - Replace wildcard with specific allowed origins
// - Add credentials: "include" if needed
// - Restrict methods and headers as appropriate

export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

export function handleCORS(req: Request): Response | null {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  return null;
}
