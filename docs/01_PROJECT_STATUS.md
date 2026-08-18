# 01 — Project Status

> **MaxFashion — Current Application State**
> Audit Date: August 18, 2026
> Previous Audit: August 16, 2026
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
| 3.7 | Addresses | ✅ Completed |
| 3.8 | Payment Cards | ✅ Completed |
| 3.9 | OTP Password Recovery | ✅ Completed |
| 3.10 | OTP Security Hardening | ✅ Completed |
| — | Profiles Table Migration | ✅ Completed (`018_profiles_schema.sql`) |
| — | Avatars Storage Migration | ✅ Completed (`019_avatars_storage.sql`) |
| — | Data Isolation Audit & Fix | ✅ Completed |
| — | Avatar Race Condition Fix | ✅ Completed |

---

## Supabase Migration Status

| Feature | UI | Supabase | Local Persistence | Status |
|---------|-----|----------|-------------------|--------|
| Authentication | ✅ | ✅ Supabase Auth | ❌ | ✅ Completed |
| Profiles | ✅ | ✅ profiles table (migration 018) | ❌ | ✅ Completed |
| Avatar Upload | ✅ | ✅ avatars bucket (migration 019) | ❌ | ✅ Completed |
| Products | ✅ | ✅ products + joins | ❌ | ✅ Completed |
| Categories | ✅ | ✅ categories table | ❌ | ✅ Completed |
| Home Content | ✅ | ✅ home_content table | ❌ | ✅ Completed |
| Cart | ✅ | ✅ cart_items table | ❌ | ✅ Completed |
| Wishlist | ✅ | ✅ wishlist_items table | ❌ | ✅ Completed |
| Search | ✅ | ✅ Supabase RPC (full-text search) | ✅ Recent searches (not per-user) | 🟡 Partial |
| Orders | ✅ | ✅ orders + order_items tables | ❌ | ✅ Completed |
| Addresses | ✅ | ✅ addresses table | ❌ | ✅ Completed |
| Payment Cards | ✅ | ✅ payment_cards table | ❌ | ✅ Completed |
| OTP Password Recovery | ✅ | ✅ password_reset_codes + 3 Edge Functions | ❌ | ✅ Completed |
| Theme | ✅ | ❌ | ✅ SharedPreferences | ✅ Working (local is correct) |
| Settings | ✅ | ❌ | N/A | ✅ Working |

---

## What Is Connected to Supabase

### Auth
- Full Supabase Auth: signUp, signIn, signOut, session restore, email confirmation
- Profile CRUD on `profiles` table (migration 018)
- Avatar upload/remove via Supabase Storage `avatars` bucket (migration 019)
- Auth state listener for token refresh and sign-out events
- `ensureProfileExists` creates profile if missing after auth
- ⚠️ `ensureProfileExists` and `isEmailConfirmationPending` accessed via `as dynamic` casts (not on interface)

### OTP Password Recovery
- `sendResetCode()` — calls `send-reset-code` Edge Function (sends 6-digit OTP via Resend API)
- `verifyResetCode()` — calls `verify-reset-code` Edge Function (verifies code without changing password)
- `resetPasswordWithCode()` — calls `reset-password` Edge Function (updates password via admin API)
- `password_reset_codes` table stores OTP codes with expiry, attempt limiting, and rate limiting
- 3-page UI flow: ForgotPasswordPage → VerifyResetCodePage → ResetPasswordPage
- Security: 60-second rate limit between code requests, max 5 verification attempts per code, 10-minute code expiry
- ✅ **RLS correctly secured** — Migration 016 has NO anon policies. Edge functions use service_role which bypasses RLS.

### Products
- `SupabaseProductRepository` — fetches products with joined `product_images` and `product_sizes`
- `categoriesProvider` — reads from Supabase `categories` table
- Dynamic category resolution via `categoryNameById()` helper
- 248 products, 22 categories in live Supabase (after migration 008 cleanup)
- Product images served from Supabase Storage `product-images` bucket
- ⚠️ ProductModel `id` is String with `'p'` prefix — `toJson` sends invalid ID for DB writes

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
- ⚠️ OrderModel status serialized as int index — DB uses TEXT

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
- ⚠️ PaymentCardModel JSON keys are camelCase — DB columns are snake_case

---

## What Is Still Using Local/SharedPreferences

| Feature | Storage Method | Key | Intentional? |
|---------|---------------|-----|-------------|
| Theme | SharedPreferences | `theme_mode` (string) | ✅ Yes — app-wide preference, not user data |
| Recent Searches | SharedPreferences | `recent_searches` (JSON array) | ⚠️ No — should be per-user |
| Orders Migration Flag | SharedPreferences | `orders_migrated_to_supabase_{userId}` (bool) | ✅ Yes — per-user migration flag |

---

## Supabase Database Tables

| Table | Records | RLS | Status |
|-------|---------|-----|--------|
| `profiles` | varies | ✅ User-owned | ✅ In use (migration 018) |
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
| `password_reset_codes` | varies | ✅ Service-role only (no anon policies) | ✅ In use |

### Storage Buckets

| Bucket | Visibility | Purpose |
|--------|-----------|---------|
| `avatars` | Public read, owner write (migration 019) | Profile avatar images |
| `product-images` | Public read, service-role write | Product image storage |

### Edge Functions

| Function | Purpose | Status |
|----------|---------|--------|
| `send-reset-code` | Sends 6-digit OTP via Resend API email | ✅ In use |
| `verify-reset-code` | Verifies OTP code without changing password | ✅ In use |
| `reset-password` | Updates password via admin API | ✅ In use |

---

## Important Recent Architectural Changes

1. **Orders migrated to Supabase** — `SupabaseOrderRepository` replaced `OrdersRepository` (SharedPreferences). The `orders` and `order_items` tables have full RLS with user ownership. Local SharedPreferences orders were migrated via `OrdersMigrationService`.
2. **Cart-clear bug fixed** — `PlaceOrder._placeOrderAndConfirm()` now awaits order creation before clearing cart.
3. **Legacy Orders code removed** — `OrdersStorage`, `LocalOrderRepository`, and `orders_repository.dart` have been deleted.
4. **Cart migrated to Supabase** — `SupabaseCartRepository` replaced `CartStorage` (SharedPreferences).
5. **Wishlist migrated to Supabase** — `SupabaseWishlistRepository` replaced SharedPreferences persistence.
6. **Home content migrated to Supabase** — `home_content` table stores cover image URL.
7. **Addresses migrated to Supabase** — `SupabaseAddressRepository` replaced SharedPreferences persistence (migration 014).
8. **Payment cards migrated to Supabase** — `SupabasePaymentCardRepository` replaced `PaymentCardStorage` (migration 015).
9. **OTP-based password recovery implemented** — Full flow with 3 Edge Functions (`send-reset-code`, `verify-reset-code`, `reset-password`), `password_reset_codes` table (migrations 016-017), and 3-page UI.
10. **Profiles table formalized** — Migration `018_profiles_schema.sql` with RLS, FK to `auth.users`, `updated_at` trigger.
11. **Avatars storage formalized** — Migration `019_avatars_storage.sql` with 4 storage policies.
12. **Data isolation audit & fix** — Cross-account data leakage fixed via `currentUserIdProvider` auto-invalidation. All user-scoped providers watch `currentUserIdProvider`. Lifecycle `mounted` checks added to all notifiers.
13. **Avatar race condition fixed** — Auth notifier captured before async gap, `setUser()` runs unconditionally.
14. **SQL migration 008** cleaned up stale records (products 13, 120, 169 and category 12).
15. **SQL migrations 009-013** created cart, wishlist, orders, and category enhancement tables.
16. **SQL migration 014** created `addresses` table with RLS.
17. **SQL migration 015** created `payment_cards` table with RLS.
18. **SQL migration 016** created `password_reset_codes` table with RLS and `cleanup_expired_codes()` function.
19. **SQL migration 017** added OTP security hardening columns (attempt_count, last_request_at).

---

## Current Known Issues

| Issue | Severity | Status |
|-------|----------|--------|
| `ensureProfileExists` accessed via dynamic cast | Medium | Open |
| `isEmailConfirmationPending` accessed via dynamic cast | Medium | Open |
| Missing mounted check in logout | Medium | Open |
| 24 silently swallowed exceptions (`catch (_) {}`) | Medium | Open |
| No router auth guards — all 24 routes accessible without auth | High | Open |
| OrderModel serialization: status as int, camelCase keys | High | Open |
| PaymentCardModel serialization: camelCase keys vs snake_case DB | High | Open |
| CartItemModel serialization: extra non-DB fields in toJson | High | Open |
| ProductModel ID as String with 'p' prefix | High | Open |
| Recent searches not per-user | High | Open |
| Hardcoded Supabase URL in 3 files | Low | Open |
| Promo code UI exists but non-functional | Low | Open |
| "Shop By" menu items are static UI only | Low | Open |
| Dead `collection` and `keywords` getters in ProductModel | Low | Open |
| 3 duplicate search implementations | Low | Open |

---

## Next Steps (Priority Order)

1. **Fix Auth Interface** — Add methods to interface, remove `as dynamic` casts
2. **Fix Model Serialization** — OrderModel, PaymentCardModel, CartItemModel, ProductModel
3. **Implement Router Auth Guards** — Protect user-scoped routes
4. **Scope Recent Searches** — Key by user ID, clear on logout
5. **Fix Error Handling** — Wishlist, product providers
6. **Remove Fake Loading Delays** — Use real AsyncValue states
7. **Real Payment Gateway** — Credit card form exists but no payment processing
8. **Order Cancellation UI** — No cancellation flow from user side
9. **Product Image Gallery** — Only single thumbnail displayed
10. **Testing** — Add unit and widget tests

---

*See [02_ARCHITECTURE.md](./02_ARCHITECTURE.md) for architecture details, [03_FEATURES_AND_DATA.md](./03_FEATURES_AND_DATA.md) for feature-by-feature status, [04_ROADMAP_AND_TECHNICAL_DEBT.md](./04_ROADMAP_AND_TECHNICAL_DEBT.md) for remaining work, and [SUPABASE_REMAINING_WORK.md](./SUPABASE_REMAINING_WORK.md) for detailed Supabase audit.*
