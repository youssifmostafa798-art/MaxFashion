-- ============================================================
-- MaxFashion Product Images Storage Policies
-- ============================================================
-- Run this in Supabase SQL Editor to create storage policies.
-- Bucket: product-images (public, created in Supabase Dashboard)
-- ============================================================

-- 1. Public READ access for product-images bucket
--    Allows anonymous and authenticated users to read product images
--    via the Supabase Storage API. Public URL access is automatic
--    for public buckets, but this policy enables API-based reads.
CREATE POLICY "Public read access for product-images"
  ON storage.objects
  FOR SELECT
  TO anon, authenticated
  USING (bucket_id = 'product-images');

-- 2. Service role WRITE access for product-images bucket
--    Only the service_role key can INSERT, UPDATE, or DELETE
--    product images. This key is used in server-side seed scripts
--    and bypasses RLS entirely.
--    No INSERT/UPDATE/DELETE policies for anon or authenticated users
--    means all client-side writes are DENIED.

-- ============================================================
-- SECURITY MODEL SUMMARY
-- ============================================================
-- SELECT (read):
--   - anon: ALLOWED (public bucket)
--   - authenticated: ALLOWED (public bucket)
--   - service_role: ALLOWED (bypasses RLS)
--
-- INSERT (upload):
--   - anon: DENIED (no policy)
--   - authenticated: DENIED (no policy)
--   - service_role: ALLOWED (bypasses RLS)
--
-- UPDATE (overwrite):
--   - anon: DENIED (no policy)
--   - authenticated: DENIED (no policy)
--   - service_role: ALLOWED (bypasses RLS)
--
-- DELETE (remove):
--   - anon: DENIED (no policy)
--   - authenticated: DENIED (no policy)
--   - service_role: ALLOWED (bypasses RLS)
-- ============================================================
