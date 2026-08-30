# 05 — Supabase Migration Status

> **MaxFashion — Current Supabase Implementation & Migration Reference**
> Last Updated: August 30, 2026

---

## Phase Status

| Phase | Name | Status | Migration File |
|-------|------|--------|----------------|
| 3.1 | Supabase Setup | ✅ Completed | — |
| 3.2 | Authentication | ✅ Completed | — |
| 3.3 | Products | ✅ Completed | `001_products_schema.sql` – `005_seed_product_sizes.sql` |
| 3.4 | Cart | ✅ Completed | `009_cart_items_schema.sql` |
| 3.5 | Wishlist | ✅ Completed | `010_wishlist_items_schema.sql` |
| 3.6 | Orders | ✅ Completed | `011_orders_schema.sql` |
| 3.7 | Addresses | ✅ Completed | `014_addresses_schema.sql` |
| 3.8 | Payment Cards | ✅ Completed | `015_payment_cards_schema.sql` |
| 3.9 | OTP Password Recovery | ✅ Completed | `016_create_password_reset_codes.sql`, `017_otp_security_hardening.sql` |
| 3.10 | OTP Security Hardening | ✅ Completed | `017_otp_security_hardening.sql` |
| — | Profiles Table | ✅ Completed | `018_profiles_schema.sql` |
| — | Avatars Storage | ✅ Completed | `019_avatars_storage.sql` |
| — | Full-Text Search | ✅ Completed | `020_full_text_search.sql` |
| — | OTP Code Hashing | ✅ Completed | `021_otp_code_hashing.sql` |
| — | Collections Feature | ✅ Completed | `022_collections_schema.sql`, `023_fix_watches_image_url.sql` |
| — | Product Translations (reverted) | ⚠️ Historical | `024_product_translations.sql` (created), `025_restore_english_products.sql` (reverted) |

---

## Database Tables

| Table | Purpose | RLS | Status |
|-------|---------|-----|--------|
| `profiles` | User profile (extends auth.users) | User-owned (SELECT/INSERT/UPDATE) | ✅ In use |
| `categories` | Product categories (with icon_name, display_order) | Public read | ✅ In use |
| `products` | Core catalog items | Public read | ✅ In use |
| `product_images` | Multiple images per product | Public read | ✅ In use |
| `product_sizes` | Size/stock per product | Public read, UNIQUE(product_id, size) | ✅ In use |
| `cart_items` | User cart items | User-owned (full CRUD) | ✅ In use |
| `wishlist_items` | User wishlist items | User-owned (SELECT/INSERT/DELETE) | ✅ In use |
| `home_content` | Home page cover image | Public read (active only) | ✅ In use |
| `orders` | User orders | User-owned (full CRUD) | ✅ In use |
| `order_items` | Order line items | User-owned (via orders) | ✅ In use |
| `addresses` | User shipping addresses | User-owned (full CRUD) | ✅ In use |
| `payment_cards` | Saved payment methods | User-owned (full CRUD) | ✅ In use |
| `password_reset_codes` | OTP codes for password reset (SHA-256 hashed) | ✅ Service-role only (no anon policies) | ✅ In use |
| `collections` | Curated product collections | Public read (active only) | ✅ In use |
| `collection_categories` | Collection-to-category junction | Public read | ✅ In use |
| `product_translations` | Product content localization | ⚠️ Historical — created by 024, dropped by 025 | ❌ No longer in use |

### Table Schemas (Reference)

#### profiles
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK, FK → auth.users(id) |
| `full_name` | TEXT | NOT NULL |
| `phone_number` | TEXT | NOT NULL |
| `avatar_url` | TEXT | Nullable |
| `gender` | TEXT | Nullable |
| `date_of_birth` | TIMESTAMP | Nullable |
| `country` | TEXT | Nullable |
| `bio` | TEXT | Nullable |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT now() |
| `updated_at` | TIMESTAMP | NOT NULL, DEFAULT now() |

#### categories
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGINT | PK |
| `name` | TEXT | NOT NULL, UNIQUE |
| `slug` | TEXT | NOT NULL, UNIQUE |
| `icon_name` | TEXT | NOT NULL, DEFAULT '' |
| `display_order` | INTEGER | DEFAULT 0 |
| `is_active` | BOOLEAN | DEFAULT true |

**Note:** `image_url` column was dropped in migration 013. Categories now use `icon_name` to reference PNG icons in `assets/categories_icons/`.

#### products
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGINT | PK |
| `category_id` | BIGINT | FK → categories(id) |
| `name` | TEXT | NOT NULL |
| `description` | TEXT | DEFAULT '' |
| `price` | NUMERIC(10,2) | NOT NULL |
| `discount_price` | NUMERIC(10,2) | Nullable |
| `brand` | TEXT | DEFAULT 'MaxFashion' |
| `thumbnail_url` | TEXT | DEFAULT '' |
| `is_featured` | BOOLEAN | DEFAULT false |
| `is_available` | BOOLEAN | DEFAULT true |

#### product_images
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGINT | PK |
| `product_id` | BIGINT | FK → products(id) ON DELETE CASCADE |
| `image_url` | TEXT | NOT NULL |
| `sort_order` | INTEGER | DEFAULT 1 |

#### product_sizes
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGSERIAL | PK |
| `product_id` | BIGINT | FK → products(id) ON DELETE CASCADE |
| `size` | TEXT | NOT NULL |
| `stock` | INTEGER | DEFAULT 0 |

UNIQUE on (product_id, size).

#### cart_items
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK, DEFAULT gen_random_uuid() |
| `user_id` | UUID | FK → auth.users(id) ON DELETE CASCADE |
| `product_id` | BIGINT | FK → products(id) ON DELETE CASCADE |
| `size` | TEXT | Nullable |
| `quantity` | INTEGER | DEFAULT 1, CHECK >= 1 |
| `created_at` | TIMESTAMPTZ | DEFAULT now() |
| `updated_at` | TIMESTAMPTZ | DEFAULT now() |

#### wishlist_items
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK, DEFAULT gen_random_uuid() |
| `user_id` | UUID | FK → auth.users(id) ON DELETE CASCADE |
| `product_id` | BIGINT | FK → products(id) ON DELETE CASCADE |
| `created_at` | TIMESTAMPTZ | DEFAULT now() |

#### home_content
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGINT | PK, GENERATED BY DEFAULT AS IDENTITY |
| `cover_url` | TEXT | Nullable |
| `is_active` | BOOLEAN | DEFAULT true |
| `created_at` | TIMESTAMPTZ | DEFAULT now() |
| `updated_at` | TIMESTAMPTZ | DEFAULT now() |

#### orders
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK, DEFAULT gen_random_uuid() |
| `user_id` | UUID | FK → auth.users(id) ON DELETE CASCADE |
| `order_number` | TEXT | NOT NULL, UNIQUE |
| `total_price` | NUMERIC(10,2) | NOT NULL |
| `status` | TEXT | NOT NULL, DEFAULT 'processing' |
| `delivery_address` | TEXT | NOT NULL |
| `payment_method` | TEXT | NOT NULL |
| `created_at` | TIMESTAMPTZ | NOT NULL, DEFAULT now() |
| `updated_at` | TIMESTAMPTZ | NOT NULL, DEFAULT now() |

#### order_items
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK, DEFAULT gen_random_uuid() |
| `order_id` | UUID | FK → orders(id) ON DELETE CASCADE |
| `product_id` | BIGINT | FK → products(id) ON DELETE SET NULL |
| `product_name` | TEXT | NOT NULL |
| `product_image` | TEXT | NOT NULL, DEFAULT '' |
| `selected_color` | TEXT | Nullable |
| `selected_size` | TEXT | NOT NULL, DEFAULT 'S' |
| `quantity` | INTEGER | NOT NULL, DEFAULT 1, CHECK >= 1 |
| `unit_price` | NUMERIC(10,2) | NOT NULL |
| `created_at` | TIMESTAMPTZ | NOT NULL, DEFAULT now() |

#### addresses
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK |
| `user_id` | UUID | FK → auth.users(id) ON DELETE CASCADE |
| `street` | TEXT | NOT NULL |
| `apartment` | TEXT | Nullable |
| `city` | TEXT | NOT NULL |
| `state` | TEXT | NOT NULL |
| `country` | TEXT | NOT NULL |
| `zip` | TEXT | DEFAULT '' |
| `label` | TEXT | DEFAULT 'Home' |
| `is_default` | BOOL | DEFAULT false |
| `created_at` | TIMESTAMPTZ | DEFAULT now() |
| `updated_at` | TIMESTAMPTZ | DEFAULT now() |

#### payment_cards
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK |
| `user_id` | UUID | FK → auth.users(id) ON DELETE CASCADE |
| `card_holder_name` | TEXT | NOT NULL |
| `last4_digits` | TEXT | NOT NULL |
| `expiry_month` | TEXT | NOT NULL |
| `expiry_year` | TEXT | NOT NULL |
| `card_brand` | TEXT | DEFAULT 'unknown' |
| `is_default` | BOOL | DEFAULT false |
| `created_at` | TIMESTAMPTZ | DEFAULT now() |
| `updated_at` | TIMESTAMPTZ | DEFAULT now() |

#### password_reset_codes
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK |
| `email` | TEXT | NOT NULL |
| `code_hash` | TEXT | NOT NULL |
| `expires_at` | TIMESTAMPTZ | NOT NULL |
| `used` | BOOL | DEFAULT false |
| `attempt_count` | INT | DEFAULT 0 |
| `last_request_at` | TIMESTAMPTZ | DEFAULT NOW() |
| `created_at` | TIMESTAMPTZ | DEFAULT NOW() |

**Function:** `cleanup_expired_codes()` — deletes codes older than 1 hour past expiry.

**Note:** OTP codes are stored as SHA-256 hashes (migration 021), not plaintext. The `code` column was replaced by `code_hash`.

**⚠️ SECURITY NOTE:** Migration 016 creates RLS with NO client-side policies. The anon and authenticated roles have NO policies on this table. Edge Functions use service_role which bypasses RLS. This is correctly secured.

#### collections
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGINT | PK |
| `name` | TEXT | NOT NULL |
| `image_url` | TEXT | Nullable |
| `display_order` | INTEGER | DEFAULT 0 |
| `is_active` | BOOLEAN | DEFAULT true |
| `created_at` | TIMESTAMPTZ | DEFAULT now() |
| `updated_at` | TIMESTAMPTZ | DEFAULT now() |

**RLS:** Public read access for active collections only (`is_active = true`).
**Note:** `updated_at` auto-updates via trigger.

#### collection_categories
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGINT | PK |
| `collection_id` | BIGINT | FK → collections(id) ON DELETE CASCADE |
| `category_id` | BIGINT | FK → categories(id) ON DELETE CASCADE |

**RLS:** Public read access.
**Indexes:** Indexes on collection_id and category_id.
**Constraint:** UNIQUE on (collection_id, category_id).

---

## Storage Buckets

| Bucket | Purpose | Access Policy |
|--------|---------|---------------|
| `avatars` | Profile avatar images | Public read, owner write (authenticated users can upload/delete own avatar) |
| `product-images` | Product image storage | Public read, service-role write only (no client writes) |
| `collection-images` | Collection cover images | Public read, service-role write only (no client writes) |

---

## RLS Policies

| Table | Policy | Operation | Condition |
|-------|--------|-----------|-----------|
| `profiles` | Users can view own profile | SELECT | `auth.uid() = id` |
| `profiles` | Users can insert own profile | INSERT | `auth.uid() = id` |
| `profiles` | Users can update own profile | UPDATE | `auth.uid() = id` |
| `categories` | Public read access | SELECT | true |
| `products` | Public read access | SELECT | true |
| `product_images` | Public read access | SELECT | true |
| `product_sizes` | Public read access | SELECT | true |
| `cart_items` | Users can view own cart items | SELECT | `auth.uid() = user_id` |
| `cart_items` | Users can insert own cart items | INSERT | `auth.uid() = user_id` |
| `cart_items` | Users can update own cart items | UPDATE | `auth.uid() = user_id` |
| `cart_items` | Users can delete own cart items | DELETE | `auth.uid() = user_id` |
| `wishlist_items` | Users can view own wishlist items | SELECT | `auth.uid() = user_id` |
| `wishlist_items` | Users can insert own wishlist items | INSERT | `auth.uid() = user_id` |
| `wishlist_items` | Users can delete own wishlist items | DELETE | `auth.uid() = user_id` |
| `home_content` | Anyone can view active home content | SELECT | `is_active = true` |
| `orders` | Users can view own orders | SELECT | `auth.uid() = user_id` |
| `orders` | Users can insert own orders | INSERT | `auth.uid() = user_id` |
| `orders` | Users can update own orders | UPDATE | `auth.uid() = user_id` |
| `orders` | Users can delete own orders | DELETE | `auth.uid() = user_id` |
| `order_items` | Users can view own order items | SELECT | `EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid())` |
| `order_items` | Users can insert own order items | INSERT | `EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid())` |
| `order_items` | Users can update own order items | UPDATE | `EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid())` |
| `order_items` | Users can delete own order items | DELETE | `EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid())` |
| `addresses` | Users can view own addresses | SELECT | `auth.uid() = user_id` |
| `addresses` | Users can insert own addresses | INSERT | `auth.uid() = user_id` |
| `addresses` | Users can update own addresses | UPDATE | `auth.uid() = user_id` |
| `addresses` | Users can delete own addresses | DELETE | `auth.uid() = user_id` |
| `payment_cards` | Users can view own payment cards | SELECT | `auth.uid() = user_id` |
| `payment_cards` | Users can insert own payment cards | INSERT | `auth.uid() = user_id` |
| `payment_cards` | Users can update own payment cards | UPDATE | `auth.uid() = user_id` |
| `payment_cards` | Users can delete own payment cards | DELETE | `auth.uid() = user_id` |
| `password_reset_codes` | No client-side policies (service-role only) | N/A | N/A |
| `collections` | Anyone can view active collections | SELECT | `is_active = true` |
| `collection_categories` | Anyone can view collection categories | SELECT | true |

---

## Features Connected to Supabase

| Feature | Repository | Table/Service | Status |
|---------|-----------|---------------|--------|
| Authentication | `SupabaseAuthRepository` | Supabase Auth + `profiles` | ✅ Complete |
| Profile CRUD | `SupabaseAuthRepository` | `profiles` | ✅ Complete |
| Avatar Upload | `SupabaseAuthRepository` | Storage `avatars` bucket | ✅ Complete |
| Products | `SupabaseProductRepository` | `products` + `product_images` + `product_sizes` | ✅ Complete |
| Categories | `SupabaseProductRepository` | `categories` | ✅ Complete |
| Home Content | `SupabaseHomeContentRepository` | `home_content` | ✅ Complete |
| Cart | `SupabaseCartRepository` | `cart_items` | ✅ Complete |
| Wishlist | `SupabaseWishlistRepository` | `wishlist_items` | ✅ Complete |
| Search | `SupabaseSearchRepository` | `search_products` RPC (full-text search) | ✅ Complete |
| Orders | `SupabaseOrderRepository` | `orders` + `order_items` | ✅ Complete |
| Addresses | `SupabaseAddressRepository` | `addresses` | ✅ Complete |
| Payment Cards | `SupabasePaymentCardRepository` | `payment_cards` | ✅ Complete |
| Collections | `SupabaseCollectionRepository` | `collections` + `collection_categories` | ✅ Complete |
| OTP Password Recovery | `SupabaseAuthRepository` | Edge Functions + `password_reset_codes` | ✅ Complete |

---

## Features Still Using Local/Mock Persistence

| Feature | Storage | Key | Notes |
|---------|---------|-----|-------|
| Theme | SharedPreferences | `theme_mode` | Intentionally local. |
| Recent Searches | SharedPreferences | `recent_searches_{userId}` | Per-user scoped via userId key. |
| Orders Migration Flag | SharedPreferences | `orders_migrated_to_supabase_{userId}` | Per-user migration flag. |
| Search | Supabase RPC | `search_products` | Full-text search via RPC. Recent searches stored locally (per-user). |

---

## SQL Migrations

| # | File | Purpose |
|---|------|---------|
| 001 | `001_products_schema.sql` | Schema for categories, products, product_images, product_sizes + RLS |
| 002 | `002_seed_categories.sql` | INSERT 22 categories |
| 003 | `003_seed_products.sql` | INSERT 247 products |
| 004 | `004_seed_product_images.sql` | INSERT 248 images |
| 005 | `005_seed_product_sizes.sql` | INSERT 998 sizes |
| 006 | `006_home_content.sql` | home_content table + seed |
| 007 | `007_product_images_storage_policies.sql` | Storage RLS for product-images bucket |
| 008 | `008_sync_cleanup.sql` | Remove stale records (3 products, 1 category) |
| 009 | `009_cart_items_schema.sql` | cart_items table + RLS |
| 010 | `010_wishlist_items_schema.sql` | wishlist_items table + RLS |
| 011 | `011_orders_schema.sql` | orders + order_items tables + RLS |
| 012 | `012_dynamic_categories.sql` | Dynamic category support (icon_name, display_order, is_active) |
| 013 | `013_drop_categories_image_url.sql` | Drop image_url from categories |
| 014 | `014_addresses_schema.sql` | addresses table + RLS |
| 015 | `015_payment_cards_schema.sql` | payment_cards table + RLS |
| 016 | `016_create_password_reset_codes.sql` | password_reset_codes table + cleanup function + RLS (service-role only) |
| 017 | `017_otp_security_hardening.sql` | Rate limiting columns (attempt_count, last_request_at) |
| 018 | `018_profiles_schema.sql` | profiles table formalization + RLS + updated_at trigger |
| 019 | `019_avatars_storage.sql` | avatars bucket + storage policies (public read, owner write) |
| 020 | `020_full_text_search.sql` | pg_trgm extension, search_vector column, search_products RPC function |
| 021 | `021_otp_code_hashing.sql` | SHA-256 hashed OTP codes (code_hash column, pgcrypto extension) |
| 022 | `022_collections_schema.sql` | collections + collection_categories tables, collection-images bucket, seed data |
| 023 | `023_fix_watches_image_url.sql` | Fix Watches collection image URL extension |
| 024 | `024_product_translations.sql` | Product content localization — **historical, reverted by 025** |
| 025 | `025_restore_english_products.sql` | Restore English products, drop product_translations |

---

## Edge Functions

| Function | Purpose | Environment Variables |
|----------|---------|----------------------|
| `send-reset-code` | Sends 6-digit OTP via Resend API email (SHA-256 hashed before storage) | `RESEND_API_KEY` (optional, dev mode without it) |
| `verify-reset-code` | Verifies OTP code hash without changing password | Uses service_role |
| `reset-password` | Verifies OTP code hash, resets password via admin API, invalidates all sessions | Uses `SUPABASE_SERVICE_ROLE_KEY` |

---

## What Is Still Planned / Missing

| Item | Priority | Type | Notes |
|------|----------|------|-------|
| ~~Fix Auth Interface~~ | ~~HIGH~~ | ~~Code Quality~~ | ✅ Completed — methods are on `AuthRepositoryInterface` |
| ~~Add mounted check in logout~~ | ~~HIGH~~ | ~~Code Quality~~ | ✅ Completed — mounted check present |
| ~~Fix OrderModel serialization~~ | ~~HIGH~~ | ~~Code Quality~~ | ✅ Fixed — status serialized as string, fromJson handles both int and String |
| ~~Fix PaymentCardModel serialization~~ | ~~HIGH~~ | ~~Code Quality~~ | ✅ Fixed — toJson uses snake_case matching DB columns |
| Fix CartItemModel serialization | MEDIUM | Code Quality | Extra non-DB fields in toJson (model is UI-layer DTO) |
| Fix ProductModel ID | HIGH | Code Quality | ID as String with 'p' prefix — DB is BIGINT |
| Exception Cleanup | MEDIUM | Code Quality | 24 silently swallowed exceptions |
| Product image gallery | High | Feature | Only single thumbnail displayed |
| Order cancellation UI | High | Feature | No cancellation flow from user side |
| Delivery option | High | Feature | Hardcoded to "Pickup at store" only |
| Product reviews/ratings | Medium | Feature | No code found |
| Push notifications | Medium | Feature | No code found |
| Real payment gateway | High | Feature | Credit card form exists but no payment processing |

---

*See [01_PROJECT_STATUS.md](./01_PROJECT_STATUS.md) for overall status, [02_ARCHITECTURE.md](./02_ARCHITECTURE.md) for architecture, [03_FEATURES_AND_DATA.md](./03_FEATURES_AND_DATA.md) for feature details, [04_ROADMAP_AND_TECHNICAL_DEBT.md](./04_ROADMAP_AND_TECHNICAL_DEBT.md) for remaining work, and [SUPABASE_REMAINING_WORK.md](./SUPABASE_REMAINING_WORK.md) for detailed audit.*
