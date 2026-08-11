-- ============================================================
-- Sync Cleanup: Remove stale records from Supabase
-- ============================================================
-- Aligns Supabase DB with cleaned local source data.
-- Deletes: products 13, 120, 169 and category 12.
-- ============================================================

BEGIN;

-- ============================================================
-- 1. PRECONDITION CHECKS
-- ============================================================

-- Verify target products exist
DO $$
DECLARE
  v_count INT;
BEGIN
  SELECT COUNT(*) INTO v_count FROM products WHERE id IN (13, 120, 169);
  IF v_count != 3 THEN
    RAISE EXCEPTION 'Precondition failed: expected 3 target products (13, 120, 169), found %', v_count;
  END IF;
END $$;

-- Verify target category exists
DO $$
DECLARE
  v_count INT;
BEGIN
  SELECT COUNT(*) INTO v_count FROM categories WHERE id = 12;
  IF v_count != 1 THEN
    RAISE EXCEPTION 'Precondition failed: expected category 12, found % rows', v_count;
  END IF;
END $$;

-- ============================================================
-- 2. DELETE CHILD RECORDS (explicit, before cascade)
-- ============================================================
-- product_sizes and product_images have ON DELETE CASCADE on
-- products(id), but we delete explicitly for safety and clarity.

DELETE FROM product_sizes
WHERE product_id IN (13, 120, 169);

DELETE FROM product_images
WHERE product_id IN (13, 120, 169);

-- ============================================================
-- 3. DELETE PRODUCTS
-- ============================================================

DELETE FROM products
WHERE id IN (13, 120, 169);

-- ============================================================
-- 4. VERIFY CATEGORY 12 HAS NO REMAINING PRODUCTS
-- ============================================================

DO $$
DECLARE
  v_count INT;
BEGIN
  SELECT COUNT(*) INTO v_count FROM products WHERE category_id = 12;
  IF v_count != 0 THEN
    RAISE EXCEPTION 'Safety check failed: category 12 still has % products', v_count;
  END IF;
END $$;

-- ============================================================
-- 5. DELETE CATEGORY 12
-- ============================================================

DELETE FROM categories
WHERE id = 12;

-- ============================================================
-- 6. POSTCONDITION VERIFICATION
-- ============================================================

DO $$
DECLARE
  v_products INT;
  v_images   INT;
  v_sizes    INT;
  v_cats     INT;
BEGIN
  SELECT COUNT(*) INTO v_products FROM products;
  SELECT COUNT(*) INTO v_images   FROM product_images;
  SELECT COUNT(*) INTO v_sizes    FROM product_sizes;
  SELECT COUNT(*) INTO v_cats     FROM categories;

  IF v_products != 244 THEN
    RAISE EXCEPTION 'Postcondition failed: expected 244 products, found %', v_products;
  END IF;
  IF v_images != 244 THEN
    RAISE EXCEPTION 'Postcondition failed: expected 244 product_images, found %', v_images;
  END IF;
  IF v_sizes != 977 THEN
    RAISE EXCEPTION 'Postcondition failed: expected 977 product_sizes, found %', v_sizes;
  END IF;
  IF v_cats != 22 THEN
    RAISE EXCEPTION 'Postcondition failed: expected 22 categories, found %', v_cats;
  END IF;

  -- Verify deleted records are gone
  IF EXISTS (SELECT 1 FROM products WHERE id IN (13, 120, 169)) THEN
    RAISE EXCEPTION 'Postcondition failed: products 13, 120, or 169 still exist';
  END IF;
  IF EXISTS (SELECT 1 FROM product_images WHERE product_id IN (13, 120, 169)) THEN
    RAISE EXCEPTION 'Postcondition failed: product_images for 13, 120, or 169 still exist';
  END IF;
  IF EXISTS (SELECT 1 FROM product_sizes WHERE product_id IN (13, 120, 169)) THEN
    RAISE EXCEPTION 'Postcondition failed: product_sizes for 13, 120, or 169 still exist';
  END IF;
  IF EXISTS (SELECT 1 FROM categories WHERE id = 12) THEN
    RAISE EXCEPTION 'Postcondition failed: category 12 still exists';
  END IF;

  -- Verify protected products still exist
  IF NOT EXISTS (SELECT 1 FROM products WHERE id IN (3,4,5,6,11,12,153,154,155,156,161,162,163,207,222)) THEN
    RAISE EXCEPTION 'Postcondition failed: one or more protected products (3,4,5,6,11,12,153,154,155,156,161,162,163,207,222) are missing';
  END IF;
END $$;

COMMIT;
