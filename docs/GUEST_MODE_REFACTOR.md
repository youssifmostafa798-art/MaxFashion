# Guest Mode Refactor

## Current Guest Mode Problem

The previous Guest Mode implementation was minimal and broken:

1. **No `isGuest` state** — "Continue as Guest" simply navigated to `MainScreen` without setting any auth state. There was no way to distinguish between "intentionally browsing as guest" and "logged out."

2. **All user-scoped providers crashed for guests** — `cartProvider`, `wishlistProvider`, `ordersProvider`, `addressProvider`, and `paymentCardProvider` all attempted Supabase calls with a null user ID on initialization, causing 5 simultaneous failed API calls and misleading error messages like "Could not load your cart."

3. **No authentication guards** — Guests could navigate to any route (checkout, edit profile, addresses, payment methods, orders) and encounter error states or broken UI.

4. **Actions failed silently** — Adding to cart, toggling wishlist, and other user-scoped actions failed with error messages that didn't explain the real issue (no authentication).

5. **Settings showed "Logout" for guests** — Semantically incorrect since guests have no session.

## Audit Findings

### Critical Issues
- All 5 user-scoped providers fail on initialization for guests (5 failed Supabase calls)
- Add to Cart fails for guests with misleading error
- Favorite toggle fails for guests with misleading error  
- No guest authentication guard on any protected screen
- Settings logout misleading for guests

### Medium Issues
- Profile page shows "Guest User" but only a tappable header with no clear sign-in CTA
- No reusable guest prompt mechanism

### Navigation Verified
- Guest → Login → MainScreen (works correctly)
- Guest → Signup → MainScreen (works correctly)
- Logout → AuthPage (works correctly)
- No back-navigation loops found

### User Isolation Verified
- All repositories filter by `user_id` — no cross-account data leakage
- After logout, providers reinitialize with null userId — state cleared
- After login, providers reinitialize with new userId — fresh data loaded

## Architecture Decision

### Selected: OPTION 1 — Guests can browse; authentication required for user-specific features.

### Why This Is the Safest Choice
- Matches existing Supabase RLS architecture (all user tables require `user_id`)
- Search and product browsing are already auth-free (RPC `search_products`, product queries)
- No local storage or data sync needed — zero persistence complexity
- Consistent with standard e-commerce patterns (browse without login, auth for cart/checkout/profile)
- Minimal changes to existing architecture
- No risk of data leakage between guest sessions and authenticated users

### Why Other Options Are Less Suitable

**OPTION 2 (Local guest storage with sync):**
- Would require SharedPreferences/local DB for cart, wishlist
- Complex merge logic when user logs in (conflicts, duplicates)
- Supabase architecture doesn't support anonymous/guest user IDs
- Major provider/repository refactoring required

**OPTION 3 (Remove Guest Mode):**
- Breaks existing auth_page.dart flow
- Forces auth before browsing — poor UX for a fashion browsing app

## Authentication Boundaries

| Feature | Guest Access | Auth Required |
|---------|-------------|---------------|
| Browse products | ✅ | |
| View categories | ✅ | |
| Search products | ✅ | |
| View product details | ✅ | |
| Add to cart | | ✅ |
| View cart | | ✅ |
| Checkout | | ✅ |
| Wishlist | | ✅ |
| Orders | | ✅ |
| Addresses | | ✅ |
| Payment methods | | ✅ |
| Edit profile | | ✅ |
| Settings | ✅ | |

## Modified Files

### Core Auth State
| File | Change |
|------|--------|
| `lib/data/providers/auth_provider.dart` | Added `isGuest` field to `AuthState`, added `enterGuestMode()` method, ensured `isGuest` is cleared on login/signup/restore |

### Auth Entry Point
| File | Change |
|------|--------|
| `lib/features/auth/presentation/pages/auth_page.dart` | Converted to `ConsumerStatefulWidget`, "Continue as Guest" now calls `enterGuestMode()` before navigating |

### User-Scoped Providers (5 files)
| File | Change |
|------|--------|
| `lib/data/providers/cart_provider.dart` | Added `userId` parameter to `CartNotifier`, skip `_loadCart()` when null |
| `lib/data/providers/wishlist_provider.dart` | Added `userId` parameter to `WishlistNotifier`, skip `_load()` when null |
| `lib/data/providers/orders_provider.dart` | Added `userId` parameter to `OrdersNotifier`, skip `_migrateAndLoad()` when null |
| `lib/data/providers/address_provider.dart` | Added `userId` parameter to `AddressNotifier`, skip `_load()` when null |
| `lib/data/providers/payment_card_provider.dart` | Added `userId` parameter to `PaymentCardNotifier`, skip `_load()` when null |

### Guest-Aware UI Screens (6 files)
| File | Change |
|------|--------|
| `lib/features/profile/presentation/pages/profile_page.dart` | Guest-aware header with sign-in CTA, protected menu items show login prompt |
| `lib/features/cart/presentation/pages/cart_page.dart` | Guest view: "Sign in to view your bag" with login button |
| `lib/features/wishlist/presentation/pages/wishlist_page.dart` | Guest view: "Sign in to view your wishlist" with login button |
| `lib/features/orders/presentation/pages/orders_page.dart` | Guest view: "Sign in to view your orders" with login button |
| `lib/features/checkout/presentation/widgets/favorite_button.dart` | Shows login prompt for guests instead of silently failing |
| `lib/features/product/presentation/pages/product_detail_page.dart` | Shows login prompt when guest taps "Add to cart" |
| `lib/features/settings/presentation/pages/settings_page.dart` | Shows "Sign In" instead of "Logout" for guests |

### New Files
| File | Purpose |
|------|---------|
| `lib/core/widgets/dialog/guest_prompt_dialog.dart` | Reusable dialog with Sign In / Create Account / Cancel options |

## Files Intentionally Not Modified

### Search (already correctly redesigned)
- `lib/data/providers/search_provider.dart`
- `lib/data/repositories/search/search_repository.dart`
- `lib/data/repositories/search/supabase_search_repository.dart`
- `lib/features/search/presentation/pages/search_screen.dart`
- All search widgets

### Providers (already correctly redesigned)
- `lib/data/providers/product_provider.dart`
- `lib/data/providers/home_content_provider.dart`

### Repositories (correctly throw for unauthenticated users)
- All Supabase repository implementations

### Other
- `lib/core/router/app_router.dart` — No route-level guards needed
- `lib/splash.dart` — Session check logic unchanged
- `lib/main.dart` — Entry point unchanged
- `lib/features/main/presentation/pages/main_screen.dart` — Badges already handle empty state
- All models, themes, skeletons, and utility files

## Navigation Flow

### Guest → Authenticated
```
Auth Page → "Continue as Guest" → [isGuest=true] → MainScreen
MainScreen → tap protected feature → GuestPromptDialog → "Sign In" → LoginPage
LoginPage → successful login → [isGuest=false, user set] → MainScreen (providers reload)
```

### Authenticated → Guest
```
Settings → "Logout" → AuthNotifier.logout() → [isGuest=false, user=null] → Auth Page
Auth Page → "Continue as Guest" → [isGuest=true] → MainScreen
```

### Back Navigation
- Guest on MainScreen → back button → app exits (standard Android behavior)
- Guest on LoginPage → back → Auth Page
- Authenticated on MainScreen → back → app exits

## User Isolation Considerations

1. **Guest sessions** have `user == null` and `isGuest == true` — no Supabase user ID
2. **All repositories** filter by `user_id` — no cross-account data leakage possible
3. **After login**, providers reinitialize via `currentUserIdProvider` watch — fresh data loaded
4. **After logout**, providers reinitialize with null userId — state cleared
5. **No guest data persists locally** — no SharedPreferences additions for cart/wishlist
6. **Login → Logout → Login (different user)**: providers reinitialize with new userId — correct isolation

## Testing Checklist

1. ✅ Fresh app launch as guest — Splash → Auth → "Continue as Guest" → MainScreen with no errors
2. ✅ Guest browsing — Home loads products, categories work, search works, product detail loads
3. ✅ Guest opening protected features — Cart, Wishlist, Orders, Profile menu items all show "Sign in" prompt
4. ✅ Guest → Login — Tap "Sign In" from any guest prompt → Login page → successful login → MainScreen with user data
5. ✅ Guest → Signup — Tap "Create Account" from any guest prompt → Signup page → successful signup → MainScreen with user data
6. ✅ Login → authenticated app — All providers load user data correctly
7. ✅ Logout → state cleared — Settings → Logout → Auth page
8. ✅ Search still works — Verified search is unaffected by guest mode
9. ✅ Providers expose correct loading/error/data states — No regressions
10. ✅ Build compiles with no analysis issues

## Known Limitations

1. Guest cart/wishlist are empty — items are not saved locally. This is by design (Option 1).
2. The `Future.delayed` artificial loading in `WishlistPage` and `OrdersPage` is pre-existing and intentionally not changed (unrelated to guest mode).
3. Providers still make Supabase calls when userId is null if somehow triggered to reload outside the normal lifecycle. The provider changes mitigate this for the initial load.

## Future Improvements

1. **Route-level auth guards** — Could be added to `AppRouter` for deep link protection
2. **Persistent guest cart** — Local storage for guest cart items (requires Option 2 architecture)
3. **Guest checkout** — Allow guest checkout with email (requires Supabase anonymous auth or guest order support)
4. **Animated transitions** — Guest prompt dialogs could have more polished animations
