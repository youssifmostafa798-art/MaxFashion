# 01 — Project Status

> **MaxFashion — Current Application State**
> Audit Date: August 16, 2026
> Project Version: 1.0.0+1

---

## Current Application State

MaxFashion is a **substantially complete** Flutter e-commerce fashion app. The core architecture, backend integration (Supabase), authentication, product browsing, cart, checkout, orders, profile management, search, wishlist, addresses, payment cards, and OTP-based password recovery are all implemented and wired end-to-end.

| Area | Status |
|------|--------|
| **Overall** | **~92% complete** |
| UI | ~95% — All core screens built with skeleton loading |
| Business Logic | ~95% — Auth, products, cart, wishlist, orders, addresses, payment cards fully on Supabase |
| Architecture | ~95% — Repository pattern established, auth-aware providers |
| Backend (Supabase) | ~92% — Auth, products, cart, wishlist, orders, home content, addresses, payment cards migrated |
| State Management | ~95% — Riverpod used consistently with auth-aware invalidation |
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
| — | Addresses | ✅ Completed (Supabase) |
| — | Payment Cards | ✅ Completed (Supabase) |
| — | OTP Password Recovery | ✅ Completed (Edge Functions + UI) |
| — | OTP Security Hardening | ✅ Completed |
| — | Data Isolation Audit & Fix | ✅ Completed |

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
| Addresses | ✅ | ✅ addresses table | ❌ | ✅ Completed |
| Payment Cards | ✅ | ✅ payment_cards table | ❌ | ✅ Completed |
| OTP Password Recovery | ✅ | ✅ password_reset_codes table + Edge Functions | ❌ | ✅ Completed |
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

### OTP Password Recovery
- `sendResetCode()` — calls `send-reset-code` Edge Function (sends 6-digit OTP via Resend API)
- `verifyResetCode()` — calls `reset-password` Edge Function to verify code
- `resetPasswordWithCode()` — calls `reset-password` Edge Function to update password
- `password_reset_codes` table stores OTP codes with expiry, attempt limiting, and rate limiting
- 3-page UI flow: ForgotPasswordPage → VerifyResetCodePage → ResetPasswordPage
- Security: 60-second rate limit between code requests, max 5 verification attempts per code, 10-minute code expiry

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
- Auth-aware provider (watches `currentUserIdProvider`)

### Wishlist
- `SupabaseWishlistRepository` — full CRUD (load, add, remove, check)
- `wishlist_items` table with RLS policies (user-owned)
- Product data joined from `products` table with images and sizes
- Duplicate detection (one entry per user per product)
- Auth-aware provider (watches `currentUserIdProvider`)

### Home Content
- `SupabaseHomeContentRepository` — fetches active home content
- `home_content` table with cover image URL
- Cover image loaded via `Image.network()` from Supabase Storage URL

### Orders
- `SupabaseOrderRepository` — full CRUD (load, add, update status)
- `orders` table with RLS policies (user-owned)
- `order_items` table with RLS policies (user-owned via orders)
- Order creation from checkout with historical snapshot preservation
- Auth-aware provider (watches `currentUserIdProvider`)

### Addresses
- `SupabaseAddressRepository` — full CRUD (load, add, update, delete, setDefault)
- `addresses` table with RLS policies (user-owned)
- Default address management with automatic reassignment on delete
- Auth-aware provider (watches `currentUserIdProvider`)

### Payment Cards
- `SupabasePaymentCardRepository` — full CRUD (load, add, delete, setDefault)
- `payment_cards` table with RLS policies (user-owned)
- Default card management with automatic reassignment on delete
- Duplicate card detection
- Auth-aware provider (watches `currentUserIdProvider`)

---

## What Is Still Using Local/SharedPreferences

| Feature | Storage Method | Key |
|---------|---------------|-----|
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
| `addresses` | varies | ✅ User-owned | ✅ In use |
| `payment_cards` | varies | ✅ User-owned | ✅ In use |
| `password_reset_codes` | varies | ✅ Anonymous (for OTP flow) | ✅ In use |

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
7. **Addresses migrated to Supabase** — `SupabaseAddressRepository` replaced SharedPreferences persistence. The `addresses` table has full RLS with user ownership (migration 014).
8. **Payment cards migrated to Supabase** — `SupabasePaymentCardRepository` replaced `PaymentCardStorage` (SharedPreferences). The `payment_cards` table has full RLS with user ownership (migration 015). `PaymentCardStorage` has been deleted.
9. **OTP-based password recovery implemented** — Full flow with `send-reset-code` and `reset-password` Edge Functions, `password_reset_codes` table (migrations 016-017), and 3-page UI (ForgotPasswordPage, VerifyResetCodePage, ResetPasswordPage).
10. **Data isolation audit & fix** — Cross-account data leakage fixed via `currentUserIdProvider` auto-invalidation. All user-scoped providers (`cartProvider`, `wishlistProvider`, `ordersProvider`, `addressProvider`, `paymentCardProvider`) now watch `currentUserIdProvider`. Lifecycle `mounted` checks added to all async methods in all notifiers.
11. **Legacy code removed** — `fake_auth_service.dart`, `auth_repository.dart` (data layer), `local_product_repository.dart`, `local_search_repository.dart`, `cart_storage.dart`, `cover_model.dart`, `payment_card_storage.dart` have all been deleted.
12. **SQL migration 008** cleaned up stale records (products 13, 120, 169 and category 12), leaving 248 products and 22 categories.
13. **SQL migrations 009-013** created cart, wishlist, orders, and category enhancement tables.
14. **SQL migration 014** created `addresses` table with RLS.
15. **SQL migration 015** created `payment_cards` table with RLS.
16. **SQL migration 016** created `password_reset_codes` table with RLS and `cleanup_expired_codes()` function.
17. **SQL migration 017** added OTP security hardening columns (attempt_count, last_request_at).

---

## Current Known Issues

| Issue | Severity | Status |
|-------|----------|--------|
| `ensureProfileExists` accessed via dynamic cast | Medium | Open |
| `isEmailConfirmationPending` accessed via dynamic cast | Medium | Open |
| 28 silently swallowed exceptions (`catch (_) {}`) | Medium | Open |
| Hardcoded Supabase URL in ProductModel and repositories | Low | Open |
| Promo code UI exists but non-functional | Low | Open |
| "Shop By" menu items are static UI only | Low | Open |
| Some screens use Navigator.push instead of named routes | Low | Open |
| Duplicate unique index on orders.order_number | Low | Open (cosmetic) |
| Dead `collection` and `keywords` getters in ProductModel | Low | Open |
| 3 duplicate search implementations | Low | Open |
| Bundled product images in assets/products_supa/ may bloat APK | Low | Open |

---

## Next Steps (Priority Order)

1. **Fix Dynamic Casts** — Add `ensureProfileExists` and `isEmailConfirmationPending` to `AuthRepositoryInterface`
2. **Exception Cleanup** — Audit and fix silently swallowed exceptions
3. **Dead Code Removal** — Remove `collection`/`keywords` getters, consolidate search implementations
4. **Real Payment Gateway** — Credit card form exists but no payment processing
5. **Order Cancellation UI** — No cancellation flow from user side
6. **Product Image Gallery** — Only single thumbnail displayed
7. **Testing** — Add unit and widget tests

---

*See [02_ARCHITECTURE.md](./02_ARCHITECTURE.md) for architecture details, [03_FEATURES_AND_DATA.md](./03_FEATURES_AND_DATA.md) for feature-by-feature status, and [04_ROADMAP_AND_TECHNICAL_DEBT.md](./04_ROADMAP_AND_TECHNICAL_DEBT.md) for remaining work.*
