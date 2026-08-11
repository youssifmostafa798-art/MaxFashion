-- ============================================================
-- MaxFashion Cart Items Schema
-- ============================================================
-- Creates the cart_items table for persistent user carts.
-- Run this in Supabase SQL Editor.
-- ============================================================

-- 1. Cart Items
CREATE TABLE cart_items (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id  BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  size        TEXT,
  quantity    INTEGER NOT NULL DEFAULT 1 CHECK (quantity >= 1),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Indexes
CREATE INDEX idx_cart_items_user_id ON cart_items (user_id);
CREATE INDEX idx_cart_items_product_id ON cart_items (product_id);

-- 3. Uniqueness: sized products (size IS NOT NULL)
CREATE UNIQUE INDEX idx_cart_items_unique_sized
  ON cart_items (user_id, product_id, size)
  WHERE size IS NOT NULL;

-- 4. Uniqueness: size-less products (size IS NULL)
CREATE UNIQUE INDEX idx_cart_items_unique_unsized
  ON cart_items (user_id, product_id)
  WHERE size IS NULL;

-- ============================================================
-- Row Level Security (RLS)
-- ============================================================

ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;

-- SELECT: users can only read their own cart items
CREATE POLICY "Users can view own cart items"
  ON cart_items FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT: users can only insert cart items belonging to themselves
CREATE POLICY "Users can insert own cart items"
  ON cart_items FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- UPDATE: users can only update their own cart items
-- Both USING and WITH CHECK prevent ownership transfer
CREATE POLICY "Users can update own cart items"
  ON cart_items FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- DELETE: users can only delete their own cart items
CREATE POLICY "Users can delete own cart items"
  ON cart_items FOR DELETE
  USING (auth.uid() = user_id);
