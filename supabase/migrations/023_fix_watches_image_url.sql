-- ============================================================
-- Fix Watches Collection image_url
-- ============================================================
-- The Watches collection image_url was set to 'Watches_Collection.jpg'
-- but the actual Storage object is 'Watches_Collection.png'.
-- This caused a 400 error when Flutter tried to load the image.
-- ============================================================

UPDATE public.collections
SET image_url = 'Watches_Collection.png'
WHERE name = 'Watches';
