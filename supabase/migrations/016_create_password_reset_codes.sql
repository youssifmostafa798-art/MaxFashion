-- Password Reset Codes table for OTP-based password recovery
-- Run this in Supabase SQL Editor or as a migration
--
-- SECURITY: RLS is enabled with NO client-side policies.
-- All access is via Edge Functions using the service_role key (bypasses RLS).
-- The anon role has NO access to this table.

CREATE TABLE IF NOT EXISTS password_reset_codes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT NOT NULL,
  code TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  used BOOLEAN DEFAULT FALSE,
  attempt_count INTEGER NOT NULL DEFAULT 0,
  last_request_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for quick lookup by email + active codes
CREATE INDEX IF NOT EXISTS idx_password_reset_codes_email_active
  ON password_reset_codes (email, used)
  WHERE used = FALSE;

-- Auto-expire old codes (cleanup function)
CREATE OR REPLACE FUNCTION cleanup_expired_codes()
RETURNS void AS $$
BEGIN
  DELETE FROM password_reset_codes
  WHERE expires_at < NOW() - INTERVAL '1 hour';
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- RLS: Service-role only (no client-side access)
-- ============================================================
-- All operations (INSERT, SELECT, UPDATE, DELETE) are performed
-- by Edge Functions using the service_role key, which bypasses RLS.
-- The anon and authenticated roles have NO policies on this table.
-- ============================================================
ALTER TABLE password_reset_codes ENABLE ROW LEVEL SECURITY;
