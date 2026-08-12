-- ============================================================
-- MaxFashion Orders Schema
-- ============================================================
-- Creates the orders and order_items tables.
-- PROPOSED ONLY — NOT EXECUTED
-- ============================================================

-- 1. Orders
CREATE TABLE orders (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  order_number     TEXT NOT NULL UNIQUE,
  total_price      NUMERIC(10,2) NOT NULL,
  status           TEXT NOT NULL DEFAULT 'processing',
  delivery_address TEXT NOT NULL,
  payment_method   TEXT NOT NULL,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Order Items
CREATE TABLE order_items (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id        UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id      BIGINT REFERENCES products(id) ON DELETE SET NULL,
  product_name    TEXT NOT NULL,
  product_image   TEXT NOT NULL DEFAULT '',
  selected_color  TEXT,
  selected_size   TEXT NOT NULL DEFAULT 'S',
  quantity        INTEGER NOT NULL DEFAULT 1 CHECK (quantity >= 1),
  unit_price      NUMERIC(10,2) NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. Indexes
CREATE INDEX idx_orders_user_id ON orders (user_id);
CREATE INDEX idx_orders_created_at ON orders (created_at DESC);
CREATE INDEX idx_order_items_order_id ON order_items (order_id);
CREATE INDEX idx_order_items_product_id ON order_items (product_id);

-- 4. Unique constraint on order_number
CREATE UNIQUE INDEX idx_orders_order_number ON orders (order_number);

-- ============================================================
-- Row Level Security (RLS)
-- ============================================================

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Orders RLS

-- SELECT: users can only view their own orders
CREATE POLICY "Users can view own orders"
  ON orders FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT: users can only create orders for themselves
CREATE POLICY "Users can insert own orders"
  ON orders FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- UPDATE: users can only update their own orders
CREATE POLICY "Users can update own orders"
  ON orders FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- DELETE: users can only delete their own orders
CREATE POLICY "Users can delete own orders"
  ON orders FOR DELETE
  USING (auth.uid() = user_id);

-- Order Items RLS

-- SELECT: users can only view items from their own orders
CREATE POLICY "Users can view own order items"
  ON order_items FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
      AND orders.user_id = auth.uid()
    )
  );

-- INSERT: users can only insert items into their own orders
CREATE POLICY "Users can insert own order items"
  ON order_items FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
      AND orders.user_id = auth.uid()
    )
  );

-- UPDATE: users can only update items in their own orders
CREATE POLICY "Users can update own order items"
  ON order_items FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
      AND orders.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
      AND orders.user_id = auth.uid()
    )
  );

-- DELETE: users can only delete items from their own orders
CREATE POLICY "Users can delete own order items"
  ON order_items FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
      AND orders.user_id = auth.uid()
    )
  );
