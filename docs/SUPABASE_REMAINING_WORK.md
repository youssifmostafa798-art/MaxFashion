# Supabase Remaining Work

> **Generated:** Mon Aug 17 2026
> **Audit scope:** Entire Flutter project — every file in lib/, supabase/, assets/, scripts/, docs/
> **Rule:** Code is truth. Documentation is secondary.

---

## Project Status

Overall migration progress:

- **Completed:**
  - Core product catalog (categories, products, images, sizes) fully in Supabase with seed data
  - Cart items — Supabase CRUD with RLS, auth-aware provider
  - Wishlist items — Supabase CRUD with RLS, auth-aware provider
  - Orders + order items — Supabase CRUD with RLS, auth-aware provider
  - Addresses — Supabase CRUD with RLS, auth-aware provider
  - Payment cards — Supabase CRUD with RLS, auth-aware provider
  - Auth — signup, login, logout, password reset (OTP), profile update via Supabase
  - Home content — Supabase-backed cover image
  - Product images — uploaded to Supabase Storage (`product-images` bucket)
  - Avatar upload — Supabase Storage (`avatars` bucket)
  - 17 SQL migrations, 13 tables, 2 edge functions

- **Partially completed:**
  - User profile — code uses `profiles` table but **no migration exists** for it
  - Search — repository named `SupabaseSearchRepository` but queries are **entirely client-side**
  - Order model serialization — model fields don't match DB columns; `toJson`/`fromJson` broken
  - Payment card model serialization — all JSON keys are camelCase, DB uses snake_case
  - Cart item model — UI-layer DTO, not a DB mirror; `toJson` sends non-existent columns
  - Auth interface — `ensureProfileExists` and `isEmailConfirmationPending` not in abstract interface, forced `as dynamic` casts

- **Not started:**
  - `profiles` table migration
  - `avatars` bucket RLS migration
  - Per-user recent searches (currently shared across all users on device)
  - Promo code feature
  - Notifications preference sync
  - Language selection persistence
  - Router auth guards
  - Database indexes for text search

---

## Remaining Features

| Feature | Current Implementation | Supabase Status | Priority |
| -------- | --------------------- | ---------------- | -------- |
| Product catalog | Supabase read + Storage | Fully migrated | Done |
| Categories | Supabase read | Fully migrated | Done |
| Home cover | Supabase read | Fully migrated | Done |
| Cart | Supabase CRUD | Fully migrated | Done |
| Wishlist | Supabase CRUD | Fully migrated | Done |
| Orders | Supabase CRUD | Fully migrated (model issues) | Done |
| Addresses | Supabase CRUD | Fully migrated (model issues) | Done |
| Payment cards | Supabase CRUD | Fully migrated (model issues) | Done |
| Auth (signup/login/logout) | Supabase Auth | Fully migrated | Done |
| Password reset (OTP) | Edge functions + DB | Migrated (security issues) | Done |
| Profile view/edit | Supabase via auth repo | Migrated (no migration file) | HIGH |
| Product search | Client-side filter | **Fake Supabase** — needs real DB search | HIGH |
| Recent searches | SharedPreferences | **Not per-user** — data leaks between accounts | HIGH |
| Router auth guards | None | **All routes open** — guests access protected screens | HIGH |
| Password reset RLS | 3 anon policies on `password_reset_codes` | **FIXED** — All anon policies removed (Phase 1) | ✅ Fixed |
| Order model serialization | camelCase + int status | **Broken** — `toJson` sends wrong types | CRITICAL |
| Payment card model serialization | camelCase keys | **Broken** — won't round-trip to DB | CRITICAL |
| Cart item model serialization | Extra non-DB fields in `toJson` | **Broken** — sends non-existent columns | CRITICAL |
| Product model ID | Prefixed string `'p123'` | **Broken** — `toJson` sends invalid ID | CRITICAL |
| Profile migration | Code references `profiles` table | **FIXED** — Migration created (Phase 2) | ✅ Fixed |
| Promo codes | Static UI only | **Not implemented** | LOW |
| Notifications toggle | Local StateProvider | **Not synced** to Supabase | LOW |
| Language selector | Placeholder SnackBar | **Not implemented** | LOW |
| Shop By list | Hardcoded, no handlers | **Dead UI** | LOW |
| Guest mode | "Continue as Guest" navigates to main | **Broken** — all user-scoped providers fail for null user | MEDIUM |

---

## Detailed Audit

---

### 1. Product Model Serialization

**Current implementation:** `ProductModel` in `lib/data/models/product_model.dart`

**Files involved:**
- `lib/data/models/product_model.dart:1-113`
- `lib/data/repositories/cart/supabase_cart_repository.dart` (references ProductModel)
- `lib/data/repositories/wishlist/supabase_wishlist_repository.dart` (references ProductModel)
- `lib/data/repositories/product/supabase_product_repository.dart` (reads products)

**Problems found:**
1. **Line 84:** `id: 'p${json['id']}'` — DB stores `BIGINT`, model converts to string with `'p'` prefix. Any `toJson` call sends `'p123'` which fails DB writes.
2. **Line 101:** `toJson` returns the prefixed string ID — broken for any Supabase write operation.
3. **Lines 5-6:** Hardcoded Supabase storage URL `https://tonctmdcntftugdskqmb.supabase.co/storage/v1/object/public/product-images`.

**Missing Supabase components:** None — reads work. Writes are broken.

**Required migrations:** None.

**Required changes:**
- Change `id` field from `String` to `int` (matching `BIGINT`), or handle prefix only in UI layer
- Remove hardcoded storage URL — use env variable or constant
- Fix `toJson` to send raw integer ID

**Estimated complexity:** Medium (cascading changes to cart, wishlist, order item models that reference `productId` as `String`)

**Recommended execution order:** 1st — blocks correct serialization in 4 other models

---

### 2. Order Model Serialization

**Current implementation:** `OrderModel` in `lib/data/models/order_model.dart`

**Files involved:**
- `lib/data/models/order_model.dart:1-81`
- `lib/data/models/order_item_model.dart:1-76`
- `lib/data/repositories/orders/supabase_order_repository.dart:1-180`
- `lib/data/providers/orders_provider.dart:1-76`

**Problems found:**
1. **Line 67:** `status: status.index` — serializes `OrderStatus` enum as `int` index. DB column is `TEXT` (`'processing'`, `'shipped'`, etc.).
2. **Line 79:** `fromJson` reads `status` as `OrderStatus.values[json['status']]` — crashes on DB text values.
3. **Lines 69-80:** All `fromJson` keys are camelCase (`orderId`, `totalPrice`, `orderDate`), but DB uses snake_case (`id`, `total_price`, `created_at`).
4. **Missing fields:** `user_id`, `order_number`, `updated_at` not in model.
5. **Name mismatches:** Model `orderId` vs DB `id`; model `orderDate` vs DB `created_at`.

**OrderItemModel issues:**
1. **Line 4:** `productId` is `String` but DB `product_id` is `BIGINT`.
2. **Missing fields:** `id`, `order_id`, `created_at`.
3. **Lines 66-75:** `fromJson` uses camelCase keys.

**Required changes:**
- Serialize `OrderStatus` as `.name` (string), not `.index` (int)
- Rename fields or add `@JsonKey` annotations for snake_case mapping
- Add missing fields (`order_number`, `updated_at`)
- Fix `OrderItemModel.productId` to `int`

**Estimated complexity:** Medium-High (touches repository, provider, and all order-related UI)

---

### 3. Payment Card Model Serialization

**Current implementation:** `PaymentCardModel` in `lib/data/models/payment_card_model.dart`

**Files involved:**
- `lib/data/models/payment_card_model.dart:1-77`
- `lib/data/repositories/payment_card/supabase_payment_card_repository.dart:1-116`
- `lib/data/providers/payment_card_provider.dart:1-102`

**Problems found:**
1. **Lines 50-61:** `toJson` sends camelCase keys (`cardHolderName`, `last4Digits`, `expiryMonth`, etc.).
2. **Lines 63-73:** `fromJson` reads camelCase keys.
3. **DB columns** are snake_case (`card_holder_name`, `last4_digits`, `expiry_month`, etc.).
4. **Result:** Every `fromJson` returns null/empty for all fields when reading from Supabase. Every `toJson` sends non-existent column names.

**Missing fields:** `user_id`, `updated_at`.

**Required changes:**
- Add `@JsonKey(name: '...')` annotations for every field, or rename to snake_case and map in repository
- Add missing fields

**Estimated complexity:** Low (isolated to one model file + repository mapping)

---

### 4. Cart Item Model Serialization

**Current implementation:** `CartItemModel` in `lib/data/models/cart_item_model.dart`

**Files involved:**
- `lib/data/models/cart_item_model.dart:1-78`
- `lib/data/repositories/cart/supabase_cart_repository.dart:1-162`
- `lib/data/providers/cart_provider.dart:1-236`

**Problems found:**
1. **Lines 57-66:** `toJson` sends `product_name`, `product_image`, `selected_color`, `selected_size`, `unit_price` — none of these columns exist in the `cart_items` table.
2. **Lines 68-77:** `fromJson` expects these same non-existent columns.
3. **Model is a UI-layer DTO** with joined data (`productName`, `productImage`, `unitPrice`), not a DB mirror.
4. **Name mismatch:** DB column `size` vs model field `selectedSize`.
5. **Missing:** `user_id` field.

**Note:** The repository (`supabase_cart_repository.dart`) handles the join correctly for reads, but `toJson` is broken for writes. Currently, writes work because the repository constructs the insert payload directly rather than using `model.toJson()`.

**Required changes:**
- Separate DB model from UI model, or add a `toInsertJson()` method that only sends DB columns
- Ensure `fromJson` maps DB columns correctly for the repository's read path

**Estimated complexity:** Medium

---

### 5. Profile Table — Missing Migration

**Current implementation:** `ProfileModel` in `lib/features/auth/data/models/profile_model.dart`

**Files involved:**
- `lib/features/auth/data/models/profile_model.dart:1-125`
- `lib/features/auth/data/repositories/supabase_auth_repository.dart:58` (INSERT), `:130-160` (UPDATE)
- `lib/data/providers/auth_provider.dart` (reads profile)

**Problems found:**
1. **No SQL migration file exists** for the `profiles` table. It was likely created manually in the Supabase dashboard.
2. **Cannot audit RLS policies** without the schema definition.
3. **Cannot verify** whether RLS is enabled, whether policies use `auth.uid()`, or whether the table has proper constraints.
4. The `ProfileModel` uses `fromMap`/`toMap` (inconsistent with other models using `fromJson`/`toJson`).

**Missing Supabase components:**
- Migration file for `profiles` table
- RLS policies (SELECT/INSERT/UPDATE/DELETE with owner-only access)
- Indexes on `id` (primary key, likely already indexed)
- Foreign key to `auth.users(id)`

**Required migrations:**
- `018_profiles_schema.sql` — CREATE TABLE, RLS policies, foreign key, trigger for `updated_at`

**Estimated complexity:** Low (table likely exists; just needs formal migration)

**Recommended execution order:** 2nd — security-critical

---

### 6. Avatars Storage Bucket — Missing Migration

**Current implementation:** Upload in `supabase_auth_repository.dart:170-174`

**Files involved:**
- `lib/features/auth/data/repositories/supabase_auth_repository.dart:170-174`

**Problems found:**
1. No migration defines the `avatars` bucket or its RLS policies.
2. Code uses `getPublicUrl()` (line 174), suggesting the bucket is public — but this is not verified in migrations.
3. No INSERT/UPDATE/DELETE policies defined for authenticated users.

**Required migrations:**
- `019_avatars_storage.sql` — Bucket creation, RLS policies (public read, owner write)

**Estimated complexity:** Low

---

### 7. Search Repository — Fake Supabase Implementation

**Current implementation:** `SupabaseSearchRepository` in `lib/data/repositories/search/supabase_search_repository.dart`

**Files involved:**
- `lib/data/repositories/search/supabase_search_repository.dart:1-40`
- `lib/data/repositories/product/product_search_matcher.dart:1-41` (dead code)
- `lib/data/providers/search_provider.dart:1-155`

**Problems found:**
1. **`SupabaseSearchRepository` does zero Supabase queries.** It delegates to `_productRepo.getAllProducts()` (all products loaded in memory) and filters client-side.
2. **`product_search_matcher.dart`** contains in-memory search logic — entire file is dead code (never imported).
3. **`getPopularProducts()`** (line 37-39) returns the first 4 products with no popularity logic — dead code.
4. **No database-level text search** — performance degrades as product count grows.

**Missing Supabase components:**
- Supabase full-text search query (using `to_tsvector`/`to_tsquery` or `ilike`)
- Database index for product name search
- Server-side search with pagination

**Required migrations:**
- Index on `products.name` for text search
- Optionally: full-text search column with GIN index

**Estimated complexity:** Medium

---

### 8. Recent Searches — Not Per-User

**Current implementation:** `SearchNotifier` in `lib/data/providers/search_provider.dart`

**Files involved:**
- `lib/data/providers/search_provider.dart:129-141`

**Problems found:**
1. **SharedPreferences key `recent_searches`** is global — shared across all users on the same device.
2. When User A logs out and User B logs in, User B sees User A's recent searches.
3. `searchProvider` does NOT watch `currentUserIdProvider` — not reset on auth state change.

**Required changes:**
- Key recent searches by user ID (e.g., `recent_searches_{userId}`)
- Clear recent searches on logout
- Or migrate to Supabase `profiles` table as a JSON field

**Estimated complexity:** Low

---

### 9. Router — No Auth Guards

**Current implementation:** `AppRouter` in `lib/core/router/app_router.dart`

**Files involved:**
- `lib/core/router/app_router.dart:1-198`
- All screens accessible via named routes

**Problems found:**
1. **No route guards** — all 22 routes are accessible without authentication.
2. Guest users can navigate to: cart, wishlist, orders, addresses, payment methods, edit profile, order details.
3. These screens call Supabase with `auth.uid()` which is null for guests — operations silently fail or throw errors.
4. No redirect to login when unauthenticated user accesses protected routes.

**Required changes:**
- Add auth guard middleware in `onGenerateRoute`
- Define which routes require authentication
- Redirect to auth page for protected routes when user is null

**Estimated complexity:** Medium

---

### 10. Password Reset RLS — CRITICAL Security Vulnerability

**Current implementation:** `password_reset_codes` table RLS in `016_create_password_reset_codes.sql`

**Files involved:**
- `supabase/migrations/016_create_password_reset_codes.sql:30-53`
- `supabase/functions/send-reset-code/index.ts`
- `supabase/functions/reset-password/index.ts`

**Problems found:**
1. **Line 40-44:** `SELECT` policy `USING (true)` to `anon` — **any unauthenticated user can read ALL reset codes for ALL emails.**
2. **Line 47-52:** `UPDATE` policy `USING (true) WITH CHECK (true)` to `anon` — **anyone can update ANY record** (mark codes as used, change values).
3. **Line 35-38:** `INSERT` policy to `anon` — anyone can insert (needed for edge function, but edge functions use service role anyway).

**Attack scenario:**
1. Attacker calls `password_reset_codes` API (anon key, no auth)
2. Reads all active codes: `SELECT * FROM password_reset_codes WHERE used = false`
3. Gets the 6-digit code for any email
4. Uses it to reset that user's password

**Required changes:**
- Remove all 3 `anon` policies
- Edge functions already use service-role key — no client-side access needed
- Or: restrict to service-role only with no client policies

**Estimated complexity:** Low (SQL-only fix)

**Recommended execution order:** 1st — CRITICAL security fix

---

### 11. Edge Function Security Issues

**Files involved:**
- `supabase/functions/send-reset-code/index.ts`
- `supabase/functions/reset-password/index.ts`

**Problems found:**

#### send-reset-code
1. **Line 135-136:** `_devCode` returned in response body — **removed** ✅ Fixed Phase 1.
2. **Line 20:** CORS `*` — reviewed, safe for Flutter mobile app.
3. **Line 55:** `listUsers()` is O(n) — not yet fixed.
4. **Lines 107-120:** OTP stored as plaintext — not yet fixed.

#### reset-password
1. **Lines 43-81:** `attempt_count` is checked (`< 5`) and **now incremented on failed attempts** ✅ Fixed Phase 1.
2. **Line 84:** `listUsers()` is O(n) — not yet fixed.
3. **CORS `*`** — reviewed, safe for Flutter mobile app.

**Required changes:**
- Remove `_devCode` from response
- Increment `attempt_count` on failed verification
- Hash OTP codes before storage
- Replace `listUsers()` with direct query
- Tighten CORS to specific origins

**Estimated complexity:** Low-Medium

---

### 12. Auth Provider — Unsafe Dynamic Casts

**Current implementation:** `AuthNotifier` in `lib/data/providers/auth_provider.dart`

**Files involved:**
- `lib/data/providers/auth_provider.dart:98, 194, 212`
- `lib/features/auth/domain/auth_repository_interface.dart` (missing methods)
- `lib/features/auth/data/repositories/supabase_auth_repository.dart:67` (has the methods)

**Problems found:**
1. **Lines 98, 212:** `(_repository as dynamic).ensureProfileExists(...)` — `ensureProfileExists` is on `SupabaseAuthRepository` but NOT in `AuthRepositoryInterface`.
2. **Line 194:** `final repo = _repository as dynamic; if (repo.isEmailConfirmationPending == true)` — same issue.
3. **Line 299:** `state = const AuthState();` after `await _repository.signOut()` without `mounted` check.

**Required changes:**
- Add `ensureProfileExists` and `isEmailConfirmationPending` to `AuthRepositoryInterface`
- Remove `as dynamic` casts
- Add `mounted` check before state assignment in `logout()`

**Estimated complexity:** Low

---

### 13. Wishlist Provider — Silent Error Swallowing

**Current implementation:** `WishlistNotifier` in `lib/data/providers/wishlist_provider.dart`

**Files involved:**
- `lib/data/providers/wishlist_provider.dart:52, 59`

**Problems found:**
1. **Line 52:** `_repository.addToWishlist(dbProductId).catchError((_) {})` — errors silently swallowed.
2. **Line 59:** `_repository.removeFromWishlist(dbProductId).catchError((_) {})` — same.
3. If network fails, UI shows item as wishlisted/unwishlisted but server state is different — user sees a lie.

**Required changes:**
- Add proper error handling with state rollback
- Show error SnackBar on failure
- Revert optimistic UI update on error

**Estimated complexity:** Low

---

### 14. Product Provider — No Error Handling on Load

**Current implementation:** `product_provider.dart`

**Files involved:**
- `lib/data/providers/product_provider.dart:24-27`

**Problems found:**
1. **Line 25:** `repo.loadAll().then((_) { ... })` — no `.catchError()`.
2. If `loadAll()` fails, `productsLoaded` stays `false` forever — UI shows loading skeleton indefinitely.

**Required changes:**
- Add `.catchError()` or use `try/catch` with `AsyncValue`
- Expose error state to UI

**Estimated complexity:** Low

---

### 15. Hardcoded Supabase Storage URLs

**Files involved:**
- `lib/data/models/product_model.dart:5-6`
- `lib/data/repositories/cart/supabase_cart_repository.dart:12`
- `lib/data/repositories/orders/supabase_order_repository.dart:13`

**Problems found:**
1. All three contain `https://tonctmdcntftugdskqmb.supabase.co/storage/v1/object/public/product-images`.
2. If the Supabase project URL changes, three files must be updated.

**Required changes:**
- Extract to a single constant in `app_constants.dart` or read from `.env`

**Estimated complexity:** Low

---

### 16. Fake Loading Delays

**Files involved:**
- `lib/features/orders/presentation/pages/orders_page.dart:25` (600ms)
- `lib/features/wishlist/presentation/pages/wishlist_page.dart:27` (600ms)
- `lib/features/product/presentation/pages/product_detail_page.dart:37` (400ms)
- `lib/features/product/presentation/pages/product_listing_page.dart:30` (500ms)

**Problems found:**
1. These pages use `Future.delayed` with fake durations to simulate loading, even though data is fetched from Supabase.
2. The actual Supabase fetch may be faster or slower than the fake delay.
3. Creates inconsistent UX — user waits longer than necessary on fast connections.

**Required changes:**
- Remove fake delays
- Use real `AsyncValue` states from providers

**Estimated complexity:** Low

---

### 17. Guest Mode — Broken User-Scoped Features

**Current implementation:** `auth_page.dart` "Continue as Guest" button

**Files involved:**
- `lib/features/auth/presentation/pages/auth_page.dart:86` (navigates to main without login)
- `lib/data/providers/cart_provider.dart` (uses `currentUserIdProvider` — null for guests)
- `lib/data/providers/wishlist_provider.dart` (same)
- `lib/data/providers/orders_provider.dart` (same)
- `lib/data/providers/address_provider.dart` (same)
- `lib/data/providers/payment_card_provider.dart` (same)

**Problems found:**
1. Guest navigates to main screen with null user.
2. All user-scoped providers receive `null` as user ID.
3. Supabase queries with `user_id = null` return empty or fail.
4. Guest can attempt to add to cart, wishlist, place order — all fail silently or throw errors.
5. No UI feedback tells the guest they need to sign in.

**Required changes:**
- Either: block guest access to user-scoped features with "Sign in required" prompt
- Or: implement local-only guest cart/wishlist with migration on login
- Or: remove guest mode entirely

**Estimated complexity:** Medium-High

---

### 18. Orders Provider — No Loading State

**Files involved:**
- `lib/data/providers/orders_provider.dart:1-76`

**Problems found:**
1. State is `List<OrderModel>` — no `isLoading` or `error` field.
2. UI cannot distinguish between "still loading" and "empty orders".
3. Same issue in `AddressProvider`, `PaymentCardProvider`, `WishlistProvider`.

**Required changes:**
- Wrap state in a record/class with `isLoading`, `error`, and `data` fields
- Or use `AsyncValue<List<T>>` pattern

**Estimated complexity:** Medium

---

### 19. Dead Code

**Files involved:**
- `lib/data/repositories/product/product_search_matcher.dart:1-41` — entire file, never imported
- `lib/data/repositories/product/product_repository.dart:11` — `getFeaturedProducts()`, never called
- `lib/data/repositories/product/product_repository.dart:12-15` — `getHomeProducts()`, never called
- `lib/data/repositories/search/supabase_search_repository.dart:37-39` — `getPopularProducts()`, never called

**Required changes:**
- Delete dead files and methods

**Estimated complexity:** Low

---

### 20. Missing Database Indexes

**Current state:** 24 indexes defined across 9 tables.

**Missing indexes:**

| Table | Suggested Index | Reason |
|---|---|---|
| `categories` | `idx_categories_display_order` | UI orders by `display_order` (added in migration 012) |
| `products` | `idx_products_name` | Search by product name |
| `profiles` | (needs migration first) | Cannot audit without schema |

**Estimated complexity:** Low (SQL-only)

---

### 21. Missing RLS Policies

| Table | Status | Issue |
|---|---|---|
| `profiles` | **FIXED** — RLS with owner-only access (Phase 2) | ✅ Fixed |
| `password_reset_codes` | **FIXED** — No client policies; service-role only | ✅ Fixed Phase 1 |
| `categories` | OK | Read-only, public |
| `products` | OK | Read-only, public |
| `product_images` | OK | Read-only, public |
| `product_sizes` | OK | Read-only, public |
| `home_content` | OK | Read-only, active only |
| `cart_items` | OK | Owner-only CRUD |
| `wishlist_items` | OK | Owner-only (no UPDATE, acceptable) |
| `orders` | OK | Owner-only CRUD |
| `order_items` | OK | Owner-only via parent join |
| `addresses` | OK | Owner-only CRUD |
| `payment_cards` | OK | Owner-only CRUD |

---

### 22. Cross-Account Data Leakage Risks

| Risk | Location | Severity |
|---|---|---|
| Recent searches shared across users | `search_provider.dart:132,141` | HIGH |
| `password_reset_codes` readable by anyone | `016_create_password_reset_codes.sql:40-44` | **FIXED** — All anon policies removed (Phase 1) |
| Guest user operations with null user ID | Multiple providers | MEDIUM |

All other user-scoped data (cart, wishlist, orders, addresses, payment cards) properly filters by `auth.uid() = user_id` in both RLS and repository code.

---

### 23. Auth Synchronization Issues

| Issue | Location | Severity |
|---|---|---|
| No router auth guards | `app_router.dart` | HIGH |
| Missing `mounted` check in logout | `auth_provider.dart:299` | MEDIUM |
| `as dynamic` casts in auth provider | `auth_provider.dart:98,194,212` | HIGH |
| Search provider not reset on logout | `search_provider.dart:152-155` | MEDIUM |
| Product state persists across logout | `product_provider.dart` (global) | LOW |

---

### 24. Features That Can Fail After Logout/Login

| Feature | Failure Mode | Fix Required |
|---|---|---|
| Cart page | Supabase query with null user_id returns empty/error | Auth guard + provider reset |
| Wishlist page | Same | Auth guard + provider reset |
| Orders page | Same | Auth guard + provider reset |
| Addresses page | Same | Auth guard + provider reset |
| Payment methods page | Same | Auth guard + provider reset |
| Edit profile | Same | Auth guard + provider reset |
| Place order | Order insert fails with null user_id | Auth guard |
| Product detail add-to-cart | Cart insert fails silently | Auth guard or guest cart |

---

## Hidden Technical Debt

1. **ProductModel ID as String with prefix** — The `'p'` prefix pattern is used throughout the codebase (cart, wishlist, order items). Changing `ProductModel.id` to `int` requires updating every place that compares or passes product IDs. This is a **cross-cutting concern** affecting 6+ files.

2. **Dual model pattern** — `CartItemModel`, `OrderItemModel` are UI-layer DTOs with joined data, not DB mirrors. The repository layer manually constructs Supabase payloads instead of using `model.toJson()`. This works but is fragile — if someone calls `model.toJson()` for a write, it breaks.

3. **No formal profiles schema** — The `profiles` table was created outside migrations. This means: no version control, no reproducibility, no audit trail, no ability to spin up a fresh dev environment from migrations alone.

4. **`as dynamic` casts in auth** — 3 occurrences in `auth_provider.dart` bypass the type system. If `SupabaseAuthRepository` changes its method signatures, these fail at runtime with no compile-time warning.

5. **Repositories with mutable state** — `supabase_order_repository.dart` (line 93) and `supabase_product_repository.dart` (lines 14-15) maintain internal caches. Repositories should be stateless; caching belongs in the provider layer.

6. **Inconsistent model patterns** — `ProfileModel` uses `fromMap`/`toMap`; all others use `fromJson`/`toJson`. Some models handle snake_case mapping; others don't.

7. **No error boundaries** — Most screens delegate error handling to providers, but some providers (wishlist, product) silently swallow errors. There's no global error handling strategy.

8. **SharedPreferences for recent searches** — Device-level persistence for user-level data. The data model doesn't account for multi-user scenarios.

---

## TODO (Tomorrow's Work)

### CRITICAL Priority

- [x] **Fix `password_reset_codes` RLS** — Remove all 3 anon policies. Edge functions use service role. No client access needed. (`016_create_password_reset_codes.sql`) ✅ Fixed Phase 1
- [x] **Add `profiles` table migration** — Formalize the table with RLS, foreign key to `auth.users`, trigger for `updated_at`. (`018_profiles_schema.sql`) ✅ Created Phase 2
- [x] **Add `avatars` bucket migration** — Bucket config + RLS policies (public read, authenticated write). (`019_avatars_storage.sql`) ✅ Created Phase 2
- [x] **Increment `attempt_count` in `reset-password` edge function** — Brute-force protection is currently useless. (`reset-password/index.ts`) ✅ Fixed Phase 1
- [x] **Remove `_devCode` from `send-reset-code` response** — OTP leak in dev mode. (`send-reset-code/index.ts`) ✅ Fixed Phase 1

### HIGH Priority

- [ ] **Fix OrderModel serialization** — Serialize status as `.name` (string), rename fields to snake_case or add `@JsonKey` annotations. (`order_model.dart`, `order_item_model.dart`)
- [ ] **Fix PaymentCardModel serialization** — Add `@JsonKey(name: '...')` for all fields. (`payment_card_model.dart`)
- [ ] **Fix CartItemModel serialization** — Add `toInsertJson()` for DB writes, keep `toJson()` for UI. (`cart_item_model.dart`)
- [ ] **Fix ProductModel ID** — Change `id` from `String` to `int`, remove `'p'` prefix, update all consumers. (`product_model.dart` + 6 files)
- [ ] **Add `ensureProfileExists` and `isEmailConfirmationPending` to `AuthRepositoryInterface`** — Remove `as dynamic` casts. (`auth_repository_interface.dart`, `auth_provider.dart`)
- [ ] **Add `mounted` check in `logout()`** — `auth_provider.dart:299`.
- [ ] **Implement router auth guards** — Define protected routes, redirect unauthenticated users. (`app_router.dart`)
- [ ] **Scope recent searches by user** — Key by user ID, clear on logout. (`search_provider.dart`)
- [ ] **Implement real search** — Use Supabase `ilike` or full-text search. (`supabase_search_repository.dart`, `020_search_index.sql`)

### MEDIUM Priority

- [ ] **Fix wishlist error handling** — Roll back optimistic UI on failure, show error. (`wishlist_provider.dart:52,59`)
- [ ] **Fix product provider error handling** — Add `.catchError()` to `loadAll()`. (`product_provider.dart:25`)
- [ ] **Remove fake loading delays** — Use real `AsyncValue` states. (4 screen files)
- [ ] **Extract hardcoded storage URL** — Move to `app_constants.dart`. (`product_model.dart:5-6`, `supabase_cart_repository.dart:12`, `supabase_order_repository.dart:13`)
- [ ] **Add loading state to Orders/Address/PaymentCard/Wishlist providers** — Wrap in record with `isLoading`/`error`. (4 provider files)
- [ ] **Handle guest mode** — Either block user-scoped features or implement local guest storage. (`auth_page.dart`, multiple providers)
- [ ] **Hash OTP codes** — Store hashed, not plaintext. (`send-reset-code/index.ts`)
- [ ] **Replace `listUsers()` with direct query** — Both edge functions. (`send-reset-code/index.ts`, `reset-password/index.ts`)
- [ ] **Tighten CORS on edge functions** — Replace `*` with specific origins.

### LOW Priority

- [ ] **Delete dead code** — `product_search_matcher.dart`, `getFeaturedProducts()`, `getHomeProducts()`, `getPopularProducts()`.
- [ ] **Add `categories.display_order` index** — Used for UI ordering.
- [ ] **Add `products.name` index** — For text search.
- [ ] **Add `created_at`/`updated_at` to HomeContentModel** — Missing fields.
- [ ] **Add `id` to ProductSizeModel** — Missing field.
- [ ] **Standardize model patterns** — Either all use `fromMap`/`toMap` or all use `fromJson`/`toJson` with snake_case mapping.
- [ ] **Implement promo codes** — Currently static UI. (`promo_section.dart`)
- [ ] **Implement notifications preference** — Sync to Supabase. (`settings_page.dart`)
- [ ] **Implement language selector** — Currently placeholder. (`settings_page.dart`)
- [ ] **Implement Shop By handlers** — Currently dead UI. (`categories_page.dart:245-250`)
- [ ] **Automate `cleanup_expired_codes()`** — Database cron job or trigger. (`password_reset_codes`)
- [ ] **Add CSRF protection to edge functions.**
- [ ] **Add `DELETE` policy for `password_reset_codes`** — Or automate cleanup.

---

## Execution Plan

### Day 1 — CRITICAL Security + Schema (5 tasks)

**Morning:**
- [ ] Fix `password_reset_codes` RLS — remove anon policies
- [ ] Create `018_profiles_schema.sql` migration — table, RLS, foreign key, trigger
- [ ] Create `019_avatars_storage.sql` migration — bucket config, RLS policies

**Afternoon:**
- [ ] Fix `reset-password` edge function — increment `attempt_count`
- [ ] Fix `send-reset-code` edge function — remove `_devCode`, hash OTP

### Day 2 — Model Serialization Fixes (5 tasks)

**Morning:**
- [ ] Fix `OrderModel` — status as string, snake_case keys, missing fields
- [ ] Fix `OrderItemModel` — product_id as int, snake_case keys, missing fields
- [ ] Fix `PaymentCardModel` — `@JsonKey` annotations for all fields

**Afternoon:**
- [ ] Fix `CartItemModel` — add `toInsertJson()`, fix field names
- [ ] Fix `ProductModel` — change `id` to `int`, remove prefix, update all consumers (cart, wishlist, order item references)

### Day 3 — Auth & Security (5 tasks)

**Morning:**
- [ ] Add `ensureProfileExists` + `isEmailConfirmationPending` to `AuthRepositoryInterface`
- [ ] Remove `as dynamic` casts in `auth_provider.dart`
- [ ] Add `mounted` check in `logout()`

**Afternoon:**
- [ ] Implement router auth guards in `app_router.dart`
- [ ] Scope `searchProvider` recent searches by user ID, clear on logout

### Day 4 — Search & Error Handling (5 tasks)

**Morning:**
- [ ] Implement real Supabase search in `supabase_search_repository.dart`
- [ ] Add `products.name` index migration
- [ ] Fix wishlist error handling — rollback on failure

**Afternoon:**
- [ ] Fix product provider error handling — add catchError
- [ ] Remove fake loading delays from 4 screens

### Day 5 — Polish & Cleanup (remaining tasks)

**Morning:**
- [ ] Extract hardcoded storage URL to constant
- [ ] Add loading state to 4 providers (Orders, Address, PaymentCard, Wishlist)
- [ ] Delete dead code files and methods

**Afternoon:**
- [ ] Handle guest mode (block user-scoped features or implement guest storage)
- [ ] Add missing model fields (HomeContentModel timestamps, ProductSizeModel id)
- [ ] Tighten CORS on edge functions
- [ ] Final review and testing

---

## Appendix: File Reference Index

### Models
| File | Issue |
|---|---|
| `lib/data/models/product_model.dart` | ID as String with prefix, hardcoded URL |
| `lib/data/models/order_model.dart` | Status as int, camelCase keys, missing fields |
| `lib/data/models/order_item_model.dart` | product_id as String, camelCase keys, missing fields |
| `lib/data/models/payment_card_model.dart` | All JSON keys camelCase |
| `lib/data/models/cart_item_model.dart` | Extra non-DB fields in toJson |
| `lib/data/models/user_model.dart` | camelCase JSON keys |
| `lib/data/models/address_model.dart` | isDefault key mismatch |
| `lib/data/models/home_content_model.dart` | Missing timestamp fields |
| `lib/data/models/product_size_model.dart` | Missing id field |
| `lib/features/auth/data/models/profile_model.dart` | No migration, uses fromMap/toMap |

### Providers
| File | Issue |
|---|---|
| `lib/data/providers/auth_provider.dart` | Dynamic casts, missing mounted check |
| `lib/data/providers/product_provider.dart` | No error handling on load |
| `lib/data/providers/wishlist_provider.dart` | Silent error swallowing |
| `lib/data/providers/search_provider.dart` | Not per-user, no error handling |
| `lib/core/theme/theme_provider.dart` | No error handling in _loadTheme |

### Repositories
| File | Issue |
|---|---|
| `lib/data/repositories/search/supabase_search_repository.dart` | Fake Supabase — client-side only |
| `lib/data/repositories/product/supabase_product_repository.dart` | Mutable cache state |
| `lib/data/repositories/orders/supabase_order_repository.dart` | Hardcoded URL, mutable state |
| `lib/data/repositories/cart/supabase_cart_repository.dart` | Hardcoded URL |
| `lib/data/repositories/product/product_search_matcher.dart` | Dead code |

### Security
| File | Issue |
|---|---|
| `supabase/migrations/016_create_password_reset_codes.sql` | ✅ Fixed — Anon policies removed (Phase 1) |
| `supabase/functions/send-reset-code/index.ts` | ✅ Fixed — `_devCode` removed (Phase 1) |
| `supabase/functions/reset-password/index.ts` | ✅ Fixed — `attempt_count` now incremented (Phase 1) |
| `lib/core/router/app_router.dart` | No auth guards |

### Screens
| File | Issue |
|---|---|
| `lib/features/orders/presentation/pages/orders_page.dart` | Fake delay |
| `lib/features/wishlist/presentation/pages/wishlist_page.dart` | Fake delay, no error handling |
| `lib/features/product/presentation/pages/product_detail_page.dart` | Fake delay, no try/catch on cart add |
| `lib/features/product/presentation/pages/product_listing_page.dart` | Fake delay |
| `lib/features/auth/presentation/pages/signup_page.dart` | Missing mounted check on navigation |
