-- ============================================================
-- Full-Text Search Migration
-- Adds database-level product search with partial matching
-- and pagination via an RPC function.
-- ============================================================

-- 1. Enable the pg_trgm extension for trigram-based partial matching
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 2. Add a generated search_vector column to products
ALTER TABLE products
  ADD COLUMN search_vector tsvector
  GENERATED ALWAYS AS (
    setweight(to_tsvector('english', coalesce(name, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(brand, '')), 'B') ||
    setweight(to_tsvector('english', coalesce(description, '')), 'C')
  ) STORED;

-- 3. Create GIN indexes for fast full-text and trigram search
CREATE INDEX idx_products_search_vector ON products USING GIN (search_vector);
CREATE INDEX idx_products_name_trgm     ON products USING GIN (name gin_trgm_ops);

-- 4. RPC function: search_products
--    Accepts a query string, optional limit & offset for pagination.
--    Returns matching products with total count for the UI.
CREATE OR REPLACE FUNCTION search_products(
  p_query   TEXT,
  p_limit   INT DEFAULT 20,
  p_offset  INT DEFAULT 0
)
RETURNS TABLE (
  id              BIGINT,
  category_id     BIGINT,
  name            TEXT,
  description     TEXT,
  price           NUMERIC,
  discount_price  NUMERIC,
  brand           TEXT,
  thumbnail_url   TEXT,
  is_featured     BOOLEAN,
  is_available    BOOLEAN,
  total_count     BIGINT
)
LANGUAGE sql STABLE
AS $$
  WITH ranked AS (
    SELECT
      p.id,
      p.category_id,
      p.name,
      p.description,
      p.price,
      p.discount_price,
      p.brand,
      p.thumbnail_url,
      p.is_featured,
      p.is_available,
      COUNT(*) OVER () AS total_count
    FROM products p
    WHERE
      p.is_available = true
      AND (
        -- Full-text search (weighted tsvector match)
        p.search_vector @@ plainto_tsquery('english', p_query)
        -- Trigram similarity for partial / fuzzy matching
        OR p.name % p_query
        OR p.name ILIKE '%' || p_query || '%'
        OR p.brand ILIKE '%' || p_query || '%'
        OR p.description ILIKE '%' || p_query || '%'
      )
    ORDER BY
      -- Rank: exact phrase > full-text > trigram similarity
      CASE WHEN lower(p.name) = lower(p_query) THEN 0
           WHEN lower(p.name) LIKE lower(p_query) || '%' THEN 1
           WHEN p.search_vector @@ plainto_tsquery('english', p_query) THEN 2
           ELSE 3
      END,
      ts_rank(p.search_vector, plainto_tsquery('english', p_query)) DESC,
      similarity(p.name, p_query) DESC
  )
  SELECT * FROM ranked
  ORDER BY
    CASE WHEN lower(name) = lower(p_query) THEN 0
         WHEN lower(name) LIKE lower(p_query) || '%' THEN 1
         WHEN search_vector @@ plainto_tsquery('english', p_query) THEN 2
         ELSE 3
    END,
    ts_rank(search_vector, plainto_tsquery('english', p_query)) DESC,
    similarity(name, p_query) DESC
  LIMIT p_limit OFFSET p_offset;
$$;

-- 5. RPC function: search_products_count
--    Returns only the total count for a given query (for pagination UI).
CREATE OR REPLACE FUNCTION search_products_count(p_query TEXT)
RETURNS BIGINT
LANGUAGE sql STABLE
AS $$
  SELECT COUNT(*)
  FROM products
  WHERE
    is_available = true
    AND (
      search_vector @@ plainto_tsquery('english', p_query)
      OR name % p_query
      OR name ILIKE '%' || p_query || '%'
      OR brand ILIKE '%' || p_query || '%'
      OR description ILIKE '%' || p_query || '%'
    );
$$;
