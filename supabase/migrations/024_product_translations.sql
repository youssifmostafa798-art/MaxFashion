-- ============================================================
-- Product Content Localization Migration
-- Introduces product_translations for localized product
-- content (name / description) with locale-aware search.
-- ============================================================
-- Architecture:
--   products            -> language-independent shared data
--   product_translations-> one row per (product, locale)
--
-- Supported locales mirror the app (en, ar).
-- English content is backfilled from products.name/description,
-- after which product_translations is the authoritative source
-- for localized product content and search.
-- ============================================================

-- 1. Translation table
CREATE TABLE product_translations (
  id          BIGSERIAL PRIMARY KEY,
  product_id  BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  locale      TEXT NOT NULL CHECK (locale IN ('en', 'ar')),
  name        TEXT NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  UNIQUE (product_id, locale)
);

CREATE INDEX idx_product_translations_locale ON product_translations (locale);

-- 2. Full-text search vectors (per-language generated columns).
--    English keeps stemming parity with the previous products.search_vector;
--    Arabic uses the built-in 'arabic' dictionary.
ALTER TABLE product_translations
  ADD COLUMN search_vector_en tsvector GENERATED ALWAYS AS (
    setweight(to_tsvector('english', coalesce(name, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(description, '')), 'B')
  ) STORED,
  ADD COLUMN search_vector_ar tsvector GENERATED ALWAYS AS (
    setweight(to_tsvector('arabic', coalesce(name, '')), 'A') ||
    setweight(to_tsvector('arabic', coalesce(description, '')), 'B')
  ) STORED;

-- 3. Search indexes (pg_trgm was enabled in migration 020)
CREATE INDEX idx_product_translations_search_en ON product_translations USING GIN (search_vector_en);
CREATE INDEX idx_product_translations_search_ar ON product_translations USING GIN (search_vector_ar);
CREATE INDEX idx_product_translations_name_trgm ON product_translations USING GIN (name gin_trgm_ops);

-- 4. Backfill English translations from existing product content.
--    Idempotent: existing rows are never overwritten.
INSERT INTO product_translations (product_id, locale, name, description)
SELECT id, 'en', name, COALESCE(description, '')
FROM products
WHERE name IS NOT NULL AND btrim(name) <> ''
ON CONFLICT (product_id, locale) DO NOTHING;

-- 5. Retire legacy search artifacts on products.
--    Localized search now lives entirely on product_translations.
DROP INDEX IF EXISTS idx_products_name_trgm;
DROP INDEX IF EXISTS idx_products_search_vector;
ALTER TABLE products DROP COLUMN IF EXISTS search_vector;

-- 6. Deprecate language-dependent columns on products.
--    They remain as a transitional fallback only; the app reads
--    localized content exclusively from product_translations.
ALTER TABLE products ALTER COLUMN name DROP NOT NULL;
ALTER TABLE products ALTER COLUMN name SET DEFAULT '';
ALTER TABLE products ALTER COLUMN description DROP NOT NULL;

-- 7. Row Level Security (mirrors the public-read catalog policy
--    already used by categories/products/product_images/product_sizes;
--    catalog browsing is available to anonymous users pre-auth)
ALTER TABLE product_translations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read access for product_translations"
  ON product_translations FOR SELECT USING (true);

-- 8. RPC function: search_products
--    Locale-aware replacement of the previous signature.
--    MATCHING is strict: only the active locale's translation content
--    is matched (plus the language-neutral brand field). No silent
--    English fallback for Arabic queries.
--    DISPLAY resolution falls back en -> legacy column when the
--    active-locale translation is missing.
CREATE OR REPLACE FUNCTION search_products(
  p_query   TEXT,
  p_locale  TEXT DEFAULT 'en',
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
  WITH joined AS (
    SELECT
      p.id,
      p.category_id,
      p.price,
      p.discount_price,
      p.brand,
      p.thumbnail_url,
      p.is_featured,
      p.is_available,
      act.name AS active_name,
      COALESCE(act.description, '') AS active_description,
      CASE p_locale WHEN 'ar' THEN act.search_vector_ar ELSE act.search_vector_en END AS active_vector,
      fb.name AS fallback_name,
      COALESCE(fb.description, '') AS fallback_description,
      COALESCE(p.name, '') AS base_name,
      COALESCE(p.description, '') AS base_description
    FROM products p
    LEFT JOIN product_translations act
           ON act.product_id = p.id AND act.locale = p_locale
    LEFT JOIN product_translations fb
           ON fb.product_id = p.id AND fb.locale = 'en'
    WHERE p.is_available = true
  ),
  matches AS (
    SELECT
      j.*,
      COUNT(*) OVER () AS total_count,
      plainto_tsquery(CASE p_locale WHEN 'ar' THEN 'arabic' ELSE 'english' END, p_query) AS tsquery
    FROM joined j
    WHERE (
      -- Strict locale matching: active-locale translation content only.
      (j.active_vector IS NOT NULL AND j.active_vector @@ plainto_tsquery(CASE p_locale WHEN 'ar' THEN 'arabic' ELSE 'english' END, p_query))
      OR j.active_name % p_query
      OR j.active_name ILIKE '%' || p_query || '%'
      OR j.active_description ILIKE '%' || p_query || '%'
      -- Brand is language-independent shared data (preserved behavior).
      OR j.brand ILIKE '%' || p_query || '%'
    )
  ),
  ranked AS (
    SELECT
      m.*,
      COALESCE(m.active_name, m.fallback_name, m.base_name) AS resolved_name,
      CASE WHEN lower(COALESCE(m.active_name, m.fallback_name, m.base_name)) = lower(p_query) THEN 0
           WHEN lower(COALESCE(m.active_name, m.fallback_name, m.base_name)) LIKE lower(p_query) || '%' THEN 1
           WHEN m.active_vector @@ m.tsquery THEN 2
           ELSE 3
      END AS rank_tier,
      ts_rank(COALESCE(m.active_vector, ''::tsvector), m.tsquery) AS text_rank,
      similarity(COALESCE(m.active_name, ''), p_query) AS trigram_rank
    FROM matches m
  )
  SELECT
    id,
    category_id,
    resolved_name       AS name,
    COALESCE(active_description, fallback_description, base_description) AS description,
    price,
    discount_price,
    brand,
    thumbnail_url,
    is_featured,
    is_available,
    total_count
  FROM ranked
  ORDER BY rank_tier, text_rank DESC, trigram_rank DESC
  LIMIT p_limit OFFSET p_offset;
$$;

-- 9. RPC function: search_products_count (locale-aware replacement)
CREATE OR REPLACE FUNCTION search_products_count(
  p_query  TEXT,
  p_locale TEXT DEFAULT 'en'
)
RETURNS BIGINT
LANGUAGE sql STABLE
AS $$
  SELECT COUNT(*)
  FROM products p
  JOIN product_translations act
        ON act.product_id = p.id AND act.locale = p_locale
  WHERE p.is_available = true
    AND (
      (CASE p_locale WHEN 'ar' THEN act.search_vector_ar ELSE act.search_vector_en END)
        @@ plainto_tsquery(CASE p_locale WHEN 'ar' THEN 'arabic' ELSE 'english' END, p_query)
      OR act.name % p_query
      OR act.name ILIKE '%' || p_query || '%'
      OR COALESCE(act.description, '') ILIKE '%' || p_query || '%'
      OR p.brand ILIKE '%' || p_query || '%'
    );
$$;

-- 10. Remove the previous non-localized function signatures so the
--     locale-aware versions above are the single authoritative API.
DROP FUNCTION IF EXISTS search_products(TEXT, INT, INT);
DROP FUNCTION IF EXISTS search_products_count(TEXT);
