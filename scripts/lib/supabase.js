import { createClient } from "@supabase/supabase-js";
import "dotenv/config";

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseServiceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseServiceRoleKey) {
  console.error(
    "✖ Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in .env\n" +
    "  Import scripts require the service_role key (not the anon key) " +
    "to bypass RLS for seeding. Get it from Supabase Dashboard → Settings → API."
  );
  process.exit(1);
}

// service_role key bypasses RLS entirely — this client must NEVER be used
// in the Flutter app or any client-facing code, only in these local seed scripts.
const supabase = createClient(supabaseUrl, supabaseServiceRoleKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
  },
});

export default supabase;