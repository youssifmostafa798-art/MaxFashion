-- ============================================================
-- MaxFashion Addresses Schema
-- ============================================================
-- Creates the addresses table for persistent user addresses.
-- Run this in Supabase SQL Editor.
-- ============================================================

-- 1. Addresses
CREATE TABLE addresses (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  street       TEXT NOT NULL,
  apartment    TEXT,
  city         TEXT NOT NULL,
  state        TEXT NOT NULL,
  country      TEXT NOT NULL,
  zip          TEXT NOT NULL DEFAULT '',
  label        TEXT NOT NULL DEFAULT 'Home',
  is_default   BOOLEAN NOT NULL DEFAULT false,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Indexes
CREATE INDEX idx_addresses_user_id ON addresses (user_id);
CREATE INDEX idx_addresses_created_at ON addresses (created_at DESC);

-- 3. Unique constraint: one default address per user
-- Enforced at application level; index for fast default lookups
CREATE INDEX idx_addresses_user_default ON addresses (user_id, is_default)
  WHERE is_default = true;

-- ============================================================
-- Row Level Security (RLS)
-- ============================================================

ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;

-- SELECT: users can only view their own addresses
CREATE POLICY "Users can view own addresses"
  ON addresses FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT: users can only create addresses for themselves
CREATE POLICY "Users can insert own addresses"
  ON addresses FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- UPDATE: users can only update their own addresses
CREATE POLICY "Users can update own addresses"
  ON addresses FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- DELETE: users can only delete their own addresses
CREATE POLICY "Users can delete own addresses"
  ON addresses FOR DELETE
  USING (auth.uid() = user_id);
