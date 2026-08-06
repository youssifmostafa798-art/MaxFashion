-- ============================================================
-- MaxFashion Products Database Schema
-- ============================================================
-- Run this in Supabase SQL Editor to create all product tables.
-- ============================================================

-- 1. Categories
CREATE TABLE categories (
  id        BIGINT PRIMARY KEY,
  name      TEXT NOT NULL UNIQUE,
  slug      TEXT NOT NULL UNIQUE,
  image_url TEXT NOT NULL DEFAULT ''
);

CREATE INDEX idx_categories_slug ON categories (slug);

-- 2. Products
CREATE TABLE products (
  id              BIGINT PRIMARY KEY,
  category_id     BIGINT NOT NULL REFERENCES categories(id),
  name            TEXT NOT NULL,
  description     TEXT NOT NULL DEFAULT '',
  price           NUMERIC(10,2) NOT NULL,
  discount_price  NUMERIC(10,2),
  brand           TEXT NOT NULL DEFAULT 'MaxFashion',
  thumbnail_url   TEXT NOT NULL DEFAULT '',
  is_featured     BOOLEAN NOT NULL DEFAULT false,
  is_available    BOOLEAN NOT NULL DEFAULT true
);

CREATE INDEX idx_products_category_id ON products (category_id);
CREATE INDEX idx_products_is_featured ON products (is_featured);

-- 3. Product Images
CREATE TABLE product_images (
  id          BIGINT PRIMARY KEY,
  product_id  BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  image_url   TEXT NOT NULL,
  sort_order  INTEGER NOT NULL DEFAULT 1
);

CREATE INDEX idx_product_images_product_id ON product_images (product_id);

-- 4. Product Sizes
CREATE TABLE product_sizes (
  id          BIGSERIAL PRIMARY KEY,
  product_id  BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  size        TEXT NOT NULL,
  stock       INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_product_sizes_product_id ON product_sizes (product_id);
CREATE UNIQUE INDEX idx_product_sizes_product_size ON product_sizes (product_id, size);

-- ============================================================
-- Row Level Security (RLS)
-- ============================================================

ALTER TABLE categories      ENABLE ROW LEVEL SECURITY;
ALTER TABLE products        ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_images  ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_sizes   ENABLE ROW LEVEL SECURITY;

-- Public read access
CREATE POLICY "Public read access for categories"
  ON categories FOR SELECT USING (true);

CREATE POLICY "Public read access for products"
  ON products FOR SELECT USING (true);

CREATE POLICY "Public read access for product_images"
  ON product_images FOR SELECT USING (true);

CREATE POLICY "Public read access for product_sizes"
  ON product_sizes FOR SELECT USING (true);
