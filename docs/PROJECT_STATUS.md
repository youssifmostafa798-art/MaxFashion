# Project Status

> **Generated:** Sat Aug 01 2026
> **Source of truth:** Codebase inspection (not documentation)

---

## Overall Completion

| Category | % | Notes |
|---|---|---|
| **Overall** | **~22%** | Most screens exist but many are incomplete; all data is hardcoded/mock |
| **UI** | **~40%** | Core screens built but missing loading states, skeleton loaders, error states, accessibility |
| **Business Logic** | **~25%** | Cart works locally; auth is fake; search recent saves are broken |
| **Architecture** | **~50%** | Feature-first structure, Riverpod integrated, repository pattern started |
| **Backend** | **0%** | No Supabase, no real API, all data hardcoded in static model lists |
| **State Management** | **~40%** | Riverpod for auth, cart, search, theme; but cart has no persistence |

---

## Completed Features

| # | Feature | Evidence |
|---|---------|----------|
| 1 | Flutter project scaffolded with feature-first architecture | `lib/core/`, `lib/features/`, `lib/data/` structure |
| 2 | Splash screen with fade animation and auto-login routing | `lib/splash.dart` — checks `fake_auth_remember_me` + `fake_auth_is_logged_in` |
| 3 | Auth entry page (Create Account / Continue as Guest) | `lib/features/auth/presentation/pages/auth_page.dart` |
| 4 | Login page with form validation and Riverpod auth state | `lib/features/auth/presentation/pages/login_page.dart` |
| 5 | Signup page with phone validation (Egyptian numbers) | `lib/features/auth/presentation/pages/signup_page.dart` |
| 6 | Fake auth service with SharedPreferences persistence | `lib/data/services/fake_auth_service.dart` — stores users, current user, remember me |
| 7 | Auth repository + auth state provider (Riverpod) | `lib/data/providers/auth_provider.dart` — `authStateProvider` |
| 8 | App theme (light + dark) with persistence | `lib/core/theme/app_theme.dart`, `theme_provider.dart`, `theme_storage.dart` |
| 9 | Centralized AppColors | `lib/core/theme/app_colors.dart` — comprehensive color palette |
| 10 | flutter_screenutil integrated | `main.dart` — `ScreenUtilInit` with design size 375x812 |
| 11 | Named route navigation with AppRouter | `lib/core/router/app_router.dart` — 6 routes |
| 12 | Main screen with BottomNavigationBar + IndexedStack | `lib/features/main/presentation/pages/main_screen.dart` — 4 tabs, lazy page cache |
| 13 | Home screen with covers and product grid | `lib/features/home/presentation/pages/home.dart` — hardcoded data |
| 14 | Categories page with grid and "Shop By" list | `lib/features/menu/presentation/pages/categories_page.dart` — hardcoded |
| 15 | Search screen with text input and context system | `lib/features/search/presentation/pages/search_screen.dart` |
| 16 | Search suggestions (recent, suggested, popular categories) | `lib/features/search/presentation/widgets/search_suggestions.dart` |
| 17 | Search results list with highlighted text | `lib/features/search/presentation/widgets/search_results_list.dart`, `highlighted_text.dart` |
| 18 | Cart page with items, quantity controls, empty state | `lib/features/cart/presentation/pages/cart_page.dart` |
| 19 | Cart state management (add, remove, increment, decrement) | `lib/data/providers/cart_provider.dart` — `cartProvider` |
| 20 | Cart subtotal/total providers | `lib/data/providers/cart_provider.dart` — `cartSubtotalProvider`, `cartTotalProvider` |
| 21 | Checkout/product detail page with add-to-cart dialog | `lib/features/checkout/presentation/checkout.dart` |
| 22 | Place order screen with address, payment, method display | `lib/features/checkout/presentation/place_order.dart` |
| 23 | Add address form | `lib/features/checkout/presentation/add_address.dart` |
| 24 | Add credit card form (flutter_credit_card) | `lib/features/checkout/presentation/add_card.dart` |
| 25 | Profile page with header, menu, theme toggle, logout | `lib/features/profile/presentation/pages/profile_page.dart` |
| 26 | Reusable widgets: CustomAuthTextField, CustomAuthButton | `lib/features/auth/presentation/widgets/` |
| 27 | Reusable widgets: CardWidget, Header, CustemText, Button | `lib/core/widgets/` |
| 28 | Reusable widgets: SearchTextField, SearchTapWidget, ProfileMenuItem, CartItemCard | Various feature widgets |
| 29 | Product and category models with static data | `lib/data/models/product_model.dart` (6 products), `category_model.dart` (7 categories) |
| 30 | Search repository abstraction + local implementation | `lib/data/repositories/search/` — abstract + LocalSearchRepository |
| 31 | Splash screen with fade-in animation | `lib/splash.dart` — `AnimationController` + `FadeTransition` |

---

## Features In Progress

| # | Feature | Status | What's Done | What's Missing |
|---|---------|--------|-------------|----------------|
| 1 | **Home Screen** | ~60% | Cover images, product grid, footer | No loading states, no error handling, no carousel, no category rail |
| 2 | **Search** | ~50% | UI, suggestions, results, highlighting | Recent searches broken (no-ops), no filters, no sort, simple contains-only search |
| 3 | **Checkout Flow** | ~60% | Product detail, add-to-cart, address/card forms, place order UI | No actual order submission, hardcoded payment ID, address concatenation bug |
| 4 | **Profile** | ~40% | Header, menu items, theme toggle, logout | All menu `onTap` handlers are empty no-ops, hardcoded badge counts |
| 5 | **Categories** | ~50% | Category grid, shop-by list | Category tap doesn't filter search, shop-by items non-functional |
| 6 | **Auth** | ~40% | Login, signup, fake persistence | No forgot password, no email verification, passwords stored in plaintext |

---

## Remaining Features

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 1 | Wishlist screen (add/remove/favorite) | High | Not started — no screen exists |
| 2 | Real Supabase backend integration | High | Zero backend — all data hardcoded |
| 3 | Real authentication (Supabase email/password) | High | Currently using FakeAuthService |
| 4 | Forgot Password flow | Medium | Not started |
| 5 | Email Verification flow | Medium | Not started |
| 6 | Order History screen | Medium | Not started |
| 7 | Order Detail screen | Medium | Not started |
| 8 | Search filters (category, brand, price, size) | Medium | Not started |
| 9 | Search sort options | Medium | Not started |
| 10 | Product variant selection (size/color) | Medium | UI exists in checkout but not functional |
| 11 | Cart persistence (SharedPreferences/Supabase) | High | Cart lost on app restart |
| 12 | Loading/skeleton states for all screens | Medium | None exist |
| 13 | Error states for all screens | Medium | None exist |
| 14 | Empty states (wishlist, orders) | Low | Cart empty state exists |
| 15 | Hero animations between screens | Low | Not started |
| 16 | Accessibility pass (contrast, tap targets) | Low | Not started |
| 17 | Profile editing (name, avatar, contact info) | Medium | Menu items exist but non-functional |
| 18 | Manage Addresses (CRUD) | Medium | Add address form exists, no list/edit/delete |
| 19 | Account actions (change password, delete account) | Low | Not started |
| 20 | Unit tests | Medium | Only smoke test exists |
| 21 | Widget tests | Medium | None |
| 22 | Performance optimization | Low | Not started |
| 23 | Signed APK/AAB builds | Low | Not started |
| 24 | Product listing/category page with grid + sort | Medium | Categories page exists but no product listing |

---

## Current Bugs

| # | Severity | File | Description |
|---|----------|------|-------------|
| 1 | 🔴 Critical | `lib/data/providers/search_provider.dart` | **Recent searches are broken** — `_recentSearches` getter always returns `const []`; `_saveRecentSearches()` is a no-op. Recent searches are never loaded or saved. |
| 2 | 🔴 Critical | `lib/data/services/fake_auth_service.dart` | **Passwords stored in plaintext** in SharedPreferences. Security vulnerability. |
| 3 | 🟠 High | `lib/data/services/fake_auth_service.dart` | **Mutates cached data** — `match.first..remove('password')` modifies the stored map in memory, potentially corrupting the users list. |
| 4 | 🟠 High | `lib/features/checkout/presentation/add_card.dart` | **Trailing space in map key `'date '`** — will cause issues when reading `savedCard['date']` in `place_order.dart` (reads `'date'` without space). |
| 5 | 🟠 High | `lib/features/checkout/presentation/place_order.dart` | **Address fields concatenated without spaces** — `"${_savedAddress['city']}${_savedAddress['address']}"` produces `"CityAddress"` with no separator. |
| 6 | 🟡 Medium | `lib/features/checkout/presentation/place_order.dart` | **Hardcoded payment ID** — `"Payment ID 15263541"` is fake data displayed as real. |
| 7 | 🟡 Medium | `lib/data/models/product_model.dart` | **All 6 products have identical description** — `"reversible angora cardigan"` (copy-paste error). Field is also misspelled as `descrp`. |
| 8 | 🟡 Medium | `lib/features/search/presentation/widgets/search_suggestions.dart` | **Suggested product tap navigates to blank Scaffold** — `onTap` routes to an empty `Scaffold()`. |
| 9 | 🟡 Medium | `lib/features/search/presentation/widgets/highlighted_text.dart` | **Highlight color same as text color** — `highlightColor` defaults to `colorScheme.onSurface`, making highlights invisible. |
| 10 | 🟡 Medium | `lib/features/checkout/presentation/add_address.dart` | **First/last name controllers exist but are never used in UI** — controllers created, not attached to any TextFormField. |
| 11 | 🟢 Low | `lib/features/profile/presentation/pages/profile_page.dart` | **All 5 menu `onTap` handlers are empty no-ops** — My Orders, Wishlist, Addresses, Settings do nothing. |
| 12 | 🟢 Low | `lib/features/menu/presentation/pages/categories_page.dart` | **Category tap navigates to unfiltered SearchScreen** — no category filter applied. |
| 13 | 🟢 Low | Multiple files | **Pervasive typo: `custem`** used instead of `custom` in filenames and class names (custem_appbar, custem_bottom, custem_text, custem_text_field). |
| 14 | 🟢 Low | `lib/data/providers/cart_provider.dart` | **`cartTotalProvider` is redundant** — identical to `cartSubtotalProvider` (no tax/shipping calculation). |
| 15 | 🟢 Low | `lib/data/models/cart_item_model.dart` | **`generateProductId` static method is never used** anywhere in the codebase. |

---

## Technical Debt

### Dead Code
- `lib/data/providers/cart_provider.dart` — `cartTotalProvider` (redundant, same as subtotal)
- `lib/data/models/cart_item_model.dart` — `generateProductId()` never called
- `lib/data/providers/search_provider.dart` — `searchSourceProvider` always returns `null`
- `lib/features/checkout/presentation/add_address.dart` — `firstNameController`, `lastNameController` created but never attached to UI

### Duplicate Code
- Hardcoded `Color(0xffDD8560)` appears in `home.dart`, `search_results_list.dart`, `card_widget.dart` — should be centralized
- Font family `'Tenor_Sans'` hardcoded in multiple widget files instead of using `AppConstants.fontFamily`

### Refactoring Opportunities
- Rename all `custem_*` files/classes to `custom_*` (affects 4+ files)
- Extract accent color `Color(0xffDD8560)` to `AppColors`
- Consolidate search context logic — enum exists but provider always returns `global`
- Unify form validation — some forms validate, some don't
- Replace `dynamic` types with proper models (address map, card map, products parameter)

### Temporary Implementations
- `FakeAuthService` — entire auth system is a mock; passwords stored in plaintext
- All product/category/cover data is hardcoded in static model lists
- Place order shows hardcoded "Payment ID 15263541" — no real order submission
- Profile menu badge counts (`'3'`, `'8'`, `'2'`) are hardcoded strings

### Mock Services
- `lib/data/services/fake_auth_service.dart` — the only service; no real backend exists

### Hardcoded Data
- `lib/data/models/product_model.dart` — 6 products with IDs, names, images, prices
- `lib/data/models/category_model.dart` — 7 categories
- `lib/data/models/cover_model.dart` — 3 cover images
- `lib/features/home/presentation/pages/home.dart` — footer text, copyright, contact info
- `lib/features/menu/presentation/pages/categories_page.dart` — all categories and shop-by items
- `lib/features/profile/presentation/pages/profile_page.dart` — menu badge counts

---

## Tomorrow's Development Plan

### Priority 1 — Fix Critical Bugs
- [ ] Fix recent searches in `search_provider.dart` (implement actual persistence)
- [ ] Fix the `match.first..remove('password')` mutation bug in `fake_auth_service.dart`
- [ ] Fix the `'date '` trailing space key in `add_card.dart`
- [ ] Fix address concatenation without spaces in `place_order.dart`

### Priority 2 — Complete Profile Screen
- [ ] Wire all profile menu `onTap` handlers to actual screens (My Orders, Wishlist, Addresses, Settings)
- [ ] Replace hardcoded badge counts with actual data providers
- [ ] Build Wishlist screen (at least empty state + placeholder)

### Priority 3 — Fix Search
- [ ] Fix suggested product tap navigating to blank Scaffold
- [ ] Fix highlight color being invisible in search results
- [ ] Make category tap actually filter search results

### Priority 4 — Polish Checkout
- [ ] Remove hardcoded payment ID from place order
- [ ] Wire first/last name in add address form
- [ ] Add form validation to add address

### Priority 5 — Code Quality
- [ ] Rename `custem_*` to `custom_*` across the project
- [ ] Extract hardcoded accent color to `AppColors`
- [ ] Replace `dynamic` types with proper models
- [ ] Fix product model `descrp` typo to `description`
- [ ] Fix all 6 products having the same description

---

## Updated Roadmap

### Milestone 1 — Fix Bugs & Complete Existing Screens (Current)
> Duration: 1–2 days

1. Fix all critical/high bugs listed above
2. Complete profile menu navigation (wire empty handlers)
3. Build Wishlist screen (empty state + placeholder)
4. Fix search (recent saves, suggested tap, highlight color, category filtering)
5. Polish checkout (address form, remove hardcoded data)

### Milestone 2 — Code Quality & Architecture
> Duration: 1 day

6. Rename `custem_*` to `custom_*`
7. Extract all hardcoded colors to `AppColors`
8. Replace `dynamic` types with proper models
9. Add loading states to cart and search
10. Add empty states for wishlist and orders

### Milestone 3 — Backend Integration
> Duration: 3–5 days

11. Set up Supabase project, env vars, initialize client
12. Replace FakeAuthService with real Supabase auth
13. Create database schema (profiles, products, categories, orders, etc.)
14. Add RLS policies
15. Wire Home/Categories to live data

### Milestone 4 — Feature Completion
> Duration: 3–5 days

16. Implement wishlist with Supabase backend
17. Implement search with Supabase (ILIKE/full-text)
18. Implement cart persistence
19. Implement real order submission
20. Build Order History and Order Detail screens
21. Build Profile editing

### Milestone 5 — Polish & Release
> Duration: 2–3 days

22. Skeleton loaders and error states
23. Hero animations
24. Accessibility pass
25. Unit and widget tests
26. Performance optimization
27. Signed APK/AAB builds

---

## Development Notes

### Architecture Decisions (Already Made)
- **State management:** Riverpod (chosen and integrated — NOT "TBD" as the old doc claims)
- **Navigation:** Named routes with `onGenerateRoute` (not go_router yet)
- **Auth:** FakeAuthService with SharedPreferences (temporary)
- **Backend:** No Supabase yet — all data is hardcoded

### Code Conventions
- Feature-first folder structure: `features/<feature>/presentation/pages|widgets/`
- Data layer: `data/models/`, `data/providers/`, `data/repositories/`, `data/services/`
- Core: `core/theme/`, `core/router/`, `core/widgets/`, `core/constants/`
- Uses `flutter_screenutil` for responsive sizing (`.w`, `.h`, `.sp`, `.r`)
- Uses `flutter_riverpod` for state management
- Uses `flutter_svg` for SVG assets
- Custom font: Tenor Sans (loaded from assets)
- Widget naming: `ConsumerWidget` / `ConsumerStatefulWidget` for Riverpod integration

### Important Warnings for Future Sessions
1. **Do NOT assume the old `AI_PROJECT_CONTEXT.md` is accurate** — it says state management is "TBD" but Riverpod is already fully integrated
2. **The cart has NO persistence** — it's a Riverpod `StateNotifier` that resets on app restart
3. **Search recent searches are broken** — the provider methods are no-ops
4. **All product data is hardcoded** in `product_model.dart` — there are exactly 6 products
5. **The `descrp` field in ProductModel** should be `description` (typo carried throughout)
6. **The `'date '` trailing space bug** in `add_card.dart` will cause the place order screen to fail to read the expiry date correctly
7. **Profile menu items are decorative** — all `onTap` handlers are empty `() {}`
8. **There is only 1 test** — a smoke test in `test/widget_test.dart`
9. **The `custem` typo** is pervasive — renaming requires updating imports in 4+ files
10. **No `.env` file exists** — no Supabase credentials are configured

---

## File Inventory

| Directory | Files | Lines (approx) |
|---|---|---|
| `lib/core/` | 10 | ~480 |
| `lib/features/auth/` | 5 | ~635 |
| `lib/features/home/` | 1 | ~185 |
| `lib/features/menu/` | 1 | ~239 |
| `lib/features/cart/` | 2 | ~444 |
| `lib/features/profile/` | 2 | ~339 |
| `lib/features/search/` | 6 | ~825 |
| `lib/features/checkout/` | 4 | ~840 |
| `lib/features/main/` | 1 | ~116 |
| `lib/data/` | 10 | ~744 |
| `lib/` (root) | 2 | ~114 |
| `test/` | 1 | ~9 |
| **Total** | **~45 files** | **~4,970 lines** |
