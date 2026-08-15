# 01 — Project Status

> **MaxFashion — Current Application State**
> Audit Date: August 15, 2026
> Project Version: 1.0.0+1

---

## Current Application State

MaxFashion is a **substantially complete** Flutter e-commerce fashion app. The core architecture, backend integration (Supabase), authentication, product browsing, cart, checkout, orders, profile management, search, and wishlist are all implemented and wired end-to-end.

| Area | Status |
|------|--------|
| **Overall** | **~88% complete** |
| UI | ~95% — All core screens built with skeleton loading |
| Business Logic | ~94% — Auth, products, cart, wishlist, orders fully on Supabase |
| Architecture | ~94% — Repository pattern established |
| Backend (Supabase) | ~85% — Auth, products, cart, wishlist, orders, home content migrated |
| State Management | ~90% — Riverpod used consistently |
| Testing | 0% — No tests beyond minimal smoke test |

---

## Phase Status

| Phase | Name | Status |
|-------|------|--------|
| 3.1 | Supabase Setup | ✅ Completed |
| 3.2 | Authentication | ✅ Completed |
| 3.3 | Products | ✅ Completed |
| 3.4 | Cart | ✅ Completed |
| 3.5 | Wishlist | ✅ Completed |
| 3.6 | Orders | ✅ Completed |

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
| Orders | ✅ | ✅ orders + order_items tables | ❌ | ✅ Completed |
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
- `ensureProfileExists` creates profile if missing after auth

### Products
- `SupabaseProductRepository` — fetches products with joined `product_images` and `product_sizes`
- `categoriesProvider` — reads from Supabase `categories` table
- Dynamic category resolution via `categoryNameById()` helper
- 248 products, 22 categories in live Supabase (after migration 008 cleanup)
- Product images served from Supabase Storage `product-images` bucket

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
- Cover image loaded via `Image.network()` from Supabase Storage URL

### Orders
- `SupabaseOrderRepository` — full CRUD (load, add, update status)
- `orders` table with RLS policies (user-owned)
- `order_items` table with RLS policies (user-owned via orders)
- Order creation from checkout with historical snapshot preservation
- Local SharedPreferences orders migrated via `OrdersMigrationService`

---

## What Is Still Using Local/SharedPreferences

| Feature | Storage Method | Key |
|---------|---------------|-----|
| Addresses | SharedPreferences | `saved_addresses` (JSON array) |
| Payment Cards | SharedPreferences | `saved_payment_cards` (JSON array) |
| Theme | SharedPreferences | `theme_mode` (string) |
| Recent Searches | SharedPreferences | `recent_searches` (JSON array) |

---

## Supabase Database Tables

| Table | Records | RLS | Status |
|-------|---------|-----|--------|
| `profiles` | varies | ✅ User-owned | ✅ In use |
| `categories` | 22 | ✅ Public read | ✅ In use |
| `products` | 248 | ✅ Public read | ✅ In use |
| `product_images` | 248 | ✅ Public read | ✅ In use |
| `product_sizes` | ~970 | ✅ Public read | ✅ In use |
| `cart_items` | varies | ✅ User-owned | ✅ In use |
| `wishlist_items` | varies | ✅ User-owned | ✅ In use |
| `home_content` | 1 | ✅ Public read (active) | ✅ In use |
| `orders` | varies | ✅ User-owned | ✅ In use |
| `order_items` | varies | ✅ User-owned (via orders) | ✅ In use |

### Storage Buckets

| Bucket | Visibility | Purpose |
|--------|-----------|---------|
| `avatars` | Public read, owner write | Profile avatar images |
| `product-images` | Public read, service-role write | Product image storage |

---

## Important Recent Architectural Changes

1. **Orders migrated to Supabase** — `SupabaseOrderRepository` replaced `OrdersRepository` (SharedPreferences). The `orders` and `order_items` tables have full RLS with user ownership. Local SharedPreferences orders were migrated via `OrdersMigrationService`.
2. **Cart-clear bug fixed** — `PlaceOrder._placeOrderAndConfirm()` now awaits order creation before clearing cart. Cart remains intact if order creation fails.
3. **Legacy Orders code removed** — `OrdersStorage`, `LocalOrderRepository`, and `orders_repository.dart` have been deleted.
4. **Cart migrated to Supabase** — `SupabaseCartRepository` replaced `CartStorage` (SharedPreferences). The `cart_items` table has full RLS with user ownership.
5. **Wishlist migrated to Supabase** — `SupabaseWishlistRepository` replaced SharedPreferences persistence. The `wishlist_items` table has full RLS with user ownership and product joins.
6. **Home content migrated to Supabase** — `home_content` table stores cover image URL.
7. **Legacy code removed** — `fake_auth_service.dart`, `auth_repository.dart` (data layer), `local_product_repository.dart`, `local_search_repository.dart`, `cart_storage.dart`, `cover_model.dart` have all been deleted.
8. **SQL migration 008** cleaned up stale records (products 13, 120, 169 and category 12), leaving 248 products and 22 categories.
9. **SQL migration 009** created `cart_items` table with RLS policies.
10. **SQL migration 010** created `wishlist_items` table with RLS policies.
11. **SQL migration 011** created `orders` and `order_items` tables with RLS policies.
12. **SQL migration 012** added dynamic category support.
13. **SQL migration 013** dropped `image_url` column from `categories` table (replaced by `icon_name`).

---

## Current Known Issues

| Issue | Severity | Status |
|-------|----------|--------|
| `ensureProfileExists` accessed via dynamic cast | Medium | Open |
| `isEmailConfirmationPending` accessed via dynamic cast | Medium | Open |
| 28 silently swallowed exceptions (`catch (_) {}`) | Medium | Open |
| Hardcoded Supabase URL in ProductModel and repositories | Low | Open |
| Forgot-password not implemented | Low | Open |
| Promo code UI exists but non-functional | Low | Open |
| "Shop By" menu items are static UI only | Low | Open |
| Some screens use Navigator.push instead of named routes | Low | Open |
| Duplicate unique index on orders.order_number | Low | Open (cosmetic) |
| Dead `collection` and `keywords` getters in ProductModel | Low | Open |
| 3 duplicate search implementations | Low | Open |
| Bundled product images in assets/products_supa/ may bloat APK | Low | Open |

---

## Next Steps (Priority Order)

1. **Address Migration** — Create `addresses` table, migrate from SharedPreferences
2. **Payment Card Migration** — Create `payment_cards` table or use third-party processor
3. **Forgot Password** — Implement Supabase password reset flow
4. **Fix Dynamic Casts** — Add `ensureProfileExists` and `isEmailConfirmationPending` to `AuthRepositoryInterface`
5. **Exception Cleanup** — Audit and fix silently swallowed exceptions
6. **Dead Code Removal** — Remove `collection`/`keywords` getters, consolidate search implementations
7. **Testing** — Add unit and widget tests

---

*See [02_ARCHITECTURE.md](./02_ARCHITECTURE.md) for architecture details, [03_FEATURES_AND_DATA.md](./03_FEATURES_AND_DATA.md) for feature-by-feature status, and [04_ROADMAP_AND_TECHNICAL_DEBT.md](./04_ROADMAP_AND_TECHNICAL_DEBT.md) for remaining work.*
