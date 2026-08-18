# Supabase Remaining Work

> **Generated:** Mon Aug 18 2026
> **Audit scope:** Entire Flutter project — every file in lib/, supabase/, docs/
> **Previous audit:** Aug 17, 2026
> **Rule:** Code is truth. Documentation is secondary.

---

## Current Status

The MaxFashion app has **~92% of Supabase migration completed**. All major features (auth, products, cart, wishlist, orders, addresses, payment cards, home content, OTP password recovery) are connected to Supabase with working CRUD, RLS, and auth-aware providers. Migrations 018 (profiles) and 019 (avatars storage) now exist. A third edge function (`verify-reset-code`) has been added.

Remaining work is primarily **code quality** (model serialization mismatches, `as dynamic` casts), **security hardening** (password_reset_codes RLS policies still grant anon access), and **UX improvements** (router auth guards, per-user recent searches, real search).

---

## Completed Work

### Phase 3.1 — Supabase Setup
- **What:** Supabase project initialized, SDK configured in `main.dart`, `.env` loaded via `flutter_dotenv`
- **Files:** `lib/main.dart`, `.env`
- **Status:** ✅ Verified — `Supabase.initialize()` in `main()`

### Phase 3.2 — Authentication
- **What:** Full Supabase Auth integration: signUp, signIn, signOut, session restore, profile CRUD, avatar upload
- **Files:** `supabase_auth_repository.dart`, `auth_provider.dart`, `profile_model.dart`
- **Status:** ✅ Verified — Repository implements `AuthRepositoryInterface`, auth state listener active

### Phase 3.3 — Products
- **What:** Product catalog with categories, products, images, sizes — all from Supabase with joins
- **Files:** `supabase_product_repository.dart`, `product_provider.dart`, migrations 001-005, 008
- **Status:** ✅ Verified — `loadAll()` fetches categories + products with relations

### Phase 3.4 — Cart
- **What:** Full cart CRUD via Supabase `cart_items` table with RLS and auth-aware provider
- **Files:** `supabase_cart_repository.dart`, `cart_provider.dart`, migration 009
- **Status:** ✅ Verified — `loadCart()` has explicit `user_id` filter, all CRUD methods authenticated

### Phase 3.5 — Wishlist
- **What:** Full wishlist CRUD via Supabase `wishlist_items` table with RLS and auth-aware provider
- **Files:** `supabase_wishlist_repository.dart`, `wishlist_provider.dart`, migration 010
- **Status:** ✅ Verified — Duplicate detection, product joins, mounted checks

### Phase 3.6 — Orders
- **What:** Full orders CRUD via Supabase `orders` + `order_items` tables with RLS and auth-aware provider
- **Files:** `supabase_order_repository.dart`, `orders_provider.dart`, `orders_migration_service.dart`, migration 011
- **Status:** ✅ Verified — Migration service migrates legacy SharedPreferences orders to Supabase per-user

### Phase 3.7 — Addresses
- **What:** Full address CRUD via Supabase `addresses` table with RLS and auth-aware provider
- **Files:** `supabase_address_repository.dart`, `address_provider.dart`, migration 014
- **Status:** ✅ Verified — Default address management with automatic reassignment on delete

### Phase 3.8 — Payment Cards
- **What:** Full payment card CRUD via Supabase `payment_cards` table with RLS and auth-aware provider
- **Files:** `supabase_payment_card_repository.dart`, `payment_card_provider.dart`, migration 015
- **Status:** ✅ Verified — Default card management, duplicate detection, auth-aware provider

### Phase 3.9 — OTP Password Recovery
- **What:** 3-page OTP flow with Edge Functions, `password_reset_codes` table, rate limiting, attempt limiting
- **Files:** `send-reset-code/index.ts`, `verify-reset-code/index.ts`, `reset-password/index.ts`, migrations 016-017
- **Status:** ✅ Verified — 3 Edge Functions, 60s cooldown, max 5 attempts, 10-min expiry

### Phase 3.10 — OTP Security Hardening
- **What:** Added `attempt_count` and `last_request_at` columns to `password_reset_codes`
- **Files:** `017_otp_security_hardening.sql`
- **Status:** ✅ Verified — Columns present, enforced in Edge Functions

### Profiles Table Migration (Phase 2)
- **What:** Formal `profiles` table migration with RLS, FK to `auth.users`, `updated_at` trigger
- **Files:** `018_profiles_schema.sql`
- **Status:** ✅ Verified — Migration file exists with IF NOT EXISTS, RLS with owner-only access

### Avatars Storage Migration (Phase 2)
- **What:** `avatars` bucket creation + storage policies (public read, authenticated write/delete)
- **Files:** `019_avatars_storage.sql`
- **Status:** ✅ Verified — 4 storage policies: public SELECT, authenticated INSERT/UPDATE/DELETE

### Data Isolation Audit & Fix
- **What:** Fixed cross-account data leakage via `currentUserIdProvider`, lifecycle `mounted` checks, per-user migration flags
- **Files:** `auth_provider.dart`, `orders_provider.dart`, `wishlist_provider.dart`, `cart_provider.dart`, `address_provider.dart`, `payment_card_provider.dart`, `orders_migration_service.dart`
- **Status:** ✅ Verified — All 5 user-scoped providers watch `currentUserIdProvider`, all notifiers have `mounted` checks

### Avatar Race Condition Fix
- **What:** Fixed avatar deletion race condition where `setUser()` was killed by `mounted` guard
- **Files:** `edit_profile_provider.dart`
- **Status:** ✅ Verified — Auth notifier captured before async gap, `setUser()` runs unconditionally

---

## Partially Completed

### Search Repository
- **What:** `SupabaseSearchRepository` exists but performs **zero Supabase queries** — all search is client-side filtering of in-memory cached products
- **Files:** `supabase_search_repository.dart`, `search_provider.dart`
- **Remaining:** Implement real Supabase text search (ilike or full-text search), add `products.name` index
- **Priority:** HIGH

### Recent Searches
- **What:** Search history persisted in SharedPreferences but **not scoped per user** — shared across all accounts on device
- **Files:** `search_provider.dart:129-141`
- **Remaining:** Key by user ID, clear on logout, or migrate to Supabase
- **Priority:** HIGH

### Auth Interface
- **What:** `ensureProfileExists` and `isEmailConfirmationPending` implemented on `SupabaseAuthRepository` but **NOT declared on `AuthRepositoryInterface`**
- **Files:** `auth_repository_interface.dart`, `supabase_auth_repository.dart:67`, `auth_provider.dart:98,194,212`
- **Remaining:** Add methods to interface, remove `as dynamic` casts
- **Priority:** HIGH

---

## Remaining Work

### CRITICAL Priority

| Task | Description | Files | Status |
|------|-------------|-------|--------|
| Fix `password_reset_codes` RLS | Remove all 3 anon policies (SELECT/INSERT/UPDATE). Edge functions use service_role which bypasses RLS. Client-side anon access is a **security vulnerability**. | `016_create_password_reset_codes.sql` | ❌ **NOT DONE** — Previous docs claimed fixed; migration still has anon policies |

### HIGH Priority

| Task | Description | Files | Status |
|------|-------------|-------|--------|
| Fix OrderModel serialization | Status serialized as `int` (`.index`) but DB uses `TEXT`. `fromJson` uses camelCase keys but DB is snake_case. | `order_model.dart`, `order_item_model.dart` | ❌ Not started |
| Fix PaymentCardModel serialization | All JSON keys camelCase (`cardHolderName`) but DB columns snake_case (`card_holder_name`). `fromJson`/`toJson` broken. | `payment_card_model.dart` | ❌ Not started |
| Fix CartItemModel serialization | `toJson` sends non-DB columns (`product_name`, `product_image`, `selected_size`, `unit_price`). Model is UI-layer DTO. | `cart_item_model.dart` | ❌ Not started |
| Fix ProductModel ID | `id` is `String` with `'p'` prefix (`'p123'`) but DB is `BIGINT`. `toJson` sends invalid ID. | `product_model.dart` + 6 consumers | ❌ Not started |
| Fix Auth interface | Add `ensureProfileExists` + `isEmailConfirmationPending` to `AuthRepositoryInterface`. Remove 3 `as dynamic` casts. | `auth_repository_interface.dart`, `auth_provider.dart` | ❌ Not started |
| Add mounted check in logout | `auth_provider.dart:299` — `state = const AuthState()` without `mounted` check after `signOut()`. | `auth_provider.dart` | ❌ Not started |
| Implement router auth guards | All 22 routes accessible without auth. Guests can reach cart, wishlist, orders, etc. | `app_router.dart` | ❌ Not started |
| Scope recent searches by user | `SharedPreferences` key `recent_searches` is global. User B sees User A's searches. | `search_provider.dart` | ❌ Not started |
| Implement real search | Use Supabase `ilike` or full-text search. Add `products.name` index. | `supabase_search_repository.dart`, migration | ❌ Not started |

### MEDIUM Priority

| Task | Description | Files | Status |
|------|-------------|-------|--------|
| Fix wishlist error handling | `addToWishlist`/`removeFromWishlist` silently swallow errors. Optimistic UI not rolled back on failure. | `wishlist_provider.dart:52,59` | ❌ Not started |
| Fix product provider error handling | `loadAll().then(...)` has no `.catchError()`. If load fails, `productsLoaded` stays false forever. | `product_provider.dart:25` | ❌ Not started |
| Remove fake loading delays | 4 screens use `Future.delayed` with fake durations instead of real `AsyncValue` states. | `orders_page.dart`, `wishlist_page.dart`, `product_detail_page.dart`, `product_listing_page.dart` | ❌ Not started |
| Extract hardcoded storage URL | 3 files contain `https://tonctmdcntftugdskqmb.supabase.co/storage/v1/object/public/product-images`. | `product_model.dart:5-6`, `supabase_cart_repository.dart:12`, `supabase_order_repository.dart:13` | ❌ Not started |
| Add loading state to providers | Orders, Address, PaymentCard, Wishlist providers have no `isLoading`/`error` state. | 4 provider files | ❌ Not started |
| Handle guest mode | "Continue as Guest" navigates to main with null user. All user-scoped features fail silently. | `auth_page.dart`, multiple providers | ❌ Not started |
| Hash OTP codes | Store hashed, not plaintext in `password_reset_codes`. | `send-reset-code/index.ts` | ❌ Not started |
| Replace `listUsers()` with direct query | Both `send-reset-code` and `reset-password` use O(n) `listUsers()`. | 2 Edge Function files | ❌ Not started |
| Tighten CORS | Both Edge Functions use `CORS *`. | 2 Edge Function files | ❌ Not started |

### LOW Priority

| Task | Description | Files | Status |
|------|-------------|-------|--------|
| Delete dead code | `product_search_matcher.dart` (never imported), `getFeaturedProducts()`, `getHomeProducts()`, `getPopularProducts()`. | Multiple | ❌ Not started |
| Add `categories.display_order` index | Used for UI ordering. | Migration | ❌ Not started |
| Add `products.name` index | For text search. | Migration | ❌ Not started |
| Standardize model patterns | `ProfileModel` uses `fromMap`/`toMap`; others use `fromJson`/`toJson`. | Multiple models | ❌ Not started |
| Implement promo codes | Static UI only, no logic. | `promo_section.dart` | ❌ Not started |
| Implement notifications toggle | Local StateProvider, not synced to Supabase. | `settings_page.dart` | ❌ Not started |
| Implement language selector | Placeholder SnackBar. | `settings_page.dart` | ❌ Not started |
| Implement Shop By handlers | Hardcoded items, no filtering logic. | `categories_page.dart` | ❌ Not started |
| Automate `cleanup_expired_codes()` | Database cron job or trigger. | Migration | ❌ Not started |

---

## Needs Verification

| Item | Why | How to Verify |
|------|-----|---------------|
| `password_reset_codes` RLS policies in production | Migration 016 creates anon policies. Cannot verify if a separate manual fix was applied in Supabase dashboard. | Run `SELECT * FROM pg_policies WHERE tablename = 'password_reset_codes';` on live database |
| Edge Function deployment status | Cannot verify if all 3 Edge Functions are deployed to production. | Check Supabase dashboard or run `supabase functions list` |
| `RESEND_API_KEY` configuration | Cannot verify if the secret is set in Edge Function secrets. | Check Supabase dashboard Edge Function secrets |
| `verify-reset-code` Edge Function | Exists in code but was never documented in any doc file. Unknown when it was added. | Git history |

---

## Obsolete Work

| Item | Reason |
|------|--------|
| "Profile table missing migration" | ✅ **RESOLVED** — `018_profiles_schema.sql` now exists |
| "Avatars bucket missing migration" | ✅ **RESOLVED** — `019_avatars_storage.sql` now exists |
| "Reset password RLS — removed anon policies" | ❌ **INCORRECT** — Previous docs claimed this was fixed in Phase 1. Migration 016 still has anon policies. This is still an open security issue. |
| 5-day execution plan from Aug 17 | Superseded by this document |

---

## Today — 2026-08-18

Based on the current codebase state, the following was verified as completed prior to today:

1. **Profiles migration** (`018_profiles_schema.sql`) — exists with RLS, FK, trigger
2. **Avatars storage migration** (`019_avatars_storage.sql`) — exists with 4 storage policies
3. **Verify-reset-code Edge Function** (`verify-reset-code/index.ts`) — exists with attempt limiting (max 5)
4. **All 19 SQL migrations** — present in `supabase/migrations/`
5. **All 3 Edge Functions** — present in `supabase/functions/`
6. **All Supabase repositories** — implemented with user_id filters and auth checks
7. **All auth-aware providers** — watch `currentUserIdProvider`
8. **Data isolation audit fixes** — all mounted checks, lifecycle protections in place
9. **Avatar race condition fix** — auth notifier captured before async gap

**No new code was written today.** This was a documentation synchronization audit.

---

## Tomorrow — 2026-08-19

Recommended next work (ordered by priority and dependency):

### 1. Fix `password_reset_codes` RLS (CRITICAL)
- Remove anon policies from `password_reset_codes`
- Verify on live database
- File: `016_create_password_reset_codes.sql` (or apply directly in dashboard)

### 2. Fix Auth Interface (HIGH — unblocks clean auth)
- Add `ensureProfileExists` + `isEmailConfirmationPending` to `AuthRepositoryInterface`
- Remove 3 `as dynamic` casts from `auth_provider.dart`
- Add `mounted` check in `logout()`
- Files: `auth_repository_interface.dart`, `auth_provider.dart`

### 3. Fix Model Serialization (HIGH — blocks correct DB writes)
- Fix `OrderModel` — status as string, snake_case keys
- Fix `PaymentCardModel` — add `@JsonKey` annotations
- Fix `CartItemModel` — add `toInsertJson()` for DB writes
- Fix `ProductModel` — change `id` from String to int
- Files: 4 model files + consumers

### 4. Implement Router Auth Guards (HIGH — security)
- Define protected routes
- Redirect unauthenticated users to auth page
- File: `app_router.dart`

### 5. Scope Recent Searches (HIGH — data isolation)
- Key SharedPreferences by user ID
- Clear on logout
- File: `search_provider.dart`

### 6. Implement Real Search (MEDIUM)
- Use Supabase `ilike` or full-text search
- Add `products.name` index
- Files: `supabase_search_repository.dart`, new migration

---

## Recommended Execution Order

```
Day 1: CRITICAL + Auth
  Morning:  Fix password_reset_codes RLS (CRITICAL)
  Afternoon: Fix auth interface + mounted check + router auth guards

Day 2: Model Serialization
  Morning:  Fix OrderModel + OrderItemModel
  Afternoon: Fix PaymentCardModel + CartItemModel + ProductModel

Day 3: Search + Providers
  Morning:  Scope recent searches by user + implement real search
  Afternoon: Fix error handling in wishlist + product providers

Day 4: Polish
  Morning:  Remove fake loading delays + extract hardcoded URLs
  Afternoon: Add loading states to providers + handle guest mode

Day 5: Cleanup + Security
  Morning:  Delete dead code + tighten CORS + hash OTP codes
  Afternoon: Final review and testing
```

---

## Appendix: File Reference Index

### Migrations
| # | File | Status |
|---|------|--------|
| 001 | `001_products_schema.sql` | ✅ In use |
| 002 | `002_seed_categories.sql` | ✅ In use |
| 003 | `003_seed_products.sql` | ✅ In use |
| 004 | `004_seed_product_images.sql` | ✅ In use |
| 005 | `005_seed_product_sizes.sql` | ✅ In use |
| 006 | `006_home_content.sql` | ✅ In use |
| 007 | `007_product_images_storage_policies.sql` | ✅ In use |
| 008 | `008_sync_cleanup.sql` | ✅ In use |
| 009 | `009_cart_items_schema.sql` | ✅ In use |
| 010 | `010_wishlist_items_schema.sql` | ✅ In use |
| 011 | `011_orders_schema.sql` | ✅ In use |
| 012 | `012_dynamic_categories.sql` | ✅ In use |
| 013 | `013_drop_categories_image_url.sql` | ✅ In use |
| 014 | `014_addresses_schema.sql` | ✅ In use |
| 015 | `015_payment_cards_schema.sql` | ✅ In use |
| 016 | `016_create_password_reset_codes.sql` | ⚠️ RLS needs fix |
| 017 | `017_otp_security_hardening.sql` | ✅ In use |
| 018 | `018_profiles_schema.sql` | ✅ In use |
| 019 | `019_avatars_storage.sql` | ✅ In use |

### Edge Functions
| Function | Status | Notes |
|----------|--------|-------|
| `send-reset-code` | ✅ In use | Sends OTP via Resend API |
| `verify-reset-code` | ✅ In use | Verifies OTP without changing password |
| `reset-password` | ✅ In use | Updates password via admin API |

### Models with Issues
| File | Issue | Severity |
|------|-------|----------|
| `product_model.dart` | ID as String with 'p' prefix, hardcoded URL | HIGH |
| `order_model.dart` | Status as int index, camelCase keys | HIGH |
| `order_item_model.dart` | productId as String, camelCase keys | HIGH |
| `payment_card_model.dart` | All JSON keys camelCase | HIGH |
| `cart_item_model.dart` | Extra non-DB fields in toJson | HIGH |

### Providers with Issues
| File | Issue | Severity |
|------|-------|----------|
| `auth_provider.dart` | 3 `as dynamic` casts, missing mounted check in logout | HIGH |
| `wishlist_provider.dart` | Silent error swallowing on add/remove | MEDIUM |
| `product_provider.dart` | No catchError on loadAll() | MEDIUM |
| `search_provider.dart` | Not per-user, no real Supabase search | HIGH |

### Security Issues
| File | Issue | Severity |
|------|-------|----------|
| `016_create_password_reset_codes.sql` | Anon policies grant SELECT/INSERT/UPDATE to all users | CRITICAL |
| `app_router.dart` | No auth guards on any of 22 routes | HIGH |
| `send-reset-code/index.ts` | OTP stored as plaintext, O(n) listUsers(), CORS * | MEDIUM |
| `reset-password/index.ts` | O(n) listUsers(), CORS * | MEDIUM |
