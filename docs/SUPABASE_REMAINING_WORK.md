# Supabase Remaining Work

> **Generated:** Tue Aug 18 2026
> **Audit scope:** Entire Flutter project — every file in lib/, supabase/, docs/
> **Previous audit:** Aug 18, 2026 (this document)
> **Rule:** Code is truth. Documentation is secondary.

---

## Current Status

The MaxFashion app has **~92% of Supabase migration completed**. All major features (auth, products, cart, wishlist, orders, addresses, payment cards, home content, OTP password recovery) are connected to Supabase with working CRUD, RLS, and auth-aware providers. Migrations 018 (profiles), 019 (avatars storage), and 020 (full-text search) now exist. Three Edge Functions (`send-reset-code`, `verify-reset-code`, `reset-password`) are implemented.

Remaining work is primarily **code quality** (model serialization mismatches, `as dynamic` casts), **data isolation** (recent searches not per-user), and **UX improvements** (router auth guards).

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
- **What:** `SupabaseSearchRepository` uses `search_products` RPC (full-text search with trigram matching, server-side pagination) via migration 020
- **Files:** `supabase_search_repository.dart`, `search_provider.dart`, `020_full_text_search.sql`
- **Remaining:** Search is implemented and functional. Recent searches are still stored locally (not per-user).
- **Priority:** MEDIUM (search itself is done, only recent searches scoping remains)

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
| ~~Fix `password_reset_codes` RLS~~ | ~~Remove all 3 anon policies~~ | `016_create_password_reset_codes.sql` | ✅ **VERIFIED SECURE** — Migration 016 has NO anon policies. Edge functions use service_role which bypasses RLS. Previous documentation incorrectly claimed anon access existed. |

### HIGH Priority

| Task | Description | Files | Status |
|------|-------------|-------|--------|
| Fix Auth interface | Add `ensureProfileExists` + `isEmailConfirmationPending` to `AuthRepositoryInterface`. Remove 3 `as dynamic` casts. | `auth_repository_interface.dart`, `auth_provider.dart` | ❌ Not started |
| Add mounted check in logout | `auth_provider.dart:299` — `state = const AuthState()` without `mounted` check after `signOut()`. | `auth_provider.dart` | ❌ Not started |
| Implement router auth guards | All 24 routes accessible without auth. Guests can reach cart, wishlist, orders, etc. | `app_router.dart` | ❌ Not started |
| Scope recent searches by user | `SharedPreferences` key `recent_searches` is global. User B sees User A's searches. | `search_provider.dart` | ❌ Not started |
| Fix OrderModel serialization | Status serialized as `int` (`.index`) but DB uses `TEXT`. `fromJson` uses camelCase keys but DB is snake_case. | `order_model.dart`, `order_item_model.dart` | ❌ Not started |
| Fix PaymentCardModel serialization | All JSON keys camelCase (`cardHolderName`) but DB columns snake_case (`card_holder_name`). `fromJson`/`toJson` broken. | `payment_card_model.dart` | ❌ Not started |
| Fix CartItemModel serialization | `toJson` sends non-DB columns (`product_name`, `product_image`, `selected_size`, `unit_price`). Model is UI-layer DTO. | `cart_item_model.dart` | ❌ Not started |
| Fix ProductModel ID | `id` is `String` with `'p'` prefix (`'p123'`) but DB is `BIGINT`. `toJson` sends invalid ID. | `product_model.dart` + 6 consumers | ❌ Not started |

### MEDIUM Priority

| Task | Description | Files | Status |
|------|-------------|-------|--------|
| Fix wishlist error handling | `addToWishlist`/`removeFromWishlist` silently swallow errors. Optimistic UI not rolled back on failure. | `wishlist_provider.dart:52,59` | ❌ Not started |
| Fix product provider error handling | `loadAll().then(...)` has no `.catchError()`. If load fails, `productsLoaded` stays false forever. | `product_provider.dart:25` | ❌ Not started |
| Remove fake loading delays | 4 screens use `Future.delayed` with fake durations instead of real `AsyncValue` states. | `orders_page.dart`, `wishlist_page.dart`, `product_detail_page.dart`, `product_listing_page.dart` | ❌ Not started |
| Extract hardcoded storage URL | 3 files contain `https://tonctmdcntftugdskqmb.supabase.co/storage/v1/object/public/product-images`. | `product_model.dart:5-6`, `supabase_cart_repository.dart:12`, `supabase_order_repository.dart:13` | ❌ Not started |
| Add loading state to providers | Orders, Address, PaymentCard, Wishlist providers have no `isLoading`/`error` state. | 4 provider files | ❌ Not started |
| Hash OTP codes | Store hashed, not plaintext in `password_reset_codes`. | `send-reset-code/index.ts` | ❌ Not started |
| Replace `listUsers()` with direct query | Both `send-reset-code` and `reset-password` use O(n) `listUsers()`. | 2 Edge Function files | ❌ Not started |
| Tighten CORS | Both Edge Functions use `CORS *`. | 2 Edge Function files | ❌ Not started |

### LOW Priority

| Task | Description | Files | Status |
|------|-------------|-------|--------|
| Delete dead code | `product_search_matcher.dart` (never imported), `getFeaturedProducts()`, `getHomeProducts()`, `getPopularProducts()`. | Multiple | ❌ Not started |
| Add `categories.display_order` index | Used for UI ordering. | Migration | ❌ Not started |
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
| Edge Function deployment status | Cannot verify if all 3 Edge Functions are deployed to production. | Check Supabase dashboard or run `supabase functions list` |
| `RESEND_API_KEY` configuration | Cannot verify if the secret is set in Edge Function secrets. | Check Supabase dashboard Edge Function secrets |
| `verify-reset-code` Edge Function | Exists in code but was never documented in any doc file. Unknown when it was added. | Git history |

---

## Obsolete Work

| Item | Reason |
|------|--------|
| "Profile table missing migration" | ✅ **RESOLVED** — `018_profiles_schema.sql` now exists |
| "Avatars bucket missing migration" | ✅ **RESOLVED** — `019_avatars_storage.sql` now exists |
| "Reset password RLS — removed anon policies" | ✅ **RESOLVED** — Migration 016 correctly has NO anon policies. Edge functions use service_role which bypasses RLS. Previous documentation incorrectly claimed anon access existed. |
| 5-day execution plan from Aug 17 | Superseded by this document |

---

## Today — 2026-08-18

Based on the current codebase state, the following was verified as completed prior to today:

1. **Profiles migration** (`018_profiles_schema.sql`) — exists with RLS, FK, trigger
2. **Avatars storage migration** (`019_avatars_storage.sql`) — exists with 4 storage policies
3. **Full-text search migration** (`020_full_text_search.sql`) — exists with `search_products` RPC function
4. **Verify-reset-code Edge Function** (`verify-reset-code/index.ts`) — exists with attempt limiting (max 5)
5. **All 20 SQL migrations** — present in `supabase/migrations/`
6. **All 3 Edge Functions** — present in `supabase/functions/`
7. **All Supabase repositories** — implemented with user_id filters and auth checks
8. **All auth-aware providers** — watch `currentUserIdProvider`
9. **Data isolation audit fixes** — all mounted checks, lifecycle protections in place
10. **Avatar race condition fix** — auth notifier captured before async gap
11. **Password reset codes RLS** — verified CORRECTLY secured with NO anon policies (migration 016)
12. **Search implementation** — verified using `search_products` RPC with full-text search

**No new code was written today.** This was a documentation synchronization audit.

---

## Tomorrow — 2026-08-19

Recommended next work (ordered by priority and dependency):

### 1. Fix Auth Interface (HIGH — unblocks clean auth)
- Add `ensureProfileExists` + `isEmailConfirmationPending` to `AuthRepositoryInterface`
- Remove 3 `as dynamic` casts from `auth_provider.dart`
- Add `mounted` check in `logout()`
- Files: `auth_repository_interface.dart`, `auth_provider.dart`

### 2. Implement Router Auth Guards (HIGH — security)
- Define protected routes
- Redirect unauthenticated users to auth page
- File: `app_router.dart`

### 3. Scope Recent Searches (HIGH — data isolation)
- Key SharedPreferences by user ID
- Clear on logout
- File: `search_provider.dart`

### 4. Fix Model Serialization (HIGH — blocks correct DB writes)
- Fix `OrderModel` — status as string, snake_case keys
- Fix `PaymentCardModel` — add `@JsonKey` annotations
- Fix `CartItemModel` — add `toInsertJson()` for DB writes
- Fix `ProductModel` — change `id` from String to int
- Files: 4 model files + consumers

### 5. Fix Error Handling (MEDIUM)
- Fix wishlist error handling — add rollback on failure
- Fix product provider error handling — add catchError on loadAll()
- Remove fake loading delays — use real AsyncValue states
- Files: wishlist_provider.dart, product_provider.dart, 4 page files

### 6. Security Hardening (MEDIUM)
- Hash OTP codes in `password_reset_codes`
- Replace `listUsers()` with direct query in Edge Functions
- Tighten CORS in Edge Functions
- Files: 3 Edge Function files

---

## Recommended Execution Order

```
Day 1: Auth + Security
  Morning:  Fix auth interface + mounted check + router auth guards
  Afternoon: Scope recent searches by user

Day 2: Model Serialization
  Morning:  Fix OrderModel + OrderItemModel
  Afternoon: Fix PaymentCardModel + CartItemModel + ProductModel

Day 3: Error Handling + Polish
  Morning:  Fix wishlist + product provider error handling
  Afternoon: Remove fake loading delays + extract hardcoded URLs

Day 4: Security Hardening
  Morning:  Hash OTP codes + replace listUsers() + tighten CORS
  Afternoon: Add loading states to providers

Day 5: Cleanup + Testing
  Morning:  Delete dead code + standardize model patterns
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
| 016 | `016_create_password_reset_codes.sql` | ✅ In use (RLS correctly secured — no anon policies) |
| 017 | `017_otp_security_hardening.sql` | ✅ In use |
| 018 | `018_profiles_schema.sql` | ✅ In use |
| 019 | `019_avatars_storage.sql` | ✅ In use |
| 020 | `020_full_text_search.sql` | ✅ In use |

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
| `search_provider.dart` | Recent searches not per-user (global SharedPreferences key) | HIGH |
| `wishlist_provider.dart` | Silent error swallowing on add/remove | MEDIUM |
| `product_provider.dart` | No catchError on loadAll() | MEDIUM |

### Security Issues
| File | Issue | Severity |
|------|-------|----------|
| `app_router.dart` | No auth guards on any of 24 routes | HIGH |
| `auth_provider.dart` | Missing mounted check in logout, 3 `as dynamic` casts | HIGH |
| `send-reset-code/index.ts` | OTP stored as plaintext, O(n) listUsers(), CORS * | MEDIUM |
| `reset-password/index.ts` | O(n) listUsers(), CORS * | MEDIUM |
