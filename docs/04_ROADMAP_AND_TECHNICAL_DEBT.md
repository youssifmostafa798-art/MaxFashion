# 04 — Roadmap & Technical Debt

> **MaxFashion — Remaining Work, Known Issues & Technical Debt**
> Last Updated: August 12, 2026

---

## Remaining Features

### 🔴 Critical — Required Before Production

| Feature | Status | Notes |
|---------|--------|-------|
| Orders Migration to Supabase | ❌ Not Started | Create `orders` + `order_items` tables, `SupabaseOrdersRepository`, migrate from SharedPreferences |
| Address Migration to Supabase | ❌ Not Started | Create `addresses` table, migrate from SharedPreferences |
| Forgot Password | ❌ Not Implemented | Supabase password reset email flow |

### 🟠 High Priority — Important Missing Functionality

| Feature | Status | Notes |
|---------|--------|-------|
| Real Payment Gateway | ❌ Not Implemented | Credit card form exists but no payment processing |
| Order Cancellation UI | ❌ Not Implemented | No cancellation flow from user side |
| Product Image Gallery | ❌ Not Implemented | Only single thumbnail displayed (productImages list exists but unused in UI) |
| Delivery Option | ❌ Not Implemented | Hardcoded to "Pickup at store" only |

### 🟡 Medium Priority — Improvements

| Feature | Status | Notes |
|---------|--------|-------|
| Promo Code Logic | ⚠️ UI Only | Section exists but no input field or application logic |
| "Shop By" Filtering | ⚠️ UI Only | New Arrivals, Trending, Best Sellers, Online Exclusive — static UI, no filtering |
| Product Reviews/Ratings | ❌ Not Implemented | No code found |
| Push Notifications | ❌ Not Implemented | No code found |
| Cross-Device Data Sync | ❌ Not Started | Wishlist, orders, addresses are local-only |
| Menu Categories Dynamic Loading | ⚠️ Hardcoded | CategoriesPage has hardcoded 23 items (should load from Supabase) |

### 🟢 Low Priority — Optional Polish

| Feature | Status | Notes |
|---------|--------|-------|
| Unit/Widget Tests | ❌ None | No tests exist |
| Product Discount Display | ⚠️ Field Exists | `discountPrice` field exists but always null in seeded data |
| Social Media Links | ⚠️ Non-Functional | Footer icons trigger haptic only |
| Deep Linking | ❌ Not Implemented | Some screens use Navigator.push instead of named routes |

---

## Known Issues

### Medium Priority

| Issue | Affected Feature | Status | Notes |
|-------|-----------------|--------|-------|
| `ensureProfileExists` via dynamic cast | Authentication | Open | `lib/data/providers/auth_provider.dart` — accessed via `(_repository as dynamic)` — fragile but functional |
| `isEmailConfirmationPending` via dynamic cast | Authentication | Open | Same file — not on `AuthRepositoryInterface` |

### Low Priority

| Issue | Affected Feature | Status | Notes |
|-------|-----------------|--------|-------|
| Forgot-password not implemented | Auth | Open | UI label exists in login page but no tap handler |
| Some screens lack named routes | Navigation | Open | Accessed via `Navigator.push(MaterialPageRoute(...))` directly |
| Promo section non-functional | Checkout | Open | UI exists but no input field or logic |
| "Shop By" items static | Menu | Open | No filtering logic behind New Arrivals, Trending, etc. |
| Menu categories hardcoded | Menu | Open | 23 items hardcoded in CategoriesPage, not loaded from Supabase |
| Cover image URL from Supabase | Home | Open | If `cover_url` is null, shows empty container fallback |

---

## Technical Debt

### Dead / Legacy Code (Already Removed)

The following files have been **deleted** from the codebase but are still referenced in some old documentation:

| File | Status | Notes |
|------|--------|-------|
| `lib/data/services/fake_auth_service.dart` | ❌ DELETED | Legacy fake auth — superseded by Supabase |
| `lib/data/repositories/auth_repository.dart` | ❌ DELETED | Legacy wrapper around FakeAuthService |
| `lib/data/repositories/product/local_product_repository.dart` | ❌ DELETED | Local impl — superseded by SupabaseProductRepository |
| `lib/data/repositories/search/local_search_repository.dart` | ❌ DELETED | Local impl — superseded by SupabaseSearchRepository |
| `lib/data/services/cart_storage.dart` | ❌ DELETED | SharedPreferences cart — superseded by SupabaseCartRepository |
| `lib/data/models/cover_model.dart` | ❌ DELETED | Unused cover model |

### Code Quality Issues

| Issue | Location | Severity |
|-------|----------|----------|
| Dynamic cast for `ensureProfileExists` | `lib/data/providers/auth_provider.dart` | Medium |
| Dynamic cast for `isEmailConfirmationPending` | `lib/data/providers/auth_provider.dart` | Medium |
| Mixed navigation patterns (named routes vs Navigator.push) | Various | Low |
| `LocalProductDataSource` still loaded at startup | `lib/data/providers/product_provider.dart` | Low |
| `discountPrice` always null in seed data | Supabase seed data | Low |
| `collection` and `keywords` getters return empty values | `lib/data/models/product_model.dart` | Low |

### Architecture Inconsistencies

| Issue | Notes |
|-------|-------|
| Some navigation uses Navigator.push | While routing uses named routes — mixed approach |
| Cart items join product data on every load | Could be optimized with caching |

### Unused Dependencies

| Package | Notes |
|---------|-------|
| `flutter_credit_card` | Used for card form UI, but no payment processing |

---

## Next Steps (Recommended Order)

### 1. Phase 3.6 — Orders Migration (Next)

**Why:** Orders depend on cart (source of items) and auth (user_id).

**Tasks:**
1. Create `orders` and `order_items` tables in Supabase
2. Add RLS policies (user-owned)
3. Create `SupabaseOrdersRepository`
4. Update `ordersProvider` to use Supabase
5. Migrate order creation in checkout to Supabase
6. Remove SharedPreferences persistence

### 2. Address Migration

**Why:** Addresses are used by checkout, should be per-user.

**Tasks:**
1. Create `addresses` table in Supabase
2. Add RLS policies (user-owned)
3. Create `SupabaseAddressRepository`
4. Update `addressProvider` to use Supabase
5. Remove SharedPreferences persistence

### 4. Forgot Password

**Why:** Important auth feature, relatively simple with Supabase.

**Tasks:**
1. Add `resetPassword()` to `AuthRepositoryInterface`
2. Implement in `SupabaseAuthRepository` using `supabase.auth.resetPasswordForEmail()`
3. Add UI for password reset flow
4. Handle email sent confirmation

### 5. Cleanup & Polish

**Tasks:**
- Fix dynamic cast issues in auth_provider.dart
- Add named routes for all screens
- Load menu categories from Supabase
- Remove any remaining dead code
- Consider removing `LocalProductDataSource` if no longer needed

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
| Orders | SharedPreferences | Supabase | ❌ Not Started |
| Addresses | SharedPreferences | Supabase | ❌ Not Started |
| Payment Cards | SharedPreferences | Third-party? | ❌ Not Started |
| Theme | SharedPreferences | SharedPreferences | ✅ Correct (local is fine) |
| Recent Searches | SharedPreferences | SharedPreferences | ✅ Correct (local is fine) |

---

*See [01_PROJECT_STATUS.md](./01_PROJECT_STATUS.md) for current state, [02_ARCHITECTURE.md](./02_ARCHITECTURE.md) for architecture, and [03_FEATURES_AND_DATA.md](./03_FEATURES_AND_DATA.md) for feature details.*
