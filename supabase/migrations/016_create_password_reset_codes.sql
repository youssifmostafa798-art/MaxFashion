-- Password Reset Codes table for OTP-based password recovery
-- Run this in Supabase SQL Editor or as a migration

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

-- RLS policies
ALTER TABLE password_reset_codes ENABLE ROW LEVEL SECURITY;

-- Allow anonymous inserts (for requesting reset codes)
CREATE POLICY "Allow anonymous insert for password reset"
  ON password_reset_codes
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Allow anonymous selects (for verifying codes)
CREATE POLICY "Allow anonymous select for password reset"
  ON password_reset_codes
  FOR SELECT
  TO anon
  USING (true);

-- Allow anonymous updates (for marking codes as used)
CREATE POLICY "Allow anonymous update for password reset"
  ON password_reset_codes
  FOR UPDATE
  TO anon
  USING (true)
  WITH CHECK (true);
