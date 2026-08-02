# Project Status

**Generated On:** August 02, 2026
**Project Version:** 1.0.0+1
**Total Dart Files:** 83
**Total Lines of Code:** ~8,000+

---

## Overall Completion

| Metric | % |
|---|---|
| **Overall Project** | **62%** |
| UI | 85% |
| Business Logic | 55% |
| Architecture | 75% |
| Backend | 0% |
| State Management | 70% |
| Authentication | 45% |
| Navigation | 80% |
| Reusable Components | 70% |
| Testing | 2% |
| Performance | 20% |

---

## Completed Features

| # | Feature | Evidence |
|---|---------|----------|
| 1 | Flutter project structure (feature-first Clean Architecture) | `lib/core/`, `lib/data/`, `lib/features/` — all 12 feature modules exist |
| 2 | App Theme (Light + Dark) with persistence | `core/theme/app_theme.dart`, `theme_provider.dart`, `theme_storage.dart` |
| 3 | Centralized AppColors (no hardcoded colors in theme) | `core/theme/app_colors.dart` — 42 color constants |
| 4 | ScreenUtil integration (375x812 design) | `main.dart` — `ScreenUtilInit` wrapping `MaterialApp` |
| 5 | Splash screen with fade animation | `splash.dart` — 1200ms fade, auto-navigate based on session |
| 6 | Authentication UI (Auth, Login, Signup) | `features/auth/` — 3 pages, 2 widgets, full form validation |
| 7 | Fake Auth Service with SharedPreferences persistence | `data/services/fake_auth_service.dart` — signup, login, logout, profile update, remember me |
| 8 | Auth state management (Riverpod) | `data/providers/auth_provider.dart` — session restore, signup, login, logout, updateProfile |
| 9 | Home screen with product grid, covers, about section | `features/home/presentation/pages/home.dart` |
| 10 | Custom Bottom Navigation (4 tabs: Home, Menu, Cart, You) | `features/main/presentation/pages/main_screen.dart` — IndexedStack with page caching |
| 11 | Categories/Menu page with grid and shop-by list | `features/menu/presentation/pages/categories_page.dart` |
| 12 | Product Listing page (filtered by category) | `features/product/presentation/pages/product_listing_page.dart` |
| 13 | Product Detail page with qty selector and add-to-cart | `features/product/presentation/pages/product_detail_page.dart` |
| 14 | Product Grid Card widget | `features/product/presentation/widgets/product_grid_card.dart` |
| 15 | Full Search system (debounced, recent searches, suggestions, highlighted results) | `features/search/` — 1 page, 5 widgets; `data/providers/search_provider.dart` |
| 16 | Cart with CRUD operations (add, remove, increment, decrement) | `features/cart/` — 1 page, 1 widget; `data/providers/cart_provider.dart` |
| 17 | Cart persistence (in-memory via Riverpod) | `data/providers/cart_provider.dart` — `CartNotifier` |
| 18 | Product Checkout flow (single product) | `features/checkout/presentation/checkout.dart` |
| 19 | Place Order flow (cart → order with address + payment) | `features/checkout/presentation/place_order.dart` — 520 lines |
| 20 | Credit Card entry (flutter_credit_card) | `features/checkout/presentation/add_card.dart` |
| 21 | Address CRUD (add, edit, delete, set default) with persistence | `features/checkout/presentation/add_address.dart`, `features/profile/presentation/pages/addresses_page.dart` |
| 22 | Order creation and in-memory storage | `data/repositories/orders_repository.dart`, `data/providers/orders_provider.dart` |
| 23 | Order History page | `features/orders/presentation/pages/orders_page.dart` |
| 24 | Order Details page with timeline | `features/orders/presentation/pages/order_details_page.dart`, `order_timeline.dart` |
| 25 | Order status chip and timeline widgets | `features/orders/presentation/widgets/` — 4 widgets |
| 26 | Wishlist with persistence (SharedPreferences) | `data/providers/wishlist_provider.dart` — add, remove, toggle, load/save |
| 27 | Wishlist page with move-to-cart | `features/wishlist/presentation/pages/wishlist_page.dart` |
| 28 | Profile page with user info, menu items, counts | `features/profile/presentation/pages/profile_page.dart` |
| 29 | Edit Profile page (name, phone, DOB, gender, country, avatar) | `features/profile/presentation/pages/edit_profile_page.dart` — 374 lines |
| 30 | Edit Profile provider with change tracking and validation | `features/profile/presentation/providers/edit_profile_provider.dart` |
| 31 | Address management page (add/edit/delete/set default) | `features/profile/presentation/pages/addresses_page.dart` |
| 32 | Settings page (theme, notifications, privacy, support, about, logout) | `features/settings/presentation/pages/settings_page.dart` |
| 33 | Theme toggle (Light/Dark/System) with persistence | `features/settings/` — `SegmentedButton` in settings |
| 34 | Shared widgets: Header, FavoriteButton, CustemTextField, CustemText, Button, CustemAppbar, CardWidget | `core/widgets/` — 7 files |
| 35 | Auth widgets: CustomAuthTextField, CustomAuthButton | `features/auth/presentation/widgets/` — 2 files |
| 36 | Profile widgets: ProfileMenuItem, ProfileFormSection, ProfileAvatar, AddressCard, EmptyAddresses | `features/profile/presentation/widgets/` — 5 files |
| 37 | Settings widgets: SettingsTile, SettingsTileSwitch, SettingsSection | `features/settings/presentation/widgets/` — 3 files |
| 38 | Data models with copyWith, toJson/fromJson | `data/models/` — 9 models (User, Product, Order, OrderItem, CartItem, Address, Category, Cover, SearchResult) |
| 39 | Product repository (abstract + local implementation) | `data/repositories/product/` — 2 files |
| 40 | Search repository (abstract + local implementation) | `data/repositories/search/` — 2 files |
| 41 | Guest mode (continue without login) | `features/auth/presentation/pages/auth_page.dart` — "Continue as Guest" option |

---

## Features In Progress

| # | Feature | Progress | What Remains |
|---|---------|----------|--------------|
| 1 | **Hero animations** between product grid and detail | 0% | No Hero widgets used anywhere |
| 2 | **Skeleton loaders** for data-driven screens | 0% | All screens show content or empty state only |
| 3 | **Cart badge** on bottom nav | 0% | Bottom nav items have no badge counters |
| 4 | **Wishlist badge** on profile/bottom nav | 0% | Wishlist count not displayed on nav |
| 5 | **Filter/Sort** in product listing | 0% | No filter or sort UI in ProductListingPage |
| 6 | **Forgot Password** flow | 0% | "Forgot Password?" text shown but not wired |
| 7 | **Image caching** (cached_network_image) | 0% | All images are local assets via `Image.asset` |
| 8 | **Haptic feedback** on actions | 0% | No HapticFeedback usage anywhere |
| 9 | **Change password** in settings/profile | 0% | Not implemented |
| 10 | **Delete account** in settings/profile | 0% | Not implemented |

---

## Remaining Features (Sorted by Priority)

### P0 — Critical for MVP

| # | Feature | Why |
|---|---------|-----|
| 1 | Replace FakeAuthService with real backend | Core auth is mock-only |
| 2 | Supabase integration (or any real backend) | No real data persistence |
| 3 | Cart persistence across sessions | Cart is in-memory only (lost on app restart) |
| 4 | Orders persistence across sessions | Orders are in-memory only |
| 5 | Real product images (not just 6 assets reused) | Products share duplicate images |

### P1 — High Priority

| # | Feature | Why |
|---|---------|-----|
| 6 | Cart badge on bottom nav | No visual indicator of cart items |
| 7 | Wishlist badge on profile | No visual indicator of wishlist count |
| 8 | Forgot Password flow | UI exists but no functionality |
| 9 | Change Password functionality | Not implemented |
| 10 | Delete Account functionality | Not implemented |
| 11 | Product filter/sort in listing page | Missing from category browsing |
| 12 | Skeleton loaders for loading states | No loading indicators on data screens |

### P2 — Medium Priority

| # | Feature | Why |
|---|---------|-----|
| 13 | Hero animations between grid and detail | No shared element transitions |
| 14 | Haptic feedback on key actions | Not implemented |
| 15 | Image caching (cached_network_image) | All images are local assets |
| 16 | Navigation persistence (tab/scroll state) | IndexedStack preserves tabs but scroll position lost |
| 17 | Promo code functionality | UI exists but no backend logic |
| 18 | Push notification integration | Settings toggle exists but no implementation |
| 19 | Language selection | Settings shows "coming soon" |
| 20 | Privacy Policy page | Settings shows "coming soon" |

### P3 — Low Priority

| # | Feature | Why |
|---|---------|-----|
| 21 | Unit tests for providers/repositories | Only 1 smoke test exists |
| 22 | Widget tests for shared components | None exist |
| 23 | E2E tests | None exist |
| 24 | Performance profiling (DevTools) | Not done |
| 25 | Accessibility pass (contrast, tap targets) | Not done |
| 26 | Signed release builds | Not done |
| 27 | README polish | Only default Flutter README |
| 28 | Play Store listing assets | Not started |

---

## Current Bugs

### 🔴 Critical

| # | Bug | File | Root Cause | Suggested Fix |
|---|-----|------|------------|---------------|
| 1 | **Cart lost on app restart** | `data/providers/cart_provider.dart` | `CartNotifier` state is in-memory only; no SharedPreferences persistence like wishlist/addresses | Add `_load()` and `_save()` methods using SharedPreferences, similar to `wishlist_provider.dart` |
| 2 | **Orders lost on app restart** | `data/repositories/orders_repository.dart` | `OrdersRepository` stores orders in a private `List<OrderModel>` in memory | Persist orders to SharedPreferences or a database |
| 3 | **Checkout disabled when address exists but no card** | `features/checkout/presentation/place_order.dart:388` | The `Button`'s `onTap` is always `_placeOrder()` + `_showSuccessDialog()` — no validation that card or address is actually provided | Add validation before placing order; show error if card or address is missing |

### 🟠 High

| # | Bug | File | Root Cause | Suggested Fix |
|---|-----|------|------------|---------------|
| 4 | **Home shows ALL products, not featured** | `features/home/presentation/pages/home.dart:15` | Uses `allProductsProvider` instead of `featuredProductsProvider` | Change to `ref.watch(featuredProductsProvider)` |
| 5 | **Product image reused across different products** | `data/models/product_model.dart` | Products p1, p7, p8, p12, p14, p17 share `product1.png`; p2, p9 share `product2.png`; p6, p10, p11, p16, p18 share `product6.png` | Add more unique product images or use placeholder variation |
| 6 | **`DropdownButtonFormField` uses `initialValue` (invalid)** | `features/profile/presentation/widgets/profile_form_section.dart:177` | `DropdownButtonFormField` does not have an `initialValue` parameter; this is `DropdownButton`'s API. Should use `value` | Change `initialValue: value` to `value: value` |
| 7 | **Place Order always shows success dialog even without address/card** | `features/checkout/presentation/place_order.dart:443` | `_placeOrder()` and `_showSuccessDialog()` are called unconditionally in the button's `onTap` | Guard with validation checks |
| 8 | **`_OrdersList` typed as `dynamic`** | `features/orders/presentation/pages/orders_page.dart:23` | `final dynamic orders;` loses type safety | Change to `final List<OrderModel> orders;` |

### 🟡 Medium

| # | Bug | File | Root Cause | Suggested Fix |
|---|-----|------|------------|---------------|
| 9 | **Email shown for guest users as "guest@example.com"** | `features/profile/presentation/pages/profile_page.dart:63` | Hardcoded fallback email for unauthenticated users | Show "No email" or hide the email field for guests |
| 10 | **Order IDs are timestamp-based, not unique enough** | `features/checkout/presentation/place_order.dart:290` | Two orders placed in the same second get the same ID | Use `DateTime.now().millisecondsSinceEpoch` or UUID |
| 11 | **"Add Address" button not shown in checkout when no addresses** | `features/checkout/presentation/place_order.dart:337` | The conditional `!hasAddress` block renders correctly but the `Spacer()` before the total can push content off-screen on small devices | Use `SingleChildScrollView` in the checkout body |
| 12 | **CartPage accepts `dynamic products` parameter** | `features/cart/presentation/pages/cart_page.dart:14` | `final dynamic products;` is unused and type-unsafe | Remove the parameter entirely |
| 13 | **`_CartContent` and `_CartBottomSection` accept `dynamic products`** | `features/cart/presentation/pages/cart_page.dart:37,65` | Same issue — unused dynamic parameter | Remove the parameter |
| 14 | **Missing `mounted` check after `await` in splash** | `lib/splash.dart:40` | `if (!mounted) return;` is correctly placed, but `_navigateToNext` uses `Future.delayed` which could complete after dispose | Already handled — low risk |
| 15 | **`SearchTapWidget` imports `SearchContextType` from `search_screen.dart`** | `features/search/presentation/widgets/search_tap_widget.dart:5` | Cross-feature import from a page file; should import from provider | Import `SearchContextType` from `search_provider.dart` instead |
| 16 | **Duplicate `_formatDateTime` / `_formatDate` methods** | `order_details_page.dart`, `order_card.dart`, `order_timeline.dart` | Same date formatting logic repeated 3 times | Extract to a shared utility |
| 17 | **Emoji displayed as raw Unicode** | `features/profile/presentation/widgets/empty_addresses.dart:23`, `features/profile/presentation/pages/addresses_page.dart:59` | `'\ud83d\udccd'` and `'\ud83d\uddd1\ufe0f'` — these render as emoji on most devices but are fragile | Use `Icons` or proper emoji characters |

### 🟢 Low

| # | Bug | File | Root Cause | Suggested Fix |
|---|-----|------|------------|---------------|
| 18 | **Typos in file names: "custem" instead of "custom"** | `core/widgets/custem_text.dart`, `custem_appbar.dart`, `custem_bottom.dart`, `custem_text_field.dart` | Persistent typo across all shared widgets | Rename files and update imports |
| 19 | **`ProductModel.descrp` typo** | `data/models/product_model.dart:6` | Field named `descrp` instead of `description` | Rename field to `description` and update all references |
| 20 | **`flutter_credit_card` not in `analysis_options.yaml` exclusions** | `analysis_options.yaml` | May produce warnings | Not a bug, but a code quality note |
| 21 | **Hardcoded email and phone in Home about section** | `features/home/presentation/pages/home.dart:168-169` | Personal contact info hardcoded in source | Move to constants or remove |
| 22 | **`SuggestedProductsSection` takes `List<dynamic>`** | `features/search/presentation/widgets/search_suggestions.dart:91` | Should be `List<ProductModel>` for type safety | Change parameter type |

---

## Technical Debt

### Dead Code
- `data/models/search_result_model.dart` — `SearchResultModel` class is defined but never used anywhere in the codebase
- `features/search/presentation/widgets/search_tap_widget.dart` — `SearchTapWidget` is defined but never instantiated (the `_SearchBar` in `custem_appbar.dart` directly navigates to `SearchScreen`)

### Unused Files
- `data/models/search_result_model.dart` — No references found in any file
- `features/search/presentation/widgets/search_tap_widget.dart` — Not imported or used anywhere

### Duplicate Code
- **Date formatting** — `_formatDateTime` / `_formatDate` duplicated in `order_details_page.dart`, `order_card.dart`, `order_timeline.dart` (3 copies)
- **"Added to Cart" dialog** — Nearly identical dialog code in `product_detail_page.dart` and `checkout.dart` (~60 lines each)
- **`intersperse` extension** — Defined identically in both `profile_form_section.dart` and `settings_section.dart`
- **Promo/Delivery section** — `_PromoSection` widget duplicated in `checkout.dart` and `product_detail_page.dart`
- **Category grid** — Category list hardcoded in both `categories_page.dart` and `category_model.dart`

### Refactoring Opportunities
- Extract date formatting to a shared utility (e.g., `core/utils/date_formatter.dart`)
- Extract "Added to Cart" dialog to a shared widget
- Extract `_PromoSection` to `core/widgets/`
- Move category data to a single source of truth
- Rename `custem_*` files to `custom_*`
- Rename `descrp` to `description` in `ProductModel`
- Add type annotations replacing all `dynamic` usages

### Temporary Implementations
- `FakeAuthService` — Entire auth system is mock-based; designed to be replaced with Supabase
- `OrdersRepository` — In-memory only; needs persistence layer
- `CartNotifier` — In-memory only; needs persistence layer
- All product data hardcoded in `ProductModel.products` static list

### Hardcoded Data
- 18 products hardcoded in `data/models/product_model.dart:13-206`
- 7 categories hardcoded in `data/models/category_model.dart:11-18`
- 3 cover images hardcoded in `data/models/cover_model.dart:4-8`
- Contact email and phone in `features/home/presentation/pages/home.dart:168-169`
- Design size 375x812 hardcoded in `main.dart:20`

### Mock Services
- `data/services/fake_auth_service.dart` — 160 lines of mock auth using SharedPreferences
- `data/repositories/product/local_product_repository.dart` — Returns hardcoded products
- `data/repositories/search/local_search_repository.dart` — Searches hardcoded products

### Architecture Violations
- `features/cart/presentation/pages/cart_page.dart` imports directly from `features/main/presentation/pages/main_screen.dart` (feature-to-feature dependency for navigation)
- `features/checkout/presentation/place_order.dart` imports from `features/orders/presentation/pages/orders_page.dart` (same issue)
- `features/checkout/presentation/place_order.dart` imports from `features/profile/presentation/pages/addresses_page.dart` (same issue)
- `features/wishlist/presentation/pages/wishlist_page.dart` imports from `features/main/presentation/pages/main_screen.dart` (same issue)
- No domain layer exists — all business logic lives in providers and repositories directly

### Naming Problems
- `custem_*` files — should be `custom_*`
- `ProductModel.descrp` — should be `description`
- `Button` class name in `custem_bottom.dart` — too generic, should be `PrimaryButton` or `AppButton`
- `_SearchBar` private class in `custem_appbar.dart` — could conflict with other search bar widgets
- `CustemAppbar` — should be `CustomAppBar`

---

## Architecture Review

### Overall Assessment: **Healthy with Some Violations**

The project follows a **feature-first Clean Architecture** pattern with clear separation:

```
lib/
├── core/           ← Shared: theme, router, constants, widgets
├── data/           ← Models, providers, repositories, services
└── features/       ← 12 feature modules
    └── {feature}/
        └── presentation/
            ├── pages/
            ├── widgets/
            └── providers/ (some features)
```

### Strengths
- Feature-first organization is consistently applied
- Riverpod state management is used consistently across all features
- Abstract repository interfaces with local implementations (ready for backend swap)
- Consistent widget naming and design system
- Dark/light theme support with persistence
- Responsive sizing via ScreenUtil

### Violations
1. **No domain layer** — Business logic lives directly in providers; no use cases/interactors
2. **Feature-to-feature imports** — 4+ instances of features importing directly from other features (cart→main, checkout→orders, checkout→profile, wishlist→main)
3. **No error handling abstraction** — Errors are shown via `SnackBar` directly in each page; no centralized error handling
4. **Mixed widget patterns** — Some widgets are `ConsumerWidget`, some are `StatelessWidget` even when they access Riverpod (e.g., `_OrdersList` in orders_page.dart takes `dynamic orders` instead of watching the provider)
5. **No dependency injection** — `FakeAuthService` is instantiated directly in `AuthRepository`; no DI container

---

## Tomorrow Development Plan

- [ ] 1. Fix critical bug: Add cart persistence (SharedPreferences) to `CartNotifier`
- [ ] 2. Fix critical bug: Add orders persistence to `OrdersRepository`
- [ ] 3. Fix bug #6: Change `initialValue` to `value` in `ProfileFormDropdown`
- [ ] 4. Fix bug #4: Change Home to use `featuredProductsProvider`
- [ ] 5. Fix bug #8: Type `_OrdersList.orders` as `List<OrderModel>`
- [ ] 6. Fix bug #12-13: Remove unused `dynamic products` parameters from CartPage
- [ ] 7. Fix bug #7: Add validation before placing order in `PlaceOrder`
- [ ] 8. Extract duplicate date formatting to `core/utils/date_formatter.dart`
- [ ] 9. Extract "Added to Cart" dialog to shared widget
- [ ] 10. Remove dead code: `SearchResultModel` and `SearchTapWidget`

---

## Next Milestones

### Milestone 1 — Bug Fixes & Data Persistence (Est. 2-3 days)
- Fix all critical and high-severity bugs
- Add cart persistence
- Add orders persistence
- Fix type safety issues
- Run `flutter analyze` clean

### Milestone 2 — UI Polish & Shared Components (Est. 3-5 days)
- Extract shared dialog, promo section, date formatter
- Rename `custem_*` to `custom_*`
- Add skeleton loaders for loading states
- Add cart/wishlist badges on navigation
- Add Hero animations between grid and detail

### Milestone 3 — Backend Integration (Est. 1-2 weeks)
- Replace `FakeAuthService` with real auth provider
- Replace hardcoded products with API/database
- Add real image loading with `cached_network_image`
- Implement real cart and order persistence

### Milestone 4 — Testing & Release (Est. 1 week)
- Unit tests for providers and repositories
- Widget tests for shared components
- Manual E2E testing
- Signed release builds
- README and documentation

---

## Development Notes

1. **State management decision: Riverpod** — Already chosen and consistently used across all 7 providers. No need to evaluate alternatives.
2. **All product data is local assets** — 6 product images are reused across 18 products. Real product photography will be needed for production.
3. **No `.env` file exists** — Supabase credentials will need to be added when backend integration begins.
4. **`analysis_options.yaml` uses default `flutter_lints`** — No custom lint rules configured. Consider adding stricter rules for production.
5. **Single test file** — `test/widget_test.dart` contains only a smoke test that pumps `MyApp()`. This test likely fails because it doesn't wrap with `ProviderScope`.
6. **Flutter SDK constraint is `^3.10.1`** — Very recent SDK. Ensure CI/CD environments support this version.
7. **The `flutter_credit_card` package is used for card entry** — This is a UI-only package; it does not process payments. A real payment processor will be needed.
8. **Navigation uses `Navigator.push` and `onGenerateRoute`** — The original plan mentioned `go_router` as a future dependency, but the current implementation uses imperative navigation which is working fine.
9. **`ProfileFormDropdown` uses `initialValue`** which is not a valid parameter for `DropdownButtonFormField` — This will cause a runtime error when the edit profile page is opened. This is a bug that needs immediate attention.
10. **Guest mode works** — Users can browse as guests, but cart/orders are lost when they leave since there's no persistence.
