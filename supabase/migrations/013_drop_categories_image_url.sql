-- ============================================================
-- Drop unused image_url column from categories table
-- ============================================================
-- The image_url column was part of the original schema (001)
-- but was superseded by icon_name (012). It stored local asset
-- paths that were never used in the UI. Safe to remove.
-- ============================================================

ALTER TABLE categories DROP COLUMN IF EXISTS image_url;
