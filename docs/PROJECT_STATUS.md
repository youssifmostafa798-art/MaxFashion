# Project Status

> **Generated:** Sat Aug 01 2026
> **Source of truth:** Codebase inspection (NOT documentation)

---

## Overall Completion

| Category | % | Notes |
|---|---|---|
| **Overall** | **~32%** | Most core screens exist and are navigable; all data is hardcoded/mock; no real backend |
| **UI** | **~55%** | 12 feature modules with pages and widgets; missing skeleton loaders, loading states, accessibility |
| **Business Logic** | **~30%** | Cart, wishlist, addresses, orders work locally; auth is fake; search partially functional |
| **Architecture** | **~55%** | Feature-first structure with core/data/features; Riverpod integrated; repository pattern started |
| **Backend** | **0%** | No Supabase, no real API, all data hardcoded in static model lists |
| **State Management** | **~45%** | Riverpod for auth, cart, search, theme, wishlist, addresses, orders; cart has no persistence |
| **Authentication** | **~25%** | Fake auth with SharedPreferences; no forgot password, no email verification |
| **Navigation** | **~60%** | Named routes + bottom nav with IndexedStack; some routes missing (orders, checkout, addresses) |
| **Reusable Components** | **~50%** | 7 core widgets + feature-specific widgets; some missing (loading, error, skeleton) |
| **Testing** | **~2%** | Only 1 smoke test exists |
| **Performance** | **~30%** | IndexedStack caching; no skeleton loaders, no image caching, no profiling done |

---

## Completed Features

| # | Feature | Evidence |
|---|---------|----------|
| 1 | Flutter project scaffolded with feature-first architecture | `lib/core/`, `lib/features/`, `lib/data/` — 12 feature modules |
| 2 | Splash screen with fade animation and auto-login routing | `lib/splash.dart` — checks `fake_auth_remember_me` + `fake_auth_is_logged_in` via SharedPreferences |
| 3 | Auth entry page (Create Account / Continue as Guest) | `lib/features/auth/presentation/pages/auth_page.dart` |
| 4 | Login page with form validation and Riverpod auth state | `lib/features/auth/presentation/pages/login_page.dart` — email regex, password min 6 |
| 5 | Signup page with Egyptian phone validation | `lib/features/auth/presentation/pages/signup_page.dart` — regex `^01[0-2,5]\d{8}$` |
| 6 | Fake auth service with SharedPreferences persistence | `lib/data/services/fake_auth_service.dart` — stores users, current user, remember me |
| 7 | Auth repository + auth state provider (Riverpod) | `lib/data/providers/auth_provider.dart` — `authStateProvider`, `AuthNotifier` |
| 8 | App theme (light + dark + system) with persistence | `lib/core/theme/app_theme.dart`, `theme_provider.dart`, `theme_storage.dart` |
| 9 | Centralized AppColors palette | `lib/core/theme/app_colors.dart` — primary, greys, surfaces, accent |
| 10 | flutter_screenutil integrated | `main.dart` — `ScreenUtilInit` with design size 375x812 |
| 11 | Named route navigation with AppRouter | `lib/core/router/app_router.dart` — 7 routes (splash, auth, login, signup, main, search, wishlist) |
| 12 | Main screen with BottomNavigationBar + IndexedStack | `lib/features/main/presentation/pages/main_screen.dart` — 4 tabs, lazy page caching |
| 13 | Home screen with covers, product grid, footer | `lib/features/home/presentation/pages/home.dart` — hardcoded 6 products, 3 covers |
| 14 | Categories/Menu page with grid and "Shop By" list | `lib/features/menu/presentation/pages/categories_page.dart` — 7 categories, 4 shop-by items |
| 15 | Search screen with animated transitions | `lib/features/search/presentation/pages/search_screen.dart` — debounced, context-aware |
| 16 | Search suggestions (recent, suggested, popular) | `lib/features/search/presentation/widgets/search_suggestions.dart` — 3 sections |
| 17 | Search results with highlighted text | `lib/features/search/presentation/widgets/search_results_list.dart`, `highlighted_text.dart` |
| 18 | Search state management with debounce (Riverpod) | `lib/data/providers/search_provider.dart` — `SearchNotifier`, 250ms debounce |
| 19 | Cart page with items, quantity controls, empty state | `lib/features/cart/presentation/pages/cart_page.dart` — subtotal/delivery/total |
| 20 | Cart state management (add, remove, increment, decrement, clear) | `lib/data/providers/cart_provider.dart` — `CartNotifier`, duplicate merge |
| 21 | Cart subtotal/total derived providers | `lib/data/providers/cart_provider.dart` — `cartSubtotalProvider`, `cartTotalProvider` |
| 22 | Checkout/product detail page with add-to-cart dialog | `lib/features/checkout/presentation/checkout.dart` — qty selector, promo (UI only), add-to-cart dialog |
| 23 | Place order screen with address, payment, method, success dialog | `lib/features/checkout/presentation/place_order.dart` — 520 lines, creates OrderModel |
| 24 | Add/edit address form with label selection | `lib/features/checkout/presentation/add_address.dart` — Home/Work/Other labels, 6 fields |
| 25 | Add credit card form (flutter_credit_card) | `lib/features/checkout/presentation/add_card.dart` — card preview + form |
| 26 | Profile page with header, menu, badge counts | `lib/features/profile/presentation/pages/profile_page.dart` — avatar, name, email, phone, member since |
| 27 | Profile menu navigation (My Orders, Wishlist, Addresses, Settings) | `lib/features/profile/presentation/pages/profile_page.dart` — all wired to screens |
| 28 | Settings page with theme selector, sections, logout | `lib/features/settings/presentation/pages/settings_page.dart` — segmented theme button |
| 29 | Wishlist page with items, move-to-cart, remove | `lib/features/wishlist/presentation/pages/wishlist_page.dart` — empty state + item list |
| 30 | Wishlist state management with persistence | `lib/data/providers/wishlist_provider.dart` — SharedPreferences, toggle/add/remove |
| 31 | Orders page with order cards, empty state | `lib/features/orders/presentation/pages/orders_page.dart` — lists orders, empty state |
| 32 | Order detail page with timeline, status chip | `lib/features/orders/presentation/pages/order_details_page.dart` — full detail view |
| 33 | Orders state management (in-memory) | `lib/data/providers/orders_provider.dart` — `OrdersNotifier`, in-memory list |
| 34 | Address management page with add/edit/delete/set-default | `lib/features/profile/presentation/pages/addresses_page.dart` — full CRUD |
| 35 | Address state management with persistence | `lib/data/providers/address_provider.dart` — SharedPreferences, default handling |
| 36 | Product model with 6 hardcoded products | `lib/data/models/product_model.dart` — id, name, image, price, category, collection, keywords |
| 37 | Category model with 7 categories | `lib/data/models/category_model.dart` — Men, Women, Kids, Shoes, Accessories, Brands, Sale |
| 38 | Cover model with 3 covers | `lib/data/models/cover_model.dart` — Black, HAEKIM, White collections |
| 39 | Order/OrderItem/CartItem/Address/User/SearchResult models | `lib/data/models/` — all with copyWith, toJson/fromJson where needed |
| 40 | Reusable core widgets (7 files) | `lib/core/widgets/` — CustemText, CustemTextField, Button, CustemAppbar, Header, FavoriteButton, CardWidget |
| 41 | Auth-specific widgets | `lib/features/auth/presentation/widgets/` — CustomAuthButton, CustomAuthTextField |
| 42 | Order widgets (4 files) | `lib/features/orders/presentation/widgets/` — OrderCard, OrderStatusChip, OrderTimeline, EmptyOrdersWidget |
| 43 | Search widgets (5 files) | `lib/features/search/presentation/widgets/` — TextField, TapWidget, Suggestions, ResultsList, HighlightedText |
| 44 | Profile widgets (3 files) | `lib/features/profile/presentation/widgets/` — ProfileMenuItem, AddressCard, EmptyAddresses |
| 45 | Settings widgets (2 files) | `lib/features/settings/presentation/widgets/` — SettingsSection, SettingsTile |
| 46 | CartItemCard widget | `lib/features/cart/presentation/widgets/cart_item_card.dart` — image, qty controls, color/size display |
| 47 | WishlistItemCard widget | `lib/features/wishlist/presentation/widgets/wishlist_item_card.dart` — image, name, move-to-cart, remove |
| 48 | Search repository abstraction + local implementation | `lib/data/repositories/search/` — abstract SearchRepository, LocalSearchRepository |
| 49 | Auth repository | `lib/data/repositories/auth_repository.dart` — wraps FakeAuthService |
| 50 | Orders repository (in-memory) | `lib/data/repositories/orders_repository.dart` — CRUD operations |
| 51 | App constants with asset paths | `lib/core/constants/app_constants.dart` — font, logo, SVG paths |

---

## Features In Progress

| # | Feature | Status | What's Done | What's Missing |
|---|---------|--------|-------------|----------------|
| 1 | **Home Screen** | ~65% | Cover images, product grid with favorites, horizontal covers, footer | No loading/error states, no carousel, no category rail, hardcoded data only |
| 2 | **Search** | ~55% | UI, animated transitions, suggestions, results, highlighted text, debounce | Recent searches broken (persistence no-ops), no filters, no sort, simple contains-only |
| 3 | **Checkout Flow** | ~65% | Product detail, add-to-cart, address/card forms, place order with success dialog | No real order submission backend, hardcoded payment ID, promo code non-functional |
| 4 | **Profile** | ~55% | Header with avatar, menu with navigation, badge counts, theme toggle, logout | Edit Profile `onTap` is empty no-op, no profile editing UI |
| 5 | **Categories/Menu** | ~40% | Category grid display, shop-by list display | Category tap doesn't filter or navigate to product list, shop-by items non-functional |
| 6 | **Auth** | ~35% | Login, signup, fake persistence, session restore | No forgot password, no email verification, passwords stored in plaintext |
| 7 | **Orders** | ~45% | Order list, order detail, timeline, status chips, empty state | All in-memory (lost on restart), no real backend integration |
| 8 | **Wishlist** | ~50% | Wishlist page, items, move-to-cart, remove, persistence | Loads only from hardcoded products, no backend sync |
| 9 | **Addresses** | ~60% | Add/edit/delete addresses, set default, persistence | No backend sync, checkout address display could be improved |

---

## Remaining Features

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 1 | Real Supabase backend integration | Critical | Zero backend — all data hardcoded in static lists |
| 2 | Real authentication (Supabase email/password) | Critical | Currently using FakeAuthService with plaintext passwords |
| 3 | Forgot Password flow | High | Not started |
| 4 | Email Verification flow | High | Not started |
| 5 | Cart persistence (SharedPreferences/Supabase) | High | Cart resets on app restart — Riverpod in-memory only |
| 6 | Product detail page (dedicated, not checkout) | High | No standalone product detail — `Checkout` page serves dual purpose |
| 7 | Product listing/category page with filtering | High | Categories page exists but tapping doesn't show filtered products |
| 8 | Search filters (category, brand, price, size) | Medium | Not started |
| 9 | Search sort options (price, newest) | Medium | Not started |
| 10 | Profile editing (name, avatar upload, contact info) | Medium | Edit Profile menu exists but `onTap` is empty |
| 11 | Loading/skeleton states for all screens | Medium | None exist — no shimmer, no progress indicators |
| 12 | Error states for all screens | Medium | None exist |
| 13 | Empty states improvements (orders has one, wishlist has one) | Medium | Search, categories need empty states |
| 14 | Hero animations between screens | Low | Not started |
| 15 | Accessibility pass (contrast, tap targets) | Low | Not started |
| 16 | Unit tests | Medium | Only 1 smoke test exists |
| 17 | Widget tests | Medium | None |
| 18 | Performance optimization | Low | No profiling, no image caching strategy |
| 19 | Signed APK/AAB builds | Low | Not started |
| 20 | Promo code functionality | Low | UI exists in checkout but non-functional |
| 21 | Language selection | Low | UI placeholder in settings shows snackbar |
| 22 | Push notifications | Low | Toggle exists but no implementation |
| 23 | Privacy Policy / Terms pages | Low | Snackbars show "coming soon" |
| 24 | About App dialog | Low | Basic about dialog exists |

---

## Current Bugs

### 🔴 Critical

| # | File | Issue | Root Cause | Suggested Fix |
|---|------|-------|------------|---------------|
| 1 | `lib/data/services/fake_auth_service.dart` | **Passwords stored in plaintext** in SharedPreferences | No hashing implemented | Hash passwords with `dart:crypto` sha256 before storing |
| 2 | `lib/data/providers/search_provider.dart` | **Recent searches not persisting** — `_loadRecentSearches()` and `_saveRecentSearches()` are async but called from sync context without awaiting | Async init in constructor, `_saveRecentSearches` uses `async` without `await` on `setState` | Make `_load` properly initialize state, ensure `_save` completes before state updates |

### 🟠 High

| # | File | Issue | Root Cause | Suggested Fix |
|---|------|-------|------------|---------------|
| 3 | `lib/features/checkout/presentation/add_card.dart` | **Trailing space in map key `'date '`** — place_order.dart reads `savedCard['date']` (no space) | Typo in key name: `'date '` vs `'date'` | Change `'date '` to `'date'` in add_card.dart |
| 4 | `lib/features/home/presentation/pages/home.dart:98` | **Hardcoded accent color `Color(0xffDD8560)`** | Not in AppColors | Add `static const Color accentWarm = Color(0xffDD8560);` to AppColors and use it |
| 5 | `lib/data/services/fake_auth_service.dart` | **Mutation bug: `match.first..remove('password')` modifies stored user data** | Cascade operator mutates the in-memory map | Create a copy: `Map<String, dynamic>.from(match.first)..remove('password')` |
| 6 | `lib/features/search/presentation/widgets/search_suggestions.dart` | **Suggested product tap navigates to blank Scaffold** | `onTap` routes to `Scaffold()` with no content | Route to `Checkout(products: product)` instead |

### 🟡 Medium

| # | File | Issue | Root Cause | Suggested Fix |
|---|------|-------|------------|---------------|
| 7 | `lib/data/models/product_model.dart:28` | **All 6 products have identical description** — `"reversible angora cardigan"` | Copy-paste error during development | Write unique descriptions per product |
| 8 | `lib/data/models/product_model.dart:6` | **Field misspelled as `descrp`** | Typo carried throughout codebase | Rename to `description`, update all references (8+ files) |
| 9 | `lib/features/search/presentation/widgets/highlighted_text.dart` | **Highlight color same as text color** — `highlightColor` defaults to `colorScheme.onSurface` | Default parameter matches text color | Use `colorScheme.primary` or a distinct highlight color |
| 10 | `lib/features/checkout/presentation/place_order.dart` | **Success dialog generates a NEW order ID** — `_generateOrderId()` called again for display, different from the order actually placed | `_showSuccessDialog()` calls `_generateOrderId()` independently | Capture order ID before placing order, pass to dialog |
| 11 | `lib/data/providers/cart_provider.dart:72-74` | **`cartTotalProvider` is redundant** — identical to `cartSubtotalProvider` | No tax/shipping calculation | Add tax/shipping logic or remove redundant provider |
| 12 | `lib/features/profile/presentation/pages/profile_page.dart` | **Edit Profile `onTap` is empty** | Not implemented yet | Build edit profile page or show "coming soon" snackbar |
| 13 | `lib/features/checkout/presentation/place_order.dart` | **Shipping method hardcoded to "Pickup at store"** | Not implemented | Add shipping method selection |

### 🟢 Low

| # | File | Issue | Root Cause | Suggested Fix |
|---|------|-------|------------|---------------|
| 14 | Multiple files | **Pervasive typo: `custem`** instead of `custom` in 4 filenames and class names | Original naming error | Rename all `custem_*` to `custom_*` across project |
| 15 | `lib/data/models/cart_item_model.dart:42` | **`generateProductId` static method never called anywhere** | Dead code | Remove or use it consistently |
| 16 | `lib/data/providers/search_provider.dart:15` | **`searchSourceProvider` always returns `null`** | Placeholder never connected | Remove or implement source-specific search |
| 17 | `lib/features/menu/presentation/pages/categories_page.dart` | **Category tap doesn't filter or navigate to product list** | Not implemented | Wire category tap to filtered product listing |
| 18 | `lib/features/home/presentation/pages/home.dart:186-187` | **Footer shows hardcoded "openui.design" contact info** | Template placeholder | Replace with real business info or remove |
| 19 | `lib/data/models/product_model.dart` | **Products use `'assets/product/productN.png'` paths that may not match actual asset files** | Asset naming convention | Verify all asset paths exist |
| 20 | `lib/features/checkout/presentation/checkout.dart` | **Promo code section is UI only — non-functional** | Not implemented | Add promo code validation logic or remove section |

---

## Technical Debt

### Dead Code
- `lib/data/providers/cart_provider.dart` — `cartTotalProvider` (identical to `cartSubtotalProvider`)
- `lib/data/models/cart_item_model.dart` — `generateProductId()` static method (never called)
- `lib/data/providers/search_provider.dart` — `searchSourceProvider` (always returns `null`)
- `lib/features/checkout/presentation/add_address.dart` — controllers created but some not attached to UI fields

### Unused Files
- `lib/features/product/presentation/` — empty directory (placeholder)
- `lib/features/product/widgets/` — empty directory (placeholder)
- `lib/features/home/presentation/widgets/` — empty directory
- `lib/features/main/presentation/widgets/` — empty directory

### Duplicate Code
- Hardcoded `Color(0xffDD8560)` in `home.dart:98`, `search_results_list.dart`, `card_widget.dart` — should be in AppColors
- Font family `'Tenor_Sans'` hardcoded in widget files instead of using `AppConstants.fontFamily`
- `SizedBox(height: X.h)` pattern repeated everywhere instead of using `Gap` consistently

### Refactoring Opportunities
- Rename all `custem_*` files/classes to `custom_*` (4+ files, affects imports)
- Extract accent color `Color(0xffDD8560)` to `AppColors.accentWarm`
- Replace `dynamic` types with proper models (e.g., `products` parameter in CartPage/CartContent)
- Consolidate form validation — some forms validate, some don't
- Unify search context logic — `SearchContextType` enum exists but provider always returns `global`
- Replace `descrp` field with `description` across ProductModel and all references

### Temporary Implementations
- `FakeAuthService` — entire auth system is a mock; passwords in plaintext
- All product/category/cover data hardcoded in static model lists
- Place order generates fake payment IDs from timestamps
- Orders stored in-memory (lost on app restart)
- Cart stored in-memory (lost on app restart)
- Notifications toggle is purely cosmetic

### Hardcoded Data
- `lib/data/models/product_model.dart` — 6 products with all fields
- `lib/data/models/category_model.dart` — 7 categories
- `lib/data/models/cover_model.dart` — 3 covers
- `lib/features/home/presentation/pages/home.dart` — footer text, copyright, contact info
- `lib/features/menu/presentation/pages/categories_page.dart` — all categories and shop-by items
- `lib/features/checkout/presentation/place_order.dart` — shipping method "Pickup at store"
- `lib/features/settings/presentation/pages/settings_page.dart` — version "1.0.0"

### Mock Services
- `lib/data/services/fake_auth_service.dart` — the only service; no real backend exists
- `lib/data/repositories/orders_repository.dart` — in-memory list, no persistence

### Architecture Violations
- `Checkout` page (`checkout.dart`) serves as both product detail AND checkout entry — violates single responsibility
- Some feature files import other features directly (e.g., `cart_page.dart` imports `PlaceOrder` from checkout)
- No domain layer — models contain business logic (e.g., `AddressModel.generateId()`, `OrderItemModel.fromCartItem()`)
- No use cases / interactors — business logic lives in providers and pages directly

### Naming Problems
- `custem_*` typo in 4 filenames: `custem_appbar.dart`, `custem_bottom.dart`, `custem_text.dart`, `custem_text_field.dart`
- `descrp` typo in `ProductModel` (should be `description`)
- `CustemAppbar`, `CustemText`, `CustemTextField`, `Button` (generic name for a specific widget)
- `_formkey` in add_address.dart (should be `_formKey` per Dart conventions)
- `isSvgg` parameter name in Button widget (unclear abbreviation)

---

## Architecture Review

### Current Architecture Health: **Fair**

**Strengths:**
- Feature-first folder structure is clean and scalable
- Riverpod integration is consistent across all features
- Data layer separation (models/providers/repositories/services) is well-defined
- Reusable widgets extracted to `core/widgets/`
- Theme system is properly implemented with persistence
- Navigation uses named routes with a centralized router

**Violations & Concerns:**
1. **No domain layer** — Business logic lives in providers and pages instead of dedicated use cases
2. **No use cases / interactors** — Direct provider-to-repository calls without business logic abstraction
3. **Cross-feature imports** — Cart page imports PlaceOrder (checkout feature), Profile imports Orders/Wishlist/Settings
4. **Mixed responsibilities** — Checkout page serves as product detail + checkout + cart entry
5. **No error handling abstraction** — Each page handles errors differently (snackbars, nothing, dialogs)
6. **No dependency injection beyond Riverpod** — Services are created directly in some places
7. **Static model data** — Products, categories, covers are static lists on the model classes themselves

**Recommendations:**
- Add a `domain/` layer with use cases per feature
- Define clear feature boundaries (no cross-feature imports)
- Create an error handling abstraction (e.g., `ErrorHandler` service)
- Move static data to a dedicated data source class

---

## Tomorrow Development Plan

### Priority 1 — Fix Critical Bugs (Day 1)
- [ ] Fix password plaintext storage in `fake_auth_service.dart` — hash with sha256
- [ ] Fix recent searches persistence in `search_provider.dart`
- [ ] Fix `'date '` trailing space key in `add_card.dart`
- [ ] Fix mutation bug in `fake_auth_service.dart` (`match.first..remove`)
- [ ] Fix suggested product tap navigating to blank Scaffold

### Priority 2 — Fix High/Medium Bugs (Day 1-2)
- [ ] Fix hardcoded accent color `Color(0xffDD8560)` — extract to AppColors
- [ ] Fix product model `descrp` typo → `description`
- [ ] Fix duplicate product descriptions (all 6 say "reversible angora cardigan")
- [ ] Fix order ID mismatch in success dialog
- [ ] Fix highlight color being invisible in search results
- [ ] Make Edit Profile `onTap` show "coming soon" or build basic editing

### Priority 3 — Code Quality (Day 2)
- [ ] Rename `custem_*` to `custom_*` across all files and imports
- [ ] Replace `dynamic` types with proper models in CartPage
- [ ] Remove dead code (unused `generateProductId`, redundant `cartTotalProvider`)
- [ ] Extract hardcoded strings to constants

### Priority 4 — Complete Missing Functionality (Day 2-3)
- [ ] Wire category tap to filtered product listing
- [ ] Add basic product detail page (or rename Checkout to ProductDetail)
- [ ] Add loading states to search and cart
- [ ] Add empty state for categories page

### Priority 5 — Preparation for Backend (Day 3)
- [ ] Create `.env` file structure for Supabase credentials
- [ ] Plan Supabase schema (profiles, products, categories, orders, addresses)
- [ ] Identify which hardcoded data maps to which database tables
- [ ] Review and plan RLS policies

---

## Next Milestones

### Milestone 1 — Bug Fixes & Code Quality
> All critical/high bugs fixed, code renamed, dead code removed, placeholder pages exist

**Scope:**
- Fix all critical and high severity bugs
- Rename `custem_*` to `custom_*`
- Extract hardcoded colors to AppColors
- Fix `descrp` typo across codebase
- Remove dead code
- Add "coming soon" placeholders for empty `onTap` handlers
- Verify all asset paths exist

**Exit Criteria:** `flutter analyze` passes with zero errors, no critical bugs

---

### Milestone 2 — UI Completion
> All core screens exist and are visually complete with proper states

**Scope:**
- Add loading/skeleton states to Home, Search, Cart
- Add error states to all data-driven screens
- Improve empty states across all screens
- Build dedicated Product Detail page (separate from Checkout)
- Build Product Listing page (accessible from Categories)
- Polish all existing UI with consistent spacing

**Exit Criteria:** Every feature module has complete UI for all user flows

---

### Milestone 3 — Backend Integration
> Supabase connected, real auth, real data

**Scope:**
- Set up Supabase project and initialize client
- Replace FakeAuthService with real Supabase auth
- Create full database schema (profiles, products, categories, orders, order_items, addresses, favorites)
- Add RLS policies per table
- Wire Home/Categories to live product data
- Implement real search with Supabase ILIKE/full-text
- Add cart persistence
- Add wishlist persistence per user

**Exit Criteria:** App works end-to-end against real Supabase backend

---

### Milestone 4 — Feature Completion & Polish
> All features fully functional, tested, ready for release

**Scope:**
- Implement profile editing (name, avatar)
- Implement forgot password flow
- Implement email verification
- Add product filters and sort
- Add hero animations
- Add accessibility support
- Write unit tests for cart/checkout/auth
- Write widget tests for core components
- Performance optimization
- Build signed APK/AAB

**Exit Criteria:** App is feature-complete, tested, and ready for Play Store submission

---

## Development Notes

### Architecture Decisions (Already Made)
- **State management:** Riverpod (chosen and fully integrated — NOT "TBD")
- **Navigation:** Named routes with `onGenerateRoute` (not go_router)
- **Auth:** FakeAuthService with SharedPreferences (temporary — replace with Supabase)
- **Backend:** No Supabase yet — all data hardcoded
- **Responsive:** flutter_screenutil (design size 375x812)
- **Theme:** Light/Dark/System with SharedPreferences persistence

### Code Conventions
- Feature-first folder structure: `features/<feature>/presentation/pages|widgets/`
- Data layer: `data/models/`, `data/providers/`, `data/repositories/`, `data/services/`
- Core: `core/theme/`, `core/router/`, `core/widgets/`, `core/constants/`
- Uses `.w`, `.h`, `.sp`, `.r` suffixes from flutter_screenutil
- Widget types: `ConsumerWidget` / `ConsumerStatefulWidget` for Riverpod
- Custom font: Tenor Sans

### Critical Warnings for Future Sessions
1. **Do NOT trust `AI_PROJECT_CONTEXT.md`** — it says state management is "TBD" and wishlist/orders don't exist. Both are wrong. Riverpod is fully integrated. Wishlist and orders pages exist and function.
2. **Cart has NO persistence** — it's a Riverpod `StateNotifier` that resets on app restart
3. **Orders have NO persistence** — stored in an in-memory `OrdersRepository` list
4. **Search recent searches are partially broken** — async init in constructor, persistence may not work reliably
5. **The `descrp` field in ProductModel** should be `description` (typo carried throughout)
6. **The `'date '` trailing space bug** in `add_card.dart` causes place_order to not read expiry date correctly
7. **Edit Profile is the only non-functional menu item** — all others (My Orders, Wishlist, Addresses, Settings) navigate correctly
8. **There is only 1 test** — a smoke test in `test/widget_test.dart`
9. **The `custem` typo** is in 4 filenames — renaming requires updating all imports
10. **All product descriptions are identical** — copy-paste error ("reversible angora cardigan")
11. **Checkout page serves dual purpose** — product detail AND checkout entry point
12. **No `.env` file exists** — no Supabase credentials are configured

---

## File Inventory

| Directory | Files | Lines (approx) |
|---|---|---|
| `lib/core/` (constants, theme, router, widgets) | 10 | ~480 |
| `lib/features/auth/` | 5 | ~635 |
| `lib/features/home/` | 1 | ~195 |
| `lib/features/menu/` | 1 | ~239 |
| `lib/features/cart/` | 2 | ~433 |
| `lib/features/checkout/` | 4 | ~1,052 |
| `lib/features/orders/` | 5 | ~579 |
| `lib/features/wishlist/` | 2 | ~269 |
| `lib/features/profile/` | 4 | ~674 |
| `lib/features/search/` | 6 | ~835 |
| `lib/features/settings/` | 3 | ~419 |
| `lib/features/main/` | 1 | ~116 |
| `lib/features/product/` | 0 (empty) | 0 |
| `lib/data/` (models, providers, repositories, services) | 13 | ~880 |
| `lib/` (root: main.dart, splash.dart) | 2 | ~114 |
| `test/` | 1 | ~9 |
| **Total** | **~60 files** | **~~6,929 lines** |
