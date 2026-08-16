-- Security hardening for password_reset_codes
-- Adds attempt tracking and server-side rate limiting columns

-- Add attempt_count column for maximum verification attempts
ALTER TABLE password_reset_codes
  ADD COLUMN IF NOT EXISTS attempt_count INTEGER NOT NULL DEFAULT 0;

-- Add last_request_at for server-side rate limiting (60s cooldown)
ALTER TABLE password_reset_codes
  ADD COLUMN IF NOT EXISTS last_request_at TIMESTAMPTZ DEFAULT NOW();
