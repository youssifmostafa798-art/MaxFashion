-- ============================================================
-- MaxFashion Wishlist Items Schema
-- ============================================================
-- Creates the wishlist_items table for persistent user wishlists.
-- Run this in Supabase SQL Editor.
-- ============================================================

-- 1. Wishlist Items
CREATE TABLE wishlist_items (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id  BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Indexes
CREATE INDEX idx_wishlist_items_user_id ON wishlist_items (user_id);
CREATE INDEX idx_wishlist_items_product_id ON wishlist_items (product_id);

-- 3. Uniqueness: one wishlist entry per user per product
CREATE UNIQUE INDEX idx_wishlist_items_unique
  ON wishlist_items (user_id, product_id);

-- ============================================================
-- Row Level Security (RLS)
-- ============================================================

ALTER TABLE wishlist_items ENABLE ROW LEVEL SECURITY;

-- SELECT: users can only read their own wishlist items
CREATE POLICY "Users can view own wishlist items"
  ON wishlist_items FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT: users can only insert wishlist items belonging to themselves
CREATE POLICY "Users can insert own wishlist items"
  ON wishlist_items FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- DELETE: users can only delete their own wishlist items
CREATE POLICY "Users can delete own wishlist items"
  ON wishlist_items FOR DELETE
  USING (auth.uid() = user_id);
