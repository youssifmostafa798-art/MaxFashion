# Supabase Remaining Work

> **Generated:** Sat Aug 30 2026
> **Audit scope:** Entire Flutter project — every file in lib/, supabase/, docs/
> **Previous audit:** Aug 21, 2026
> **Rule:** Code is truth. Documentation is secondary.

---

## Current Status

The MaxFashion app has **~95% of Supabase migration completed**. All major features (auth, products, cart, wishlist, orders, addresses, payment cards, home content, collections, OTP password recovery) are connected to Supabase with working CRUD, RLS, and auth-aware providers. Migrations 018 (profiles), 019 (avatars storage), 020 (full-text search), 021 (OTP hashing), 022 (collections), and 023 (fix watches image) now exist. Three Edge Functions (`send-reset-code`, `verify-reset-code`, `reset-password`) are implemented with SHA-256 hashed OTP codes. Route-level auth guards protect sensitive routes. Recent searches are scoped per-user.

Remaining work is primarily **code quality** (model serialization mismatches) and **UX improvements** (real payment gateway, order cancellation, product image gallery).

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

### OTP Code Hashing
- **What:** Migrated plaintext OTP codes to SHA-256 hashes for security
- **Files:** `021_otp_code_hashing.sql`, Edge Functions updated to hash codes
- **Status:** ✅ Verified — `code_hash` column, pgcrypto extension, Edge Functions hash before store/verify

### Collections Feature
- **What:** Curated product collections with category mappings, home carousel, collection products page
- **Files:** `022_collections_schema.sql`, `023_fix_watches_image_url.sql`, `collection_repository.dart`, `supabase_collection_repository.dart`, `collection_provider.dart`, `collection_model.dart`, `collection_products_page.dart`, `all_collections_page.dart`
- **Status:** ✅ Verified — 10 collections seeded (6 active), `collection-images` storage bucket, public read RLS

### Route-Level Auth Guards
- **What:** `AuthGuard` widget protects sensitive routes (checkout, profile editing, addresses, payment methods)
- **Files:** `auth_guard.dart`, `app_router.dart`
- **Status:** ✅ Verified — 6 routes protected: placeOrder, addAddress, addCard, editProfile, addresses, paymentMethods

### Recent Searches Scoped Per-User
- **What:** Recent searches keyed by userId (`recent_searches_{userId}`), preventing cross-account history leakage
- **Files:** `search_provider.dart`
- **Status:** ✅ Verified — `_recentSearchesKey` returns `recent_searches_$userId` or `recent_searches_guest`

### Auth Interface Fixed
- **What:** `ensureProfileExists` and `isEmailConfirmationPending` are now on `AuthRepositoryInterface`. No more `as dynamic` casts needed.
- **Files:** `auth_repository_interface.dart`, `auth_provider.dart`
- **Status:** ✅ Verified — interface declares both methods

### Mounted Check in Logout
- **What:** `auth_provider.dart` logout method now has `if (!mounted) return;` after `signOut()`
- **Files:** `auth_provider.dart`
- **Status:** ✅ Verified — mounted check present

### OrderModel Serialization Fixed
- **What:** Status serialized as string (not int index). `fromJson` handles both int and String for backward compatibility.
- **Files:** `order_model.dart`, `order_item_model.dart`, `supabase_order_repository.dart`
- **Status:** ✅ Verified — `toJson()` uses `statusToString()` which returns string, repository uses `_statusToDb()` for DB writes

### PaymentCardModel Serialization Fixed
- **What:** `toJson()` uses snake_case keys matching DB columns. `fromJson` handles both camelCase and snake_case.
- **Files:** `payment_card_model.dart`, `supabase_payment_card_repository.dart`
- **Status:** ✅ Verified — `toJson()` produces `card_holder_name`, `last4_digits`, `expiry_month`, `expiry_year`, `card_brand`, `is_default`

### Wishlist Error Handling Fixed
- **What:** `addToWishlist`/`removeFromWishlist` now have proper error handling with rollback on failure
- **Files:** `wishlist_provider.dart`
- **Status:** ✅ Verified — optimistic UI with `.catchError` rollback

### Product Translations (Historical)
- **What:** Migration 024 created `product_translations` table for localization. Migration 025 reverted this approach, restoring English content to the `products` table.
- **Files:** `024_product_translations.sql`, `025_restore_english_products.sql`
- **Status:** ⚠️ Historical — migrations exist but approach was reverted

### Language Selector Implemented
- **What:** Settings page includes a functional language picker (English/Arabic) that switches the app locale at runtime
- **Files:** `settings_page.dart`, `language_provider.dart`, `language_storage.dart`
- **Status:** ✅ Verified — modal bottom sheet with locale switching

### Menu Categories Loaded Dynamically
- **What:** `CategoryGrid` reads from `categoriesProvider` which loads from Supabase `categories` table
- **Files:** `category_grid.dart`, `product_provider.dart`
- **Status:** ✅ Verified — categories are NOT hardcoded

---

## Partially Completed

### Search Repository
- **What:** `SupabaseSearchRepository` uses `search_products` RPC (full-text search with trigram matching, server-side pagination) via migration 020
- **Files:** `supabase_search_repository.dart`, `search_provider.dart`, `020_full_text_search.sql`
- **Remaining:** Search is fully implemented. Recent searches are per-user scoped.
- **Priority:** LOW (search is complete)

### Product Translations (Reverted)
- **What:** Migrations 024-025 attempted product content localization but were reverted. Migration 024 created `product_translations` with locale-aware search. Migration 025 restored English content to `products` table and dropped the translations infrastructure.
- **Files:** `024_product_translations.sql`, `025_restore_english_products.sql`
- **Remaining:** If localization is needed in the future, the approach from migration 024 can be re-implemented.
- **Priority:** LOW (reverted, not blocking)

---

## Remaining Work

### HIGH Priority

| Task | Description | Files | Status |
|------|-------------|-------|--------|
| ~~Fix Auth interface~~ | ~~Add `ensureProfileExists` + `isEmailConfirmationPending` to `AuthRepositoryInterface`. Remove 3 `as dynamic` casts.~~ | ~~`auth_repository_interface.dart`, `auth_provider.dart`~~ | ✅ Completed |
| ~~Add mounted check in logout~~ | ~~`auth_provider.dart` — `state = const AuthState()` without `mounted` check after `signOut()`.~~ | ~~`auth_provider.dart`~~ | ✅ Completed |
| ~~Fix OrderModel serialization~~ | ~~Status serialized as `int` (`.index`) but DB uses `TEXT`. `fromJson` uses camelCase keys but DB is snake_case.~~ | ~~`order_model.dart`, `order_item_model.dart`~~ | ✅ Fixed |
| ~~Fix PaymentCardModel serialization~~ | ~~All JSON keys camelCase (`cardHolderName`) but DB columns snake_case (`card_holder_name`). `fromJson`/`toJson` broken.~~ | ~~`payment_card_model.dart`~~ | ✅ Fixed |
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
| Tighten CORS | Edge Functions use `CORS *`. | 3 Edge Function files | ❌ Not started |

### LOW Priority

| Task | Description | Files | Status |
|------|-------------|-------|--------|
| Delete dead code | `getFeaturedProducts()`, `getHomeProducts()`, `getPopularProducts()`. | Multiple | ❌ Not started |
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
| "Reset password RLS — removed anon policies" | ✅ **RESOLVED** — Migration 016 correctly has NO anon policies. Edge functions use service_role which bypasses RLS. |
| "Implement router auth guards" | ✅ **RESOLVED** — `AuthGuard` protects 6 sensitive routes |
| "Scope recent searches by user" | ✅ **RESOLVED** — Keyed by userId in SharedPreferences |
| "Hash OTP codes" | ✅ **RESOLVED** — Migration 021, SHA-256 hashed codes |
| "Collections feature" | ✅ **RESOLVED** — Migrations 022-023, full implementation |
| "Fix Auth interface" | ✅ **RESOLVED** — Methods are on `AuthRepositoryInterface`, no more `as dynamic` casts |
| "Add mounted check in logout" | ✅ **RESOLVED** — `if (!mounted) return;` present after `signOut()` |
| "Fix OrderModel serialization" | ✅ **RESOLVED** — Status serialized as string, fromJson handles both int and String |
| "Fix PaymentCardModel serialization" | ✅ **RESOLVED** — toJson uses snake_case matching DB columns |
| "Fix wishlist error handling" | ✅ **RESOLVED** — Optimistic UI with rollback on failure |
| 5-day execution plan from Aug 17 | Superseded by this document |

---

## Today — 2026-08-30

Based on the current codebase state, the following was verified as completed:

1. **Profiles migration** (`018_profiles_schema.sql`) — exists with RLS, FK, trigger
2. **Avatars storage migration** (`019_avatars_storage.sql`) — exists with 4 storage policies
3. **Full-text search migration** (`020_full_text_search.sql`) — exists with `search_products` RPC function
4. **OTP code hashing migration** (`021_otp_code_hashing.sql`) — SHA-256 hashed codes with pgcrypto
5. **Collections migration** (`022_collections_schema.sql`) — collections + collection_categories tables, collection-images bucket
6. **Fix watches image migration** (`023_fix_watches_image_url.sql`) — corrects Watches collection image URL
7. **Product translations migration** (`024_product_translations.sql`) — created but **reverted by 025**
8. **Restore English products migration** (`025_restore_english_products.sql`) — restored product content, dropped translations
9. **Verify-reset-code Edge Function** (`verify-reset-code/index.ts`) — exists with attempt limiting (max 5)
10. **All 25 SQL migrations** — present in `supabase/migrations/` (024-025 are historical/reverted)
11. **All 3 Edge Functions** — present in `supabase/functions/` with SHA-256 hashed OTP codes
12. **All Supabase repositories** — implemented with user_id filters and auth checks
13. **All auth-aware providers** — watch `currentUserIdProvider`
14. **Data isolation audit fixes** — all mounted checks, lifecycle protections in place
15. **Avatar race condition fix** — auth notifier captured before async gap
16. **Password reset codes RLS** — verified CORRECTLY secured with NO anon policies (migration 016)
17. **Search implementation** — verified using `search_products` RPC with full-text search
18. **Recent searches scoped per-user** — keyed by userId in SharedPreferences
19. **Route-level auth guards** — `AuthGuard` protects 6 sensitive routes (placeOrder, addAddress, addCard, editProfile, addresses, paymentMethods)
20. **Collections feature** — fully implemented with Supabase backend
21. **Auth interface** — `ensureProfileExists` and `isEmailConfirmationPending` are on `AuthRepositoryInterface`
22. **Mounted check in logout** — present after `signOut()`
23. **OrderModel serialization** — status serialized as string, not int
24. **PaymentCardModel serialization** — toJson uses snake_case matching DB
25. **Wishlist error handling** — optimistic UI with rollback on failure
26. **Language selector** — implemented in settings page with runtime locale switching
27. **Menu categories** — loaded dynamically from Supabase, not hardcoded

**No new code was written today.** This was a documentation synchronization audit.

---

## Remaining Work

### 1. Fix CartItemModel Serialization (HIGH)
- Add `toInsertJson()` for DB writes (exclude non-DB columns)
- Files: `cart_item_model.dart`

### 2. Fix ProductModel (HIGH)
- Change `id` from String with 'p' prefix to int
- Extract hardcoded Supabase URL
- Files: `product_model.dart` + 6 consumers

### 3. Fix Error Handling (MEDIUM)
- Add `catchError` on `loadAll()` in product provider
- Remove fake loading delays — use real AsyncValue states
- Files: `product_provider.dart`, 4 page files

### 4. Security Hardening (MEDIUM)
- Tighten CORS in Edge Functions
- Replace `listUsers()` with direct query in Edge Functions
- Files: 3 Edge Function files

### 5. Cleanup + Testing
- Delete dead code + standardize model patterns
- Final review and testing

---

## Recommended Execution Plan

```
Phase 1: Model Fixes (HIGH)
  - Fix CartItemModel serialization (toInsertJson for DB writes)
  - Fix ProductModel ID (String → int) + extract hardcoded URL

Phase 2: Error Handling (MEDIUM)
  - Add catchError on loadAll() in product provider
  - Remove fake loading delays

Phase 3: Security Hardening (MEDIUM)
  - Tighten CORS in Edge Functions
  - Replace listUsers() with direct query

Phase 4: Cleanup + Testing
  - Delete dead code
  - Final review and testing
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
| 021 | `021_otp_code_hashing.sql` | ✅ In use (SHA-256 hashed OTP codes) |
| 022 | `022_collections_schema.sql` | ✅ In use (collections + collection_categories + collection-images bucket) |
| 023 | `023_fix_watches_image_url.sql` | ✅ In use |
| 024 | `024_product_translations.sql` | ⚠️ Historical (reverted by 025) |
| 025 | `025_restore_english_products.sql` | ✅ In use (restored English products) |

### Edge Functions
| Function | Status | Notes |
|----------|--------|-------|
| `send-reset-code` | ✅ In use | Sends OTP via Resend API, SHA-256 hashed before storage |
| `verify-reset-code` | ✅ In use | Verifies OTP hash without changing password |
| `reset-password` | ✅ In use | Updates password via admin API, invalidates all sessions |

### Remaining Model Issues
| File | Issue | Severity |
|------|-------|----------|
| `product_model.dart` | ID as String with 'p' prefix, hardcoded URL | HIGH |
| `cart_item_model.dart` | Extra non-DB fields in toJson | HIGH |

### Remaining Provider Issues
| File | Issue | Severity |
|------|-------|----------|
| `wishlist_provider.dart` | Silent error swallowing on add/remove | MEDIUM |
| `product_provider.dart` | No catchError on loadAll() | MEDIUM |

### Security Issues
| File | Issue | Severity |
|------|-------|----------|
| `send-reset-code/index.ts` | O(n) listUsers(), CORS * | MEDIUM |
| `verify-reset-code/index.ts` | CORS * | MEDIUM |
| `reset-password/index.ts` | O(n) listUsers(), CORS * | MEDIUM |
