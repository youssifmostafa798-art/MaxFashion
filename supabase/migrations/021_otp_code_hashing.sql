-- OTP Code Hashing Migration
-- Replaces plaintext code storage with SHA-256 hashed codes
--
-- SECURITY: The plaintext code column is replaced with code_hash.
-- OTP verification now compares hashes instead of plaintext.
-- pgcrypto is required for digest() — created here for safety.

-- Ensure pgcrypto extension exists (required for digest())
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Add code_hash column
ALTER TABLE password_reset_codes
ADD COLUMN IF NOT EXISTS code_hash TEXT;

-- Migrate existing plaintext codes to hashed values
-- All existing codes are expired or used, so this is safe.
UPDATE password_reset_codes
SET code_hash = encode(digest(code, 'sha256'), 'hex')
WHERE code_hash IS NULL;

-- Make code_hash NOT NULL after migration
ALTER TABLE password_reset_codes
ALTER COLUMN code_hash SET NOT NULL;

-- Drop the plaintext code column
ALTER TABLE password_reset_codes
DROP COLUMN IF EXISTS code;

-- Update the partial index for fast active-code lookups
DROP INDEX IF EXISTS idx_password_reset_codes_email_active;
CREATE INDEX IF NOT EXISTS idx_password_reset_codes_email_active
  ON password_reset_codes (email, used)
  WHERE used = FALSE;
