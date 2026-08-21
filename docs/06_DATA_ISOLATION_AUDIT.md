# 06 - Data Isolation Audit

> **Date:** 2026-08-12
> **Last Updated:** 2026-08-16 (Address & Payment Card migration to Supabase)
> **Severity:** Critical (P0) - Cross-account data leakage
> **Scope:** Orders, Wishlist, Cart, Addresses, Payment Cards

---

## 1. Root Cause Analysis

**Primary Root Cause:** Riverpod `StateNotifierProvider` instances (`ordersProvider`, `wishlistProvider`, `cartProvider`) persist in memory across authentication state changes. When User A logs out and User B logs in, these providers are **NOT invalidated or recreated**, causing User B to see User A's stale in-memory data.

**Why this happens:**
- `StateNotifierProvider` creates one `StateNotifier` instance per provider for the lifetime of the `ProviderScope` (the entire app session).
- The `OrdersNotifier`, `WishlistNotifier`, and `CartNotifier` constructors call load methods (e.g., `_migrateAndLoad()`, `_load()`, `_loadCart()`) **only once** at construction time.
- When the user logs out (`settings_page.dart:159`), the `AuthNotifier` resets its state but does **NOT** invalidate the data providers.
- When a new user logs in, the data providers still hold the previous user's data in memory.
- The Supabase repositories correctly filter by `auth.uid()` in their queries, but the in-memory cache in the notifiers is never refreshed.

**Secondary Root Cause:** The `OrdersMigrationService` stores its migration flag (`orders_migrated_to_supabase`) in `SharedPreferences` as a global key, not scoped to individual users. If User A migrates local orders, the flag is set to `true` globally, preventing any subsequent user's local orders from ever being migrated.

---

## 2. Database Audit Results

### 2.1 Orders Table (`011_orders_schema.sql`)

| Check | Status | Details |
|-------|--------|---------|
| `user_id` column exists | PASS | `user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE` |
| Foreign key to auth.users | PASS | `REFERENCES auth.users(id) ON DELETE CASCADE` |
| RLS enabled | PASS | `ALTER TABLE orders ENABLE ROW LEVEL SECURITY` |
| SELECT policy | PASS | `USING (auth.uid() = user_id)` |
| INSERT policy | PASS | `WITH CHECK (auth.uid() = user_id)` |
| UPDATE policy | PASS | `USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id)` |
| DELETE policy | PASS | `USING (auth.uid() = user_id)` |
| Indexes | PASS | `idx_orders_user_id`, `idx_orders_created_at` |

### 2.2 Order Items Table (`011_orders_schema.sql`)

| Check | Status | Details |
|-------|--------|---------|
| RLS enabled | PASS | `ALTER TABLE order_items ENABLE ROW LEVEL SECURITY` |
| SELECT policy | PASS | Uses `EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid())` |
| INSERT policy | PASS | Same ownership check through parent `orders` table |
| UPDATE policy | PASS | Same ownership check through parent `orders` table |
| DELETE policy | PASS | Same ownership check through parent `orders` table |
| Foreign key to orders | PASS | `order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE` |

### 2.3 Wishlist Items Table (`010_wishlist_items_schema.sql`)

| Check | Status | Details |
|-------|--------|---------|
| `user_id` column exists | PASS | `user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE` |
| Foreign key to auth.users | PASS | `REFERENCES auth.users(id) ON DELETE CASCADE` |
| RLS enabled | PASS | `ALTER TABLE wishlist_items ENABLE ROW LEVEL SECURITY` |
| SELECT policy | PASS | `USING (auth.uid() = user_id)` |
| INSERT policy | PASS | `WITH CHECK (auth.uid() = user_id)` |
| DELETE policy | PASS | `USING (auth.uid() = user_id)` |
| UPDATE policy | N/A | No update operations on wishlist (add/remove only) |
| Uniqueness | PASS | Unique index on `(user_id, product_id)` |

### 2.4 Cart Items Table (`009_cart_items_schema.sql`)

| Check | Status | Details |
|-------|--------|---------|
| `user_id` column exists | PASS | `user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE` |
| RLS enabled | PASS | `ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY` |
| SELECT policy | PASS | `USING (auth.uid() = user_id)` |
| INSERT policy | PASS | `WITH CHECK (auth.uid() = user_id)` |
| UPDATE policy | PASS | `USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id)` |
| DELETE policy | PASS | `USING (auth.uid() = user_id)` |

### 2.5 Addresses Table (`014_addresses_schema.sql`)

| Check | Status | Details |
|-------|--------|---------|
| `user_id` column exists | PASS | `user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE` |
| RLS enabled | PASS | `ALTER TABLE addresses ENABLE ROW LEVEL SECURITY` |
| SELECT policy | PASS | `USING (auth.uid() = user_id)` |
| INSERT policy | PASS | `WITH CHECK (auth.uid() = user_id)` |
| UPDATE policy | PASS | `USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id)` |
| DELETE policy | PASS | `USING (auth.uid() = user_id)` |

### 2.6 Payment Cards Table (`015_payment_cards_schema.sql`)

| Check | Status | Details |
|-------|--------|---------|
| `user_id` column exists | PASS | `user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE` |
| RLS enabled | PASS | `ALTER TABLE payment_cards ENABLE ROW LEVEL SECURITY` |
| SELECT policy | PASS | `USING (auth.uid() = user_id)` |
| INSERT policy | PASS | `WITH CHECK (auth.uid() = user_id)` |
| UPDATE policy | PASS | `USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id)` |
| DELETE policy | PASS | `USING (auth.uid() = user_id)` |

**Database Verdict:** All table schemas, foreign keys, and RLS policies are correctly implemented. The database layer provides proper data isolation.

---

## 3. Repository Audit Results

### 3.1 SupabaseOrderRepository

| Method | User Filter | Status | Notes |
|--------|-------------|--------|-------|
| `loadOrders()` | `.eq('user_id', userId)` | PASS | Filters by authenticated user |
| `addOrder()` | `'user_id': userId` in insert | PASS | Stores authenticated user's ID |
| `updateOrderStatus()` | `.eq('user_id', userId)` | PASS | Double filter: order_number + user_id |
| `getOrderById()` | N/A (reads from in-memory cache) | PASS | Only returns cached orders |

### 3.2 SupabaseWishlistRepository

| Method | User Filter | Status | Notes |
|--------|-------------|--------|-------|
| `loadWishlist()` | `.eq('user_id', userId)` | PASS | Filters by authenticated user |
| `addToWishlist()` | `'user_id': userId` in insert | PASS | Stores authenticated user's ID |
| `removeFromWishlist()` | `.eq('user_id', userId)` | PASS | Double filter: user_id + product_id |
| `isProductWishlisted()` | `.eq('user_id', userId)` | PASS | Double filter: user_id + product_id |

### 3.3 SupabaseCartRepository

| Method | User Filter | Status | Notes |
|--------|-------------|--------|-------|
| `loadCart()` | `.eq('user_id', userId)` | **FIXED** | Was missing explicit user_id filter (relied solely on RLS) |
| `addItem()` | `'user_id': userId` in insert | PASS | Stores authenticated user's ID |
| `updateQuantity()` | `.eq('id', cartItemId)` | PASS | Uses cart item UUID; RLS provides isolation |
| `removeItem()` | `.eq('id', cartItemId)` | PASS | Uses cart item UUID; RLS provides isolation |
| `clearCart()` | `.eq('user_id', userId)` | PASS | Deletes only user's cart items |
| `_findExistingItem()` | `.eq('user_id', userId)` | PASS | Filters by authenticated user |

### 3.4 SupabaseAddressRepository

| Method | User Filter | Status | Notes |
|--------|-------------|--------|-------|
| `loadAddresses()` | `.eq('user_id', userId)` | PASS | Filters by authenticated user |
| `addAddress()` | `'user_id': userId` in insert | PASS | Stores authenticated user's ID |
| `updateAddress()` | `.eq('id', addressId).eq('user_id', userId)` | PASS | Double filter: id + user_id |
| `deleteAddress()` | `.eq('id', addressId).eq('user_id', userId)` | PASS | Double filter: id + user_id |
| `setDefault()` | `.eq('user_id', userId)` | PASS | Updates within user scope |

### 3.5 SupabasePaymentCardRepository

| Method | User Filter | Status | Notes |
|--------|-------------|--------|-------|
| `loadCards()` | `.eq('user_id', userId)` | PASS | Filters by authenticated user |
| `addCard()` | `'user_id': userId` in insert | PASS | Stores authenticated user's ID |
| `deleteCard()` | `.eq('id', cardId).eq('user_id', userId)` | PASS | Double filter: id + user_id |
| `setDefault()` | `.eq('user_id', userId)` | PASS | Updates within user scope |

**Repository Verdict:** All Supabase repositories correctly use `auth.uid()` for data isolation. The `loadCart()` method was the only one missing an explicit user_id filter (defense in depth).

---

## 4. Provider Audit Results

### 4.1 Root Cause: Provider Lifecycle

```
App Launch
  -> ProviderScope created (lives for entire app session)
  -> User A logs in
  -> ordersProvider created, _migrateAndLoad() runs, loads User A's orders
  -> wishlistProvider created, _load() runs, loads User A's wishlist
  -> addressProvider created, _load() runs, loads User A's addresses
  -> paymentCardProvider created, _load() runs, loads User A's cards
  -> User A logs out (authStateProvider resets, but data providers persist!)
  -> User B logs in
  -> ordersProvider STILL holds User A's orders in memory (BUG!)
  -> wishlistProvider STILL holds User A's wishlist in memory (BUG!)
  -> addressProvider STILL holds User A's addresses in memory (BUG!)
  -> paymentCardProvider STILL holds User A's cards in memory (BUG!)
```

### 4.2 Provider Changes Applied

| Provider | Before | After | Fix |
|----------|--------|-------|-----|
| `ordersProvider` | Independent | Watches `currentUserIdProvider` | Auto-invalidates on auth change |
| `wishlistProvider` | Independent | Watches `currentUserIdProvider` | Auto-invalidates on auth change |
| `cartProvider` | Independent | Watches `currentUserIdProvider` | Auto-invalidates on auth change |
| `addressProvider` | Independent | Watches `currentUserIdProvider` | Auto-invalidates on auth change |
| `paymentCardProvider` | Independent | Watches `currentUserIdProvider` | Auto-invalidates on auth change |

**New Provider Added:**
```dart
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).user?.id;
});
```

This provider derives the current user's ID from auth state. When the user logs out (`user` becomes `null`) or a different user logs in, `currentUserIdProvider` emits a new value, causing all dependent providers to be automatically invalidated and recreated with fresh data.

### 4.3 How the Fix Works

1. `currentUserIdProvider` watches `authStateProvider` and exposes `user?.id`
2. `ordersProvider`, `wishlistProvider`, `cartProvider`, `addressProvider`, and `paymentCardProvider` all `ref.watch(currentUserIdProvider)`
3. When auth state changes (logout/login), `currentUserIdProvider` emits a new value
4. Riverpod detects the dependency change and **invalidates** the data providers
5. The data providers are **recreated**, calling their constructors
6. The constructors call load methods (`_migrateAndLoad()`, `_load()`, `_loadCart()`)
7. The load methods use `_client.auth.currentUser?.id` to query the **new** user's data
8. Result: Clean data isolation between accounts

---

## 5. Migration Service Audit

### 5.1 OrdersMigrationService

| Check | Status | Notes |
|-------|--------|-------|
| Auth check before migration | PASS | Returns error if `currentUser == null` |
| Stores `user_id` on insert | PASS | `'user_id': userId` in order insert |
| Checks for existing orders | PASS | `.eq('order_number', ...).eq('user_id', userId)` |
| Migration flag scoped per user | **FIXED** | Was global key `orders_migrated_to_supabase`, now `orders_migrated_to_supabase_${userId}` |

**Migration Flag Bug:**
- Before: `orders_migrated_to_supabase` (global key in SharedPreferences)
- After: `orders_migrated_to_supabase_${userId}` (per-user key in SharedPreferences)
- Impact: User A's migration flag no longer blocks User B's migration

---

## 6. Local Storage Audit

| Storage | Key | User-Scoped | Status | Notes |
|---------|-----|-------------|--------|-------|
| SharedPreferences | `orders` | No | KNOWN DEBT | Legacy local orders (pre-migration) |
| SharedPreferences | `orders_migrated_to_supabase_*` | Yes (after fix) | FIXED | Per-user migration flag |
| SharedPreferences | `recent_searches_*` | Yes (per-user) | FIXED | Per-user keyed by userId |
| SharedPreferences | `theme_mode` | No | OK | App-wide preference, not user data |

**Note:** `saved_addresses` and `saved_payment_cards` SharedPreferences keys are no longer used — both features have been migrated to Supabase with user-scoped RLS policies.

---

## 7. Every Discovered Bug

### BUG-1: Cross-Account Data Leakage via In-Memory Provider State (CRITICAL)
- **Files:** `orders_provider.dart`, `wishlist_provider.dart`, `cart_provider.dart`
- **Description:** `StateNotifierProvider` instances persist across auth state changes. The `OrdersNotifier`, `WishlistNotifier`, and `CartNotifier` constructors run only once, loading data for the first authenticated user. Subsequent users see stale data.
- **Reproduction:**
  1. Sign in as User A (who has orders/wishlist items)
  2. Go to Settings -> Logout
  3. Sign in as User B (new account, no orders/wishlist)
  4. Navigate to Orders or Wishlist -> User B sees User A's data
- **Fix:** Added `currentUserIdProvider` and made data providers watch it for auto-invalidation.

### BUG-2: Global Migration Flag in SharedPreferences (MEDIUM)
- **File:** `orders_migration_service.dart`
- **Description:** The migration flag `orders_migrated_to_supabase` is a global SharedPreferences key. If User A migrates local orders, the flag is set to `true` globally, preventing any other user's local orders from being migrated.
- **Fix:** Changed to per-user key: `orders_migrated_to_supabase_${userId}`.

### BUG-3: Missing Explicit User Filter in Cart Load (LOW)
- **File:** `supabase_cart_repository.dart`
- **Description:** `loadCart()` did not filter by `user_id` in the query, relying solely on RLS. While RLS provides protection, defense in depth requires explicit filtering.
- **Fix:** Added `.eq('user_id', userId)` to the `loadCart()` query.

### BUG-4: Disposed Notifier Race Condition (CRITICAL - Post-Fix Regression)
- **Files:** `orders_provider.dart`, `wishlist_provider.dart`, `cart_provider.dart`
- **Description:** After introducing `currentUserIdProvider`-based auto-invalidation (Fix 1-4), a new crash emerged: `StateError: Bad state: Tried to use OrdersNotifier after dispose was called.`

  **Root Cause:** When auth state changes (logout/login), Riverpod invalidates the data providers, which disposes the old `StateNotifier` instances. However, async methods started before disposal (e.g., `_migrateAndLoad()`, `_loadCart()`) continue running. When they complete and try to update `state`, the notifier has already been disposed, causing a `StateError`.

  **Reproduction:**
  1. User A logs in → `OrdersNotifier` created, `_migrateAndLoad()` starts
  2. While `_migrateAndLoad()` is awaiting Supabase, User A logs out
  3. Provider is invalidated → `OrdersNotifier` is disposed
  4. `_migrateAndLoad()` completes, tries `state = _repository.getOrders()`
  5. CRASH: `StateError: Bad state: Tried to use OrdersNotifier after dispose`

- **Fix:** Added `if (!mounted) return;` checks after every `await` and before every `state =` / `state.copyWith()` call in all three notifiers.

---

## 8. Lifecycle Audit Results

### 8.1 OrdersNotifier - Race Condition Analysis

| Method | Await Points | Mounted Check | Status |
|--------|-------------|---------------|--------|
| `_migrateAndLoad()` | 3 (`isMigrated`, `migrate()`, `loadOrders()`) | After each await + catch | **FIXED** |
| `addOrder()` | 1 (`addOrder()`) | After await + catch | **FIXED** |
| `updateOrderStatus()` | 1 (`updateOrderStatus()`) | After await + catch | **FIXED** |
| `getOrderById()` | 0 (synchronous) | N/A | OK |

### 8.2 WishlistNotifier - Race Condition Analysis

| Method | Await Points | Mounted Check | Status |
|--------|-------------|---------------|--------|
| `_load()` | 1 (`loadWishlist()`) | After await + catch | **FIXED** |
| `add()` | 0 (fire-and-forget) | N/A | **FIXED** (added `.catchError`) |
| `remove()` | 0 (fire-and-forget) | N/A | **FIXED** (added `.catchError`) |
| `toggle()` | 0 (delegates) | N/A | OK |
| `isWishlisted()` | 0 (synchronous) | N/A | OK |

### 8.3 CartNotifier - Race Condition Analysis

| Method | Await Points | Mounted Check | Status |
|--------|-------------|---------------|--------|
| `_loadCart()` | 1 (`loadCart()`) | Before state update + catch | **FIXED** |
| `addItem()` | 1 (`addItem()`) | After await + catch | **FIXED** |
| `removeItem()` | 1 (`removeItem()`) | After await + catch | **FIXED** |
| `incrementQuantity()` | 1 (`updateQuantity()`) | After await + catch | **FIXED** |
| `decrementQuantity()` | 1 (`updateQuantity()`) | After await + catch | **FIXED** |
| `clear()` | 1 (`clearCart()`) | After await + catch | **FIXED** |

### 8.4 AddressNotifier - Race Condition Analysis

| Method | Await Points | Mounted Check | Status |
|--------|-------------|---------------|--------|
| `_load()` | 1 (`loadAddresses()`) | After await + catch | **FIXED** |
| `add()` | 1 (`addAddress()`) | After await + catch | **FIXED** |
| `update()` | 1 (`updateAddress()`) | After await + catch | **FIXED** |
| `remove()` | 2 (`deleteAddress()`, `setDefault()`) | After each await + catch | **FIXED** |
| `setDefault()` | 1 (`setDefault()`) | After await + catch | **FIXED** |

### 8.5 PaymentCardNotifier - Race Condition Analysis

| Method | Await Points | Mounted Check | Status |
|--------|-------------|---------------|--------|
| `_load()` | 1 (`loadCards()`) | After await + catch | **FIXED** |
| `add()` | 1 (`addCard()`) | After await + catch | **FIXED** |
| `remove()` | 2 (`deleteCard()`, `setDefault()`) | After each await + catch | **FIXED** |
| `setDefault()` | 1 (`setDefault()`) | After await + catch | **FIXED** |

### 8.6 Mounted Check Pattern Applied

```dart
// Pattern 1: Constructor-called async method
Future<void> _loadData() async {
  try {
    final data = await _repository.fetchData();
    if (!mounted) return;  // <-- CHECK AFTER AWAIT
    state = data;
  } catch (_) {
    if (!mounted) return;  // <-- CHECK IN CATCH
    state = [];
  }
}

// Pattern 2: User-triggered async method
Future<void> doSomething() async {
  if (!mounted) return;  // <-- CHECK BEFORE INITIAL STATE UPDATE
  state = state.copyWith(isLoading: true);
  try {
    final result = await _repository.doSomething();
    if (!mounted) return;  // <-- CHECK AFTER AWAIT
    state = state.copyWith(data: result, isLoading: false);
  } catch (e) {
    if (!mounted) return;  // <-- CHECK IN CATCH
    state = state.copyWith(isLoading: false, error: 'Failed');
  }
}

// Pattern 3: Fire-and-forget async call
void remove(String id) {
  state = state.where((item) => item.id != id).toList();
  _repository.delete(id).catchError((_) {});  // <-- CATCH ERRORS
}
```

---

## 9. Stress Test Checklist

### Scenario 1: User logs out while orders are loading
- **Trigger:** Open orders page (triggers `_migrateAndLoad()`), immediately log out
- **Expected:** No crash, provider disposed cleanly, no state update after disposal
- **Status:** PROTECTED by `mounted` checks in `_migrateAndLoad()`

### Scenario 2: User switches accounts while orders are loading
- **Trigger:** Open orders page, switch accounts via logout/login flow
- **Expected:** Old provider disposed, new provider created with empty state, loads new user's data
- **Status:** PROTECTED by `currentUserIdProvider` invalidation + `mounted` checks

### Scenario 3: User places an order and immediately logs out
- **Trigger:** Place order (triggers `addOrder()`), immediately log out during network request
- **Expected:** Order may or may not be saved (network dependent), no crash
- **Status:** PROTECTED by `mounted` check in `addOrder()` after await

### Scenario 4: User logs in and out repeatedly
- **Trigger:** Rapid login/logout cycles (5+ times)
- **Expected:** Each cycle invalidates providers, recreates them cleanly, no memory leaks
- **Status:** PROTECTED by provider invalidation + `mounted` checks

### Scenario 5: Multiple rapid auth changes
- **Trigger:** Quick succession of auth state changes (e.g., token refresh failures)
- **Expected:** Providers stabilize on final auth state, no cascading crashes
- **Status:** PROTECTED by `mounted` checks in all async paths

### Scenario 6: Application restart
- **Trigger:** Kill app, relaunch
- **Expected:** Fresh provider state, migration runs if needed, clean data load
- **Status:** OK - ProviderScope is recreated, all providers start fresh

### Scenario 7: Provider recreation after auth changes
- **Trigger:** Login as User A, logout, login as User B
- **Expected:** User B sees only their own data, no stale data from User A
- **Status:** PROTECTED by `currentUserIdProvider` + `mounted` checks

### Scenario 8: Network failure during auth change
- **Trigger:** Start loading data, lose network, then log out
- **Expected:** Network error caught, `mounted` check prevents state update after disposal
- **Status:** PROTECTED by `try/catch` + `mounted` checks

### Scenario 9: Migration runs during logout
- **Trigger:** First login (migration needed), log out while migration is in progress
- **Expected:** Migration may complete or fail, no crash, provider disposed cleanly
- **Status:** PROTECTED by `mounted` checks after each await in `_migrateAndLoad()`

### Scenario 10: Cart operations during account switch
- **Trigger:** Add item to cart, quickly switch accounts
- **Expected:** Cart operation completes or fails gracefully, new user sees empty cart
- **Status:** PROTECTED by `mounted` checks in all cart methods

### Scenario 11: Address operations during account switch
- **Trigger:** Add/edit address, quickly switch accounts
- **Expected:** Address operation completes or fails gracefully, new user sees their own addresses
- **Status:** PROTECTED by `mounted` checks in all address methods

### Scenario 12: Payment card operations during account switch
- **Trigger:** Add/delete card, quickly switch accounts
- **Expected:** Card operation completes or fails gracefully, new user sees their own cards
- **Status:** PROTECTED by `mounted` checks in all payment card methods

---

## 10. Every Applied Fix

### Fix 1: `lib/data/providers/auth_provider.dart`
- **Added** `currentUserIdProvider` that derives user ID from auth state
- This is the single source of truth for "who is the current user" across the app

### Fix 2: `lib/data/providers/orders_provider.dart`
- **Added** `import 'package:max/data/providers/auth_provider.dart'`
- **Added** `ref.watch(currentUserIdProvider)` in `ordersProvider`
- Provider now auto-invalidates when auth state changes

### Fix 3: `lib/data/providers/wishlist_provider.dart`
- **Added** `import 'package:max/data/providers/auth_provider.dart'`
- **Added** `ref.watch(currentUserIdProvider)` in `wishlistProvider`
- Provider now auto-invalidates when auth state changes

### Fix 4: `lib/data/providers/cart_provider.dart`
- **Added** `import 'package:max/data/providers/auth_provider.dart'`
- **Added** `ref.watch(currentUserIdProvider)` in `cartProvider`
- Provider now auto-invalidates when auth state changes

### Fix 5: `lib/data/services/orders_migration_service.dart`
- **Changed** `_migrationKey` from global `'orders_migrated_to_supabase'` to prefix `'orders_migrated_to_supabase_'`
- **Updated** `isMigrated` getter to read `'$_migrationKeyPrefix${user.id}'`
- **Updated** `migrate()` to write to `'$_migrationKeyPrefix$userId'`

### Fix 6: `lib/data/repositories/cart/supabase_cart_repository.dart`
- **Added** authentication check and `.eq('user_id', userId)` filter to `loadCart()`
- Defense-in-depth alongside RLS

### Fix 7: `lib/data/providers/orders_provider.dart` (Lifecycle Protection)
- **Added** `if (!mounted) return;` after every `await` and before every `state =` in:
  - `_migrateAndLoad()`: 3 mounted checks + 1 in catch
  - `addOrder()`: 1 mounted check
  - `updateOrderStatus()`: 1 mounted check
- **Wrapped** `_migrateAndLoad()` body in `try/catch` for safe error handling

### Fix 8: `lib/data/providers/wishlist_provider.dart` (Lifecycle Protection)
- **Added** `if (!mounted) return;` after `await` in `_load()` + 1 in catch
- **Added** `.catchError((_) {})` to fire-and-forget calls in `add()` and `remove()`

### Fix 9: `lib/data/providers/cart_provider.dart` (Lifecycle Protection)
- **Added** `if (!mounted) return;` checks to ALL 6 async methods:
  - `_loadCart()`: 2 mounted checks (before state update + after await) + 1 in catch
  - `addItem()`: 2 mounted checks (before initial update + after await) + 1 in catch
  - `removeItem()`: 2 mounted checks (before initial update + after await) + 1 in catch
  - `incrementQuantity()`: 2 mounted checks (before initial update + after await) + 1 in catch
  - `decrementQuantity()`: 2 mounted checks (before initial update + after await) + 1 in catch
  - `clear()`: 2 mounted checks (before initial update + after await) + 1 in catch

### Fix 10: `lib/data/providers/address_provider.dart` (Auth-Aware + Lifecycle Protection)
- **Added** `import 'package:max/data/providers/auth_provider.dart'`
- **Added** `ref.watch(currentUserIdProvider)` in `addressProvider`
- **Added** `if (!mounted) return;` checks in all async methods (`_load`, `add`, `update`, `remove`, `setDefault`)

### Fix 11: `lib/data/providers/payment_card_provider.dart` (Auth-Aware + Lifecycle Protection)
- **Added** `import 'package:max/data/providers/auth_provider.dart'`
- **Added** `ref.watch(currentUserIdProvider)` in `paymentCardProvider`
- **Added** `if (!mounted) return;` checks in all async methods (`_load`, `add`, `remove`, `setDefault`)

### Fix 12: Migration to Supabase (Addresses & Payment Cards)
- **Addresses:** `SupabaseAddressRepository` replaced SharedPreferences persistence. `addresses` table with RLS created via migration 014.
- **Payment Cards:** `SupabasePaymentCardRepository` replaced `PaymentCardStorage` (SharedPreferences). `payment_cards` table with RLS created via migration 015. `PaymentCardStorage` deleted.

---

## 11. Remaining Technical Debt

| Issue | Severity | Description | Recommended Fix |
|-------|----------|-------------|-----------------|
| No `deleteOrder` in repository | LOW | Orders cannot be deleted by the user. May be intentional (admin-only). | Consider adding if user-initiated cancellation is needed. |

---

## 12. Verification Steps

To verify the fixes are working:

1. **Fresh install** or clear app data
2. **Sign in as User A** (or create Account A)
3. Add items to wishlist, place an order, add items to cart, add addresses, add payment cards
4. **Navigate to Orders/Wishlist/Cart/Addresses/PaymentMethods** and confirm data appears
5. **Log out** via Settings
6. **Sign in as User B** (new account)
7. **Navigate to Orders** - should be empty
8. **Navigate to Wishlist** - should be empty
9. **Navigate to Cart** - should be empty
10. **Navigate to Addresses** - should be empty
11. **Navigate to Payment Methods** - should be empty
12. **Log out**, **log back in as User A** - confirm User A's data is still intact

**Lifecycle Verification:**
13. **Open Orders page** (triggers async load), **immediately log out** - verify no crash
14. **Open Cart page** (triggers async load), **immediately log out** - verify no crash
15. **Open Addresses page** (triggers async load), **immediately log out** - verify no crash
16. **Open Payment Methods page** (triggers async load), **immediately log out** - verify no crash
17. **Rapid login/logout** 5+ times - verify no crashes or state corruption
18. **Place an order**, **immediately log out** during network request - verify no crash

---

## 13. Architecture Diagram: Data Flow After Fix

```
Auth State Change (login/logout)
        |
        v
authStateProvider (emits new AuthState)
        |
        v
currentUserIdProvider (emits new userId or null)
        |
        +-----> ordersProvider (invalidated -> disposed -> recreated)
        |              |
        |              v
        |         OrdersNotifier (new instance)
        |              |
        |              v
        |         _migrateAndLoad() runs with mounted checks
        |              |
        |              v
        |         Supabase queries with auth.currentUser?.id
        |
        +-----> wishlistProvider (invalidated -> disposed -> recreated)
        |              |
        |              v
        |         WishlistNotifier (new instance)
        |              |
        |              v
        |         _load() runs with mounted checks
        |
        +-----> cartProvider (invalidated -> disposed -> recreated)
        |              |
        |              v
        |         CartNotifier (new instance)
        |              |
        |              v
        |         _loadCart() runs with mounted checks
        |
        +-----> addressProvider (invalidated -> disposed -> recreated)
        |              |
        |              v
        |         AddressNotifier (new instance)
        |              |
        |              v
        |         _load() runs with mounted checks
        |
        +-----> paymentCardProvider (invalidated -> disposed -> recreated)
                       |
                       v
                  PaymentCardNotifier (new instance)
                       |
                       v
                  _load() runs with mounted checks
```

**Defense in depth (3 layers):**
1. **Application layer:** Explicit `user_id` filters in all Supabase queries
2. **Database layer:** RLS policies enforce `auth.uid() = user_id`
3. **Lifecycle layer:** `mounted` checks prevent state updates after disposal
