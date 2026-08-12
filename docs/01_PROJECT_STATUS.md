# 01 — Project Status

> **MaxFashion — Current Application State**
> Audit Date: August 12, 2026
> Project Version: 1.0.0+1

---

## Current Application State

MaxFashion is a **substantially complete** Flutter e-commerce fashion app. The core architecture, backend integration (Supabase), authentication, product browsing, cart, checkout, orders, profile management, search, and wishlist are all implemented and wired end-to-end.

| Area | Status |
|------|--------|
| **Overall** | **~88% complete** |
| UI | ~95% — All core screens built with skeleton loading |
| Business Logic | ~92% — Auth, products, cart, wishlist fully on Supabase |
| Architecture | ~92% — Repository pattern established |
| Backend (Supabase) | ~80% — Auth, products, cart, wishlist, home content migrated |
| State Management | ~90% — Riverpod used consistently |
| Testing | 0% — No tests yet |

---

## Phase Status

| Phase | Name | Status |
|-------|------|--------|
| 3.1 | Supabase Setup | ✅ Completed |
| 3.2 | Authentication | ✅ Completed |
| 3.3 | Products | ✅ Completed |
| 3.4 | Cart | ✅ Completed |
| 3.5 | Wishlist | ✅ Completed |
| 3.6 | Orders | ❌ Not Started (still SharedPreferences) |

**Current Phase:** 3.6 — Orders (next to migrate)

---

## Supabase Migration Status

| Feature | UI | Supabase | Local Persistence | Status |
|---------|-----|----------|-------------------|--------|
| Authentication | ✅ | ✅ Supabase Auth | ❌ | ✅ Completed |
| Profiles | ✅ | ✅ profiles table | ❌ | ✅ Completed |
| Avatar Upload | ✅ | ✅ avatars bucket | ❌ | ✅ Completed |
| Products | ✅ | ✅ products + joins | ❌ | ✅ Completed |
| Categories | ✅ | ✅ categories table | ❌ | ✅ Completed |
| Home Content | ✅ | ✅ home_content table | ❌ | ✅ Completed |
| Cart | ✅ | ✅ cart_items table | ❌ | ✅ Completed |
| Wishlist | ✅ | ✅ wishlist_items table | ❌ | ✅ Completed |
| Search | ✅ | ✅ in-memory (Supabase cache) | ✅ Recent searches | 🟡 Partial |
| Orders | ✅ | ❌ | ✅ SharedPreferences | ❌ Not Migrated |
| Addresses | ✅ | ❌ | ✅ SharedPreferences | ❌ Not Migrated |
| Payment Cards | ✅ | ❌ | ✅ SharedPreferences | ❌ Not Migrated |
| Theme | ✅ | ❌ | ✅ SharedPreferences | ✅ Working (local is correct) |
| Settings | ✅ | ❌ | N/A | ✅ Working |

---

## What Is Connected to Supabase

### Auth
- Full Supabase Auth: signUp, signIn, signOut, session restore, email confirmation
- Profile CRUD on `profiles` table
- Avatar upload/remove via Supabase Storage `avatars` bucket
- Auth state listener for token refresh and sign-out events

### Products
- `SupabaseProductRepository` — fetches products with joined `product_images` and `product_sizes`
- `categoriesProvider` — reads from Supabase `categories` table
- Dynamic category resolution via `categoryNameById()` helper
- 251 products, 23 categories, 251 images, 977 sizes in live Supabase

### Cart
- `SupabaseCartRepository` — full CRUD (load, add, update quantity, remove, clear)
- `cart_items` table with RLS policies (user-owned)
- Duplicate item detection (same product + size = merge quantities)
- Product data joined from `products` table

### Wishlist
- `SupabaseWishlistRepository` — full CRUD (load, add, remove, check)
- `wishlist_items` table with RLS policies (user-owned)
- Product data joined from `products` table with images and sizes
- Duplicate detection (one entry per user per product)

### Home Content
- `SupabaseHomeContentRepository` — fetches active home content
- `home_content` table with cover image URL
- Cover image loaded via `Image.network()` from URL

---

## What Is Still Using Local/SharedPreferences

| Feature | Storage Method | Key |
|---------|---------------|-----|
| Orders | SharedPreferences | `orders` (JSON array of order objects) |
| Addresses | SharedPreferences | `saved_addresses` (JSON array) |
| Payment Cards | SharedPreferences | `saved_payment_cards` (JSON array) |
| Theme | SharedPreferences | `theme_mode` (string) |
| Recent Searches | SharedPreferences | `recent_searches` (JSON array) |

---

## Supabase Database Tables

| Table | Records | RLS | Status |
|-------|---------|-----|--------|
| `profiles` | varies | ✅ User-owned | ✅ In use |
| `categories` | 23 | ✅ Public read | ✅ In use |
| `products` | 251 | ✅ Public read | ✅ In use |
| `product_images` | 251 | ✅ Public read | ✅ In use |
| `product_sizes` | 977 | ✅ Public read | ✅ In use |
| `cart_items` | varies | ✅ User-owned | ✅ In use |
| `wishlist_items` | varies | ✅ User-owned | ✅ In use |
| `home_content` | 1 | ✅ Public read (active) | ✅ In use |

### Storage Buckets

| Bucket | Visibility | Purpose |
|--------|-----------|---------|
| `avatars` | Public read, owner write | Profile avatar images |
| `product-images` | Public read, service-role write | Product image storage (for future use) |

---

## Important Recent Architectural Changes

1. **Cart migrated to Supabase** — `SupabaseCartRepository` replaced `CartStorage` (SharedPreferences). The `cart_items` table has full RLS with user ownership.
2. **Wishlist migrated to Supabase** — `SupabaseWishlistRepository` replaced SharedPreferences persistence. The `wishlist_items` table has full RLS with user ownership and product joins.
3. **Home content migrated to Supabase** — `home_content` table stores cover image URL.
4. **Legacy code removed** — `fake_auth_service.dart`, `auth_repository.dart` (data layer), `local_product_repository.dart`, `local_search_repository.dart`, `cart_storage.dart`, `cover_model.dart` have all been deleted.
5. **SQL migration 008** cleaned up stale records (products 13, 120, 169 and category 12), leaving 244 products and 22 categories.
6. **SQL migration 009** created `cart_items` table with RLS policies.
7. **SQL migration 010** created `wishlist_items` table with RLS policies.

---

## Current Known Issues

| Issue | Severity | Status |
|-------|----------|--------|
| `ensureProfileExists` accessed via dynamic cast | Medium | Open |
| Forgot-password not implemented | Low | Open |
| Promo code UI exists but non-functional | Low | Open |
| "Shop By" menu items are static UI only | Low | Open |
| Some screens use Navigator.push instead of named routes | Low | Open |

---

## Next Steps (Priority Order)

1. **Phase 3.6 — Orders Migration** — Create `orders` and `order_items` tables, implement `SupabaseOrdersRepository`, migrate from SharedPreferences
2. **Address Migration** — Create `addresses` table, migrate from SharedPreferences
3. **Forgot Password** — Implement Supabase password reset flow
4. **Cleanup** — Remove any remaining dead code, fix dynamic cast issue
5. **Testing** — Add unit and widget tests

---

*See [02_ARCHITECTURE.md](./02_ARCHITECTURE.md) for architecture details, [03_FEATURES_AND_DATA.md](./03_FEATURES_AND_DATA.md) for feature-by-feature status, and [04_ROADMAP_AND_TECHNICAL_DEBT.md](./04_ROADMAP_AND_TECHNICAL_DEBT.md) for remaining work.*
