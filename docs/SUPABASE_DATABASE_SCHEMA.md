# SUPABASE DATABASE SCHEMA REFERENCE

> Generated: August 08, 2026
> Project: MaxFashion (Flutter E-Commerce)
> Backend: Supabase (PostgreSQL)

---

## Tables

### profiles

Stores public user data linked to Supabase Auth.

| Column | Type | Nullable | Default | Constraint |
|--------|------|----------|---------|------------|
| `id` | UUID | NOT NULL | | PRIMARY KEY, FK → `auth.users(id)` |
| `full_name` | TEXT | NOT NULL | '' | |
| `phone_number` | TEXT | NOT NULL | '' | |
| `avatar_url` | TEXT | YES | | |
| `gender` | TEXT | YES | | |
| `date_of_birth` | TIMESTAMP | YES | | |
| `country` | TEXT | YES | | |
| `bio` | TEXT | YES | | |
| `created_at` | TIMESTAMP | NOT NULL | `now()` | |
| `updated_at` | TIMESTAMP | NOT NULL | `now()` | |

**RLS:** Users can only SELECT/UPDATE their own row (`auth.uid() = id`).

---

### categories

Product categories for browsing and filtering.

| Column | Type | Nullable | Default | Constraint |
|--------|------|----------|---------|------------|
| `id` | BIGINT | NOT NULL | | PRIMARY KEY |
| `name` | TEXT | NOT NULL | | UNIQUE |
| `slug` | TEXT | NOT NULL | | UNIQUE |
| `image_url` | TEXT | NOT NULL | '' | |

**Indexes:** `idx_categories_slug` on `slug`

**RLS:** Public read access (`SELECT USING (true)`).

---

### products

Core product catalog items.

| Column | Type | Nullable | Default | Constraint |
|--------|------|----------|---------|------------|
| `id` | BIGINT | NOT NULL | | PRIMARY KEY |
| `category_id` | BIGINT | NOT NULL | | FK → `categories(id)` |
| `name` | TEXT | NOT NULL | | |
| `description` | TEXT | NOT NULL | '' | |
| `price` | NUMERIC(10,2) | NOT NULL | | |
| `discount_price` | NUMERIC(10,2) | YES | | |
| `brand` | TEXT | NOT NULL | 'MaxFashion' | |
| `thumbnail_url` | TEXT | NOT NULL | '' | |
| `is_featured` | BOOLEAN | NOT NULL | false | |
| `is_available` | BOOLEAN | NOT NULL | true | |

**Indexes:** `idx_products_category_id` on `category_id`, `idx_products_is_featured` on `is_featured`

**RLS:** Public read access (`SELECT USING (true)`).

---

### product_images

Multiple images per product for gallery display.

| Column | Type | Nullable | Default | Constraint |
|--------|------|----------|---------|------------|
| `id` | BIGINT | NOT NULL | | PRIMARY KEY |
| `product_id` | BIGINT | NOT NULL | | FK → `products(id)` ON DELETE CASCADE |
| `image_url` | TEXT | NOT NULL | | |
| `sort_order` | INTEGER | NOT NULL | 1 | |

**Indexes:** `idx_product_images_product_id` on `product_id`

**RLS:** Public read access (`SELECT USING (true)`).

---

### product_sizes

Available sizes and stock levels per product.

| Column | Type | Nullable | Default | Constraint |
|--------|------|----------|---------|------------|
| `id` | BIGSERIAL | NOT NULL | | PRIMARY KEY |
| `product_id` | BIGINT | NOT NULL | | FK → `products(id)` ON DELETE CASCADE |
| `size` | TEXT | NOT NULL | | |
| `stock` | INTEGER | NOT NULL | 0 | |

**Indexes:** `idx_product_sizes_product_id` on `product_id`, UNIQUE on `(product_id, size)`

**RLS:** Public read access (`SELECT USING (true)`).

---

## Tables Not Yet Implemented

The following tables are planned but do not exist yet:

| Table | Phase | Purpose |
|-------|-------|---------|
| `carts` | 3.4 | One active cart per authenticated user |
| `cart_items` | 3.4 | Line items within a cart |
| `wishlist_items` | 3.5 | Products saved by a user |
| `orders` | 3.6 | Placed purchase records |
| `order_items` | 3.6 | Line items within an order |
| `addresses` | 3.6 | Saved shipping addresses per user |

---

## Relationships

```text
auth.users (Supabase Auth)
    │
    │ 1:1
    v
profiles
    │
    ├──< categories
    │       │
    │       └──< products
    │               ├──< product_images
    │               └──< product_sizes
    │
    ├──< carts (NOT YET IMPLEMENTED)
    │       └──< cart_items
    │
    ├──< wishlist_items (NOT YET IMPLEMENTED)
    │
    ├──< orders (NOT YET IMPLEMENTED)
    │       └──< order_items
    │
    └──< addresses (NOT YET IMPLEMENTED)
```

### Implemented Relationships

| Parent | Child | FK Column | On Delete |
|--------|-------|-----------|-----------|
| `auth.users` | `profiles` | `id` | CASCADE |
| `categories` | `products` | `category_id` | RESTRICT |
| `products` | `product_images` | `product_id` | CASCADE |
| `products` | `product_sizes` | `product_id` | CASCADE |

---

## Storage Buckets

| Bucket | Visibility | Purpose |
|--------|-----------|---------|
| `avatars` | Public read, owner write | Profile avatar images |
| Product images | NOT CREATED | Product photography (hosting strategy TBD) |

---

## Seed Data Summary

| Table | Records | Source |
|-------|---------|--------|
| `categories` | 23 | `supabase/migrations/002_seed_categories.sql` |
| `products` | 251 | `supabase/migrations/003_seed_products.sql` |
| `product_images` | 251 | `supabase/migrations/004_seed_product_images.sql` |
| `product_sizes` | 997 | `supabase/migrations/005_seed_product_sizes.sql` |

---

*End of Schema Reference — MaxFashion Supabase Database*
