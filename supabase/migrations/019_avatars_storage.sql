-- ============================================================
-- Avatars Storage Bucket & Policies
-- ============================================================
-- Formalizes the existing manually-created avatars bucket.
-- This migration mirrors the current Dashboard configuration exactly.
-- All 4 policies match production names and permissions.
-- ============================================================

-- Create bucket (idempotent — no error if already exists)
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- Storage Policies — exact production mirror
-- ============================================================

-- 1. Public read access
DROP POLICY IF EXISTS "Avatar images are publicly viewable" ON storage.objects;
CREATE POLICY "Avatar images are publicly viewable"
  ON storage.objects
  FOR SELECT
  TO anon, authenticated
  USING (bucket_id = 'avatars');

-- 2. Authenticated upload
DROP POLICY IF EXISTS "Authenticated users can upload avatars" ON storage.objects;
CREATE POLICY "Authenticated users can upload avatars"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'avatars');

-- 3. Authenticated update
DROP POLICY IF EXISTS "Authenticated users can update avatars" ON storage.objects;
CREATE POLICY "Authenticated users can update avatars"
  ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (bucket_id = 'avatars')
  WITH CHECK (bucket_id = 'avatars');

-- 4. Authenticated delete
DROP POLICY IF EXISTS "Authenticated users can delete avatars" ON storage.objects;
CREATE POLICY "Authenticated users can delete avatars"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (bucket_id = 'avatars');
