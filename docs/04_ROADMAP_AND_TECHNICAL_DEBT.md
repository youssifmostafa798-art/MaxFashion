# 04 — Roadmap & Technical Debt

> **MaxFashion — Remaining Work, Known Issues & Technical Debt**
> Last Updated: August 15, 2026

---

## Remaining Features

### Critical — Required Before Production

| Feature | Status | Notes |
|---------|--------|-------|
| Address Migration to Supabase | ❌ Not Started | Create `addresses` table, migrate from SharedPreferences |
| Payment Card Migration | ❌ Not Started | Create `payment_cards` table or use third-party processor |
| Forgot Password | ❌ Not Implemented | Supabase password reset email flow |

### High Priority — Important Missing Functionality

| Feature | Status | Notes |
|---------|--------|-------|
| Real Payment Gateway | ❌ Not Implemented | Credit card form exists but no payment processing |
| Order Cancellation UI | ❌ Not Implemented | No cancellation flow from user side |
| Product Image Gallery | ❌ Not Implemented | Only single thumbnail displayed (productImages list exists but unused in UI) |
| Delivery Option | ❌ Not Implemented | Hardcoded to "Pickup at store" only |

### Medium Priority — Improvements

| Feature | Status | Notes |
|---------|--------|-------|
| Fix Dynamic Casts in Auth | ❌ Not Started | `ensureProfileExists` and `isEmailConfirmationPending` accessed via `as dynamic` |
| Exception Cleanup | ❌ Not Started | 28 silently swallowed exceptions (`catch (_) {}`) |
| Promo Code Logic | ⚠️ UI Only | Section exists but no input field or application logic |
| "Shop By" Filtering | ⚠️ UI Only | New Arrivals, Trending, Best Sellers, Online Exclusive — static UI, no filtering |
| Product Reviews/Ratings | ❌ Not Implemented | No code found |
| Push Notifications | ❌ Not Implemented | No code found |
| Consolidate Search Logic | ❌ Not Started | 3 duplicate search implementations should be merged |
| Menu Categories Dynamic Loading | ⚠️ Hardcoded | CategoriesPage has hardcoded items (should load from Supabase) |

### Low Priority — Optional Polish

| Feature | Status | Notes |
|---------|--------|-------|
| Unit/Widget Tests | ❌ None | No tests exist beyond minimal smoke test |
| Product Discount Display | ⚠️ Field Exists | `discountPrice` field exists but always null in seeded data |
| Social Media Links | ⚠️ Non-Functional | Footer icons trigger haptic only |
| Deep Linking | ❌ Not Implemented | Some screens use Navigator.push instead of named routes |
| Remove Bundled Product Images | ❌ Not Started | `assets/products_supa/` may bloat APK (images now served from Supabase Storage) |
| Remove Dead Getters | ❌ Not Started | `collection` and `keywords` getters in ProductModel return empty values |

---

## Known Issues

### Medium Priority

| Issue | Affected Feature | Status | Notes |
|-------|-----------------|--------|-------|
| `ensureProfileExists` via dynamic cast | Authentication | Open | `lib/data/providers/auth_provider.dart:94` — accessed via `(_repository as dynamic)` — fragile but functional |
| `isEmailConfirmationPending` via dynamic cast | Authentication | Open | Same file — not on `AuthRepositoryInterface` |
| 28 silently swallowed exceptions | Multiple | Open | `catch (_) {}` in auth_provider (5), orders_provider (3), wishlist_provider (1), payment_card_provider (1), address_provider (1), supabase_product_repository (1), supabase_order_repository (1), supabase_auth_repository (1), place_order (1), edit_profile_provider (2) |
| Hardcoded Supabase URL | Products, Cart, Orders | Open | `_storageBaseUrl` hardcoded in ProductModel, SupabaseCartRepository, SupabaseOrderRepository instead of using .env config |

### Low Priority

| Issue | Affected Feature | Status | Notes |
|-------|-----------------|--------|-------|
| Forgot-password not implemented | Auth | Open | UI label exists in login page but no tap handler |
| Some screens lack named routes | Navigation | Open | Accessed via `Navigator.push(MaterialPageRoute(...))` directly |
| Promo section non-functional | Checkout | Open | UI exists but no input field or logic |
| "Shop By" items static | Menu | Open | No filtering logic behind New Arrivals, Trending, etc. |
| Menu categories hardcoded | Menu | Open | Items hardcoded in CategoriesPage, not loaded from Supabase |
| Cover image URL from Supabase | Home | Open | If `cover_url` is null, shows empty container fallback |
| Duplicate search implementations | Search | Open | SupabaseSearchRepository, SupabaseProductRepository.searchProducts, ProductSearchMatcher all implement search |
| Dead `collection` getter | Products | Open | Returns empty string, used in ProductSearchMatcher (no effect) |
| Dead `keywords` getter | Products | Open | Returns empty list, used in ProductSearchMatcher (no effect) |

---

## Technical Debt

### Dead / Legacy Code (Already Removed)

The following files have been **deleted** from the codebase but may still be referenced in old documentation:

| File | Status | Notes |
|------|--------|-------|
| `lib/data/services/fake_auth_service.dart` | ❌ DELETED | Legacy fake auth — superseded by Supabase |
| `lib/data/repositories/auth_repository.dart` | ❌ DELETED | Legacy wrapper around FakeAuthService |
| `lib/data/repositories/product/local_product_repository.dart` | ❌ DELETED | Local impl — superseded by SupabaseProductRepository |
| `lib/data/repositories/search/local_search_repository.dart` | ❌ DELETED | Local impl — superseded by SupabaseSearchRepository |
| `lib/data/services/cart_storage.dart` | ❌ DELETED | SharedPreferences cart — superseded by SupabaseCartRepository |
| `lib/data/models/cover_model.dart` | ❌ DELETED | Unused cover model |
| `lib/data/datasources/local/` | ❌ DELETED | LocalProductDataSource directory — removed from codebase |

### Code Quality Issues

| Issue | Location | Severity |
|-------|----------|----------|
| Dynamic cast for `ensureProfileExists` | `lib/data/providers/auth_provider.dart:94` | Medium |
| Dynamic cast for `isEmailConfirmationPending` | `lib/data/providers/auth_provider.dart:190` | Medium |
| 28 silently swallowed exceptions | Multiple files (see Known Issues) | Medium |
| Hardcoded Supabase storage URL | `lib/data/models/product_model.dart:5`, `lib/data/repositories/cart/supabase_cart_repository.dart:13`, `lib/data/repositories/orders/supabase_order_repository.dart:13` | Low |
| Mixed navigation patterns (named routes vs Navigator.push) | Various | Low |
| Dead `collection` getter returns empty string | `lib/data/models/product_model.dart:40` | Low |
| Dead `keywords` getter returns empty list | `lib/data/models/product_model.dart:42` | Low |
| 3 duplicate search implementations | `supabase_search_repository.dart`, `supabase_product_repository.dart`, `product_search_matcher.dart` | Low |
| `discountPrice` always null in seed data | Supabase seed data | Low |
| Bundled product images may bloat APK | `assets/products_supa/` | Low |

### Architecture Inconsistencies

| Issue | Notes |
|-------|-------|
| Some navigation uses Navigator.push | While routing uses named routes — mixed approach |
| Cart items join product data on every load | Could be optimized with caching |
| Search is in-memory not live Supabase query | Products loaded once into cache, search filters locally |

### Unused Dependencies

| Package | Notes |
|---------|-------|
| `flutter_credit_card` | Used for card form UI, but no payment processing |

---

## Next Steps (Recommended Order)

### 1. Address Migration

**Why:** Addresses are used by checkout, should be per-user and cross-device.

**Tasks:**
1. Create `addresses` table in Supabase
2. Add RLS policies (user-owned)
3. Create `SupabaseAddressRepository`
4. Update `addressProvider` to use Supabase
5. Remove SharedPreferences persistence
6. Add migration from local SharedPreferences to Supabase

### 2. Payment Card Migration

**Why:** Payment cards should be per-user and cross-device.

**Tasks:**
1. Create `payment_cards` table in Supabase (or use secure vault)
2. Add RLS policies (user-owned)
3. Create `SupabasePaymentCardRepository`
4. Update `paymentCardProvider` to use Supabase
5. Remove `PaymentCardStorage` SharedPreferences persistence

### 3. Forgot Password

**Why:** Important auth feature, relatively simple with Supabase.

**Tasks:**
1. Add `resetPassword()` to `AuthRepositoryInterface`
2. Implement in `SupabaseAuthRepository` using `supabase.auth.resetPasswordForEmail()`
3. Add UI for password reset flow
4. Handle email sent confirmation

### 4. Fix Dynamic Casts & Exception Handling

**Why:** Type safety and debuggability.

**Tasks:**
1. Add `ensureProfileExists()` and `isEmailConfirmationPending` to `AuthRepositoryInterface`
2. Remove `as dynamic` casts from `auth_provider.dart`
3. Audit 28 silently swallowed exceptions — at minimum add logging
4. Consider adding a global error handler

### 5. Cleanup & Polish

**Tasks:**
- Remove dead `collection` and `keywords` getters from ProductModel
- Remove dead `ProductSearchMatcher` class
- Consolidate 3 search implementations into one
- Extract hardcoded Supabase URLs to configuration
- Add named routes for all screens
- Load menu categories from Supabase
- Remove or verify bundled `assets/products_supa/` images
- Remove any remaining dead code

### 6. Testing

**Tasks:**
- Add unit tests for cart total calculation, auth flows
- Add widget tests for core shared components
- Manual E2E testing of full purchase journey

---

## Migration Status Summary

| Feature | Current State | Target State | Migration Status |
|---------|--------------|--------------|-----------------|
| Authentication | Supabase | Supabase | ✅ Done |
| Profiles | Supabase | Supabase | ✅ Done |
| Products | Supabase | Supabase | ✅ Done |
| Categories | Supabase | Supabase | ✅ Done |
| Home Content | Supabase | Supabase | ✅ Done |
| Cart | Supabase | Supabase | ✅ Done |
| Wishlist | Supabase | Supabase | ✅ Done |
| Orders | SharedPreferences | Supabase | ✅ Done |
| Addresses | SharedPreferences | Supabase | ❌ Not Started |
| Payment Cards | SharedPreferences | Supabase / Third-party | ❌ Not Started |
| Theme | SharedPreferences | SharedPreferences | ✅ Correct (local is fine) |
| Recent Searches | SharedPreferences | SharedPreferences | ✅ Correct (local is fine) |

---

*See [01_PROJECT_STATUS.md](./01_PROJECT_STATUS.md) for current state, [02_ARCHITECTURE.md](./02_ARCHITECTURE.md) for architecture, and [03_FEATURES_AND_DATA.md](./03_FEATURES_AND_DATA.md) for feature details.*
