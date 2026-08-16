-- ============================================================
-- MaxFashion Payment Cards Schema
-- ============================================================
-- Creates the payment_cards table for persistent user payment methods.
-- Run this in Supabase SQL Editor.
-- ============================================================

-- 1. Payment Cards
CREATE TABLE payment_cards (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  card_holder_name TEXT NOT NULL,
  last4_digits     TEXT NOT NULL,
  expiry_month     TEXT NOT NULL,
  expiry_year      TEXT NOT NULL,
  card_brand       TEXT NOT NULL DEFAULT 'unknown',
  is_default       BOOLEAN NOT NULL DEFAULT false,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Indexes
CREATE INDEX idx_payment_cards_user_id ON payment_cards (user_id);
CREATE INDEX idx_payment_cards_created_at ON payment_cards (created_at DESC);

-- 3. Index for fast default card lookups
CREATE INDEX idx_payment_cards_user_default ON payment_cards (user_id, is_default)
  WHERE is_default = true;

-- ============================================================
-- Row Level Security (RLS)
-- ============================================================

ALTER TABLE payment_cards ENABLE ROW LEVEL SECURITY;

-- SELECT: users can only view their own payment cards
CREATE POLICY "Users can view own payment cards"
  ON payment_cards FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT: users can only create payment cards for themselves
CREATE POLICY "Users can insert own payment cards"
  ON payment_cards FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- UPDATE: users can only update their own payment cards
CREATE POLICY "Users can update own payment cards"
  ON payment_cards FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- DELETE: users can only delete their own payment cards
CREATE POLICY "Users can delete own payment cards"
  ON payment_cards FOR DELETE
  USING (auth.uid() = user_id);
