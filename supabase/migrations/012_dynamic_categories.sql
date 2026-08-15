-- ============================================================
-- Dynamic Categories Migration
-- Adds icon_name, display_order, is_active to categories table
-- ============================================================

-- Add new columns
ALTER TABLE categories ADD COLUMN icon_name TEXT;
ALTER TABLE categories ADD COLUMN display_order INTEGER DEFAULT 0;
ALTER TABLE categories ADD COLUMN is_active BOOLEAN DEFAULT TRUE;

-- Populate icon_name and display_order for existing categories
UPDATE categories SET icon_name = 'sunglasses_icon.png',    display_order = 1  WHERE id = 1;
UPDATE categories SET icon_name = 'watch_icon.png',         display_order = 2  WHERE id = 2;
UPDATE categories SET icon_name = 'jeans_icon.png',         display_order = 3  WHERE id = 3;
UPDATE categories SET icon_name = 'polo_icon.png',          display_order = 4  WHERE id = 4;
UPDATE categories SET icon_name = 'shirt_icon.png',         display_order = 5  WHERE id = 5;
UPDATE categories SET icon_name = 'shorts_icon.png',        display_order = 6  WHERE id = 6;
UPDATE categories SET icon_name = 't-shirt_icon.png',       display_order = 7  WHERE id = 7;
UPDATE categories SET icon_name = 'boots_icon.png',         display_order = 8  WHERE id = 8;
UPDATE categories SET icon_name = 'loafers_icon.png',       display_order = 9  WHERE id = 9;
UPDATE categories SET icon_name = 'running-shoe_icon.png',  display_order = 10 WHERE id = 10;
UPDATE categories SET icon_name = 'sneakers_icon.png',      display_order = 11 WHERE id = 11;
UPDATE categories SET icon_name = 'bracelet_icon.png',      display_order = 12 WHERE id = 13;
UPDATE categories SET icon_name = 'earrings_icon.png',      display_order = 13 WHERE id = 14;
UPDATE categories SET icon_name = 'necklace_icon.png',      display_order = 14 WHERE id = 15;
UPDATE categories SET icon_name = 'ring_icon.png',          display_order = 15 WHERE id = 16;
UPDATE categories SET icon_name = 'handbag_icon.png',       display_order = 16 WHERE id = 17;
UPDATE categories SET icon_name = 'blouse_icon.png',        display_order = 17 WHERE id = 18;
UPDATE categories SET icon_name = 'crop-top_icon.png',      display_order = 18 WHERE id = 19;
UPDATE categories SET icon_name = 'dress_icon.png',         display_order = 19 WHERE id = 20;
UPDATE categories SET icon_name = 'skirt_icon.png',         display_order = 20 WHERE id = 21;
UPDATE categories SET icon_name = 'wide_leg_icon.png',      display_order = 21 WHERE id = 22;
UPDATE categories SET icon_name = 'heels_icon.png',         display_order = 22 WHERE id = 23;
