# PROJECT_STATUS.md — MaxFashion E-Commerce App

> Generated: August 04, 2026

---

## 1. Project Overview

| Field | Value |
|-------|-------|
| App Name | MaxFashion (`max`) |
| Purpose | Fashion e-commerce app — browse products, manage cart, checkout, track orders |
| Target Platform(s) | Android, iOS (mobile-first, design size 375x812) |
| Current Version | `1.0.0+1` |
| Build Status | Not determined (no CI config found) |

---

## 2. Tech Stack

| Component | Details |
|-----------|---------|
| Flutter SDK | `^3.10.1` (env constraint) |
| Dart SDK | `^3.10.1` |
| State Management | `flutter_riverpod: ^2.6.1` |
| Backend | `supabase_flutter: ^2.9.1` |
| Responsive Design | `flutter_screenutil: ^5.9.3` (design size 375x812) |
| Local Storage | `shared_preferences: ^2.2.2` |
| Image Picker | `image_picker: ^1.1.2` |
| SVG Rendering | `flutter_svg: ^2.2.3` |
| Icons | `ionicons: ^0.2.2` |
| Layout Utility | `flutter_gap: ^1.2.0` |
| Credit Card UI | `flutter_credit_card: ^4.1.0` |
| Dev: Linting | `flutter_lints: ^6.0.0` |
| Dev: Launcher Icons | `flutter_launcher_icons: ^0.14.4` |

**Supabase Services Integrated:**
- Auth (GoTrue) — `signUp`, `signInWithPassword`, `signOut`, `onAuthStateChange`, `currentSession`/`currentUser`
- Database — `profiles` table via `.from('profiles').select/insert/update`
- Storage — Not integrated yet
- Realtime — Not integrated yet

**Riverpod Providers Used:**
- `StateNotifierProvider` — `authStateProvider`, `cartProvider`, `wishlistProvider`, `ordersProvider`, `addressProvider`, `paymentCardProvider`, `searchProvider`, `themeProvider`, `editProfileProvider`
- `StateProvider` — `searchQueryProvider`
- `Provider` — `productRepositoryProvider`, `allProductsProvider`, `featuredProductsProvider`, `categoryProductsProvider`, `productByIdProvider`, `searchRepositoryProvider`, `searchContextProvider`, `searchSourceProvider`, `supabaseClientProvider`, `authRepositoryProvider`, `ordersRepositoryProvider`, `cartSubtotalProvider`, `cartTotalProvider`, `wishlistCountProvider`, `ordersCountProvider`, `defaultAddressProvider`, `addressCountProvider`, `defaultPaymentCardProvider`, `paymentCardCountProvider`, `highlightedQueryProvider`
- `Provider.family` — `categoryProductsProvider`, `productByIdProvider`

---

## 3. Architecture

**Clean Architecture:** Loosely followed. The `features/` directory uses a `data/domain/presentation` layer split within the `auth` feature. Other features (`cart`, `checkout`, `home`, etc.) only have `presentation/` layers. The top-level `data/` directory contains models, providers, repositories, and services shared across features. This is a **hybrid** approach — not strictly clean architecture but organized by feature.

### Folder Structure (`lib/`)

```
lib/
├── main.dart                          # App entry point, Supabase init, ProviderScope
├── splash.dart                        # Animated splash screen with auth check
├── core/
│   ├── config/
│   │   └── supabase.dart              # Supabase client getter shorthand
│   ├── constants/
│   │   └── app_constants.dart         # Font family, asset paths
│   ├── router/
│   │   └── app_router.dart            # Navigator 1.0 onGenerateRoute with slide transitions
│   ├── services/                      # Empty directory (unused)
│   ├── theme/
│   │   ├── app_colors.dart            # Centralized color palette (AppColors)
│   │   ├── app_theme.dart             # Light/dark ThemeData definitions
│   │   ├── theme_provider.dart        # ThemeMode StateNotifier + Riverpod provider
│   │   └── theme_storage.dart         # Persists theme choice via SharedPreferences
│   ├── utils/
│   │   ├── card_utils.dart            # Card brand detection, icon/name mapping
│   │   ├── date_formatter.dart        # Date formatting utility
│   │   ├── form_validators.dart       # Email/password validation
│   │   ├── haptic_utils.dart          # Haptic feedback wrapper
│   │   ├── id_generator.dart          # Timestamp-based ID generator
│   │   └── list_extensions.dart       # List extension methods
│   └── widgets/
│       ├── action_chip_widget.dart    # Reusable action chip
│       ├── badge_widget.dart          # Badge/counter widget
│       ├── confirm_delete_dialog.dart # Reusable delete confirmation dialog
│       ├── custom_appbar.dart         # Reusable app bar with search bar toggle
│       ├── custom_button.dart         # Animated press-scale button
│       ├── custom_text.dart           # Centralized text widget (Tenor Sans font)
│       ├── custom_text_field.dart     # Reusable text input field
│       ├── header.dart                # Section header widget
│       ├── press_scale.dart           # Press-to-scale gesture wrapper
│       ├── success_dialog.dart        # Reusable success dialog
│       └── skeletons/                 # Shimmer loading skeletons (7 files)
├── data/
│   ├── models/
│   │   ├── address_model.dart         # AddressModel — street, city, state, country, zip, label, isDefault
│   │   ├── cart_item_model.dart       # CartItemModel — productId, quantity, selectedSize/Color
│   │   ├── category_model.dart        # CategoryModel — static list of 7 categories
│   │   ├── cover_model.dart           # CoverModel — 3 collection covers (static)
│   │   ├── order_item_model.dart      # OrderItemModel — from CartItemModel
│   │   ├── order_model.dart           # OrderModel — orderId, items, status enum, totalPrice
│   │   ├── payment_card_model.dart    # PaymentCardModel — last4, expiry, brand, isDefault
│   │   ├── product_model.dart         # ProductModel — 18 hardcoded products (static list)
│   │   ├── search_result_model.dart   # SearchResultModel — products + query wrapper
│   │   └── user_model.dart            # UserModel — fullName, email, phone, profileImage, etc.
│   ├── providers/
│   │   ├── address_provider.dart      # AddressNotifier (SharedPreferences)
│   │   ├── auth_provider.dart         # AuthNotifier (Supabase, 414 lines — large)
│   │   ├── cart_provider.dart         # CartNotifier (SharedPreferences)
│   │   ├── orders_provider.dart       # OrdersNotifier (SharedPreferences via OrdersRepository)
│   │   ├── payment_card_provider.dart # PaymentCardNotifier (SharedPreferences)
│   │   ├── product_provider.dart      # Product providers (LocalProductRepository)
│   │   ├── search_provider.dart       # SearchNotifier with debounce (LocalSearchRepository)
│   │   └── wishlist_provider.dart     # WishlistNotifier (SharedPreferences)
│   ├── repositories/
│   │   ├── auth_repository.dart       # FakeAuthService wrapper (legacy, superseded by Supabase)
│   │   ├── orders_repository.dart     # OrdersRepository (SharedPreferences)
│   │   ├── product/
│   │   │   ├── product_repository.dart    # Abstract ProductRepository interface
│   │   │   └── local_product_repository.dart  # Local implementation (static data)
│   │   └── search/
│   │       ├── search_repository.dart     # Abstract SearchRepository interface
│   │       └── local_search_repository.dart   # Local implementation (static data)
│   └── services/
│       ├── cart_storage.dart          # SharedPreferences CRUD for cart items
│       ├── fake_auth_service.dart     # Fake auth via SharedPreferences (legacy)
│       ├── orders_storage.dart        # SharedPreferences CRUD for orders
│       └── payment_card_storage.dart  # SharedPreferences CRUD for payment cards
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── profile_model.dart        # ProfileModel — Supabase profiles table model
    │   │   └── repositories/
    │   │       └── supabase_auth_repository.dart  # Supabase AuthRepository implementation
    │   ├── domain/
    │   │   └── auth_repository_interface.dart    # Abstract AuthRepositoryInterface
    │   └── presentation/
    │       ├── pages/
    │       │   ├── auth_page.dart         # Auth landing (login/signup toggle)
    │       │   ├── login_page.dart        # Login form
    │       │   └── signup_page.dart       # Signup form with email confirmation
    │       ├── providers/
    │       │   └── auth_providers.dart    # supabaseClientProvider, authRepositoryProvider
    │       └── widgets/
    │           ├── custom_auth_button.dart    # Auth-specific button
    │           └── custom_auth_text_field.dart # Auth-specific text field
    ├── cart/
    │   └── presentation/
    │       ├── pages/
    │       │   └── cart_page.dart         # Cart UI with quantity controls
    │       └── widgets/
    │           └── cart_item_card.dart    # Individual cart item display
    ├── checkout/
    │   └── presentation/
    │       ├── pages/
    │       │   ├── add_address.dart       # Address form
    │       │   ├── add_card.dart          # Credit card form
    │       │   ├── checkout.dart          # Checkout summary page
    │       │   └── place_order.dart       # Order placement (780 lines — very large)
    │       └── widgets/
    │           ├── added_to_cart_dialog.dart  # "Added to cart" confirmation
    │           ├── card_widget.dart           # Card display widget
    │           ├── favorite_button.dart       # Heart/favorite toggle
    │           └── promo_section.dart         # Promo code section
    ├── home/
    │   └── presentation/
    │       └── pages/
    │           └── home.dart             # Home page — featured products, covers, about section
    ├── main/
    │   └── presentation/
    │       └── pages/
    │           └── main_screen.dart      # Bottom nav (Home, Categories, Search, Profile, Settings)
    ├── menu/
    │   └── presentation/
    │       └── pages/
    │           └── categories_page.dart   # Category grid + Shop By list (340 lines)
    ├── orders/
    │   └── presentation/
    │       ├── pages/
    │       │   ├── order_details_page.dart  # Single order detail view
    │       │   └── orders_page.dart         # Orders list
    │       └── widgets/
    │           ├── empty_orders_widget.dart  # Empty state for orders
    │           ├── order_card.dart           # Order summary card
    │           ├── order_status_chip.dart    # Status badge chip
    │           └── order_timeline.dart       # Order progress timeline
    ├── product/
    │   └── presentation/
    │       ├── pages/
    │       │   ├── product_detail_page.dart  # Product detail with size selection
    │       │   └── product_listing_page.dart # Category-filtered product grid
    │       └── widgets/
    │           └── product_grid_card.dart    # Product card for grid display
    ├── profile/
    │   └── presentation/
    │       ├── pages/
    │       │   ├── addresses_page.dart         # Addresses list
    │       │   ├── edit_profile_page.dart       # Edit profile form (398 lines)
    │       │   ├── payment_methods_page.dart    # Saved payment methods list
    │       │   └── profile_page.dart            # Profile view with menu items
    │       ├── providers/
    │       │   └── edit_profile_provider.dart   # EditProfileNotifier + state
    │       └── widgets/
    │           ├── address_card.dart            # Address display card
    │           ├── empty_addresses.dart         # Empty state for addresses
    │           ├── payment_card_tile.dart       # Payment card row tile
    │           ├── profile_avatar_widget.dart   # Profile image with edit overlay
    │           ├── profile_form_section.dart    # Labeled form section + fields
    │           └── profile_menu_item.dart       # Menu row item
    ├── search/
    │   └── presentation/
    │       ├── pages/
    │       │   └── search_screen.dart     # Search with debounce, recent, suggestions
    │       └── widgets/
    │           ├── highlighted_text.dart  # Text with query highlighting
    │           ├── search_results_list.dart  # Search results ListView
    │           ├── search_suggestions.dart   # Suggested products section
    │           ├── search_tap_widget.dart    # Recent search tap widget
    │           └── search_text_field.dart    # Search input field
    ├── settings/
    │   └── presentation/
    │       ├── pages/
    │       │   └── settings_page.dart     # Settings with theme toggle, logout
    │       └── widgets/
    │           ├── settings_section.dart  # Labeled settings section
    │           └── settings_tile.dart     # Settings row tile
    └── wishlist/
        └── presentation/
            ├── pages/
            │   └── wishlist_page.dart      # Wishlist grid
            └── widgets/
                └── wishlist_item_card.dart # Wishlist item card
```

### Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Files | `snake_case.dart` | `product_detail_page.dart` |
| Classes | `PascalCase` | `ProductDetailPage`, `CartItemModel` |
| Providers | `camelCase` + `Provider`/`Notifier` suffix | `cartProvider`, `AuthNotifier` |
| Feature folders | `snake_case` | `product/`, `checkout/` |
| Private classes | `_PrefixPascalCase` | `_CustomContainer` |

### Dependency Injection

Providers are used for DI. Key patterns:
- `supabaseClientProvider` wraps `Supabase.instance.client`
- `authRepositoryProvider` creates `SupabaseAuthRepository` from `supabaseClientProvider`
- `productRepositoryProvider` returns `LocalProductRepository()` (no DI override yet)
- `searchRepositoryProvider` returns `LocalSearchRepository()` (no DI override yet)
- Feature-level providers in `features/auth/presentation/providers/auth_providers.dart`
- Data-layer providers in `data/providers/` directory

---

## 4. Features — Completed

### Auth
- **Screens:** `AuthPage`, `LoginPage`, `SignupPage`
- **Logic:** Full Supabase Auth — email/password signup with email confirmation, sign-in, sign-out, session restore on splash, profile creation after signup, profile update
- **Backend:** Connected to Supabase `profiles` table (insert, select, update)
- **Status:** **Fully working** (Supabase connected, email confirmation flow handled)

### Home
- **Screens:** `Home`
- **Logic:** Featured products from local data, collection covers, about section with social links
- **Backend:** No — uses `ProductModel.products` static list
- **Status:** **UI complete, backend not connected** (products are hardcoded)

### Product Listing
- **Screens:** `ProductListingPage`
- **Logic:** Filters products by category from local data, grid display
- **Backend:** No — `LocalProductRepository.getProductsByCategory()`
- **Status:** **UI complete, backend not connected**

### Product Detail
- **Screens:** `ProductDetailPage`
- **Logic:** Product display with size selection, add-to-cart functionality
- **Backend:** No — reads from local `ProductModel`
- **Status:** **UI complete, backend not connected**

### Cart
- **Screens:** `CartPage`
- **Logic:** Add/remove items, quantity increment/decrement, subtotal/total calculation, persistence via `CartStorage` (SharedPreferences)
- **Backend:** No — local storage only
- **Status:** **Fully working locally** (no Supabase sync)

### Checkout & Place Order
- **Screens:** `Checkout`, `PlaceOrder`, `AddAddress`, `AddCard`
- **Logic:** Address selection, payment method selection (saved cards + new card), order placement, success dialog with payment ID
- **Backend:** No — orders saved to SharedPreferences via `OrdersStorage`
- **Status:** **Fully working locally** (no payment processing, no Supabase)

### Orders
- **Screens:** `OrdersPage`, `OrderDetailsPage`
- **Logic:** Order list display, order detail view with timeline, status chips
- **Backend:** No — local storage only
- **Status:** **Fully working locally** (orders persist via SharedPreferences)

### Wishlist
- **Screens:** `WishlistPage`
- **Logic:** Add/remove products to wishlist, toggle, count provider
- **Backend:** No — SharedPreferences-based ID persistence
- **Status:** **Fully working locally**

### Search
- **Screens:** `SearchScreen`
- **Logic:** Debounced search (250ms), recent searches, suggested products, context-aware search, query highlighting
- **Backend:** No — `LocalSearchRepository` with in-memory search
- **Status:** **Fully working locally**

### Profile
- **Screens:** `ProfilePage`, `EditProfilePage`
- **Logic:** Profile view, edit form with validation, image picker, save to Supabase
- **Backend:** Connected to Supabase `profiles` table via `authStateProvider`
- **Status:** **Fully working** (Supabase connected)

### Addresses
- **Screens:** `AddressesPage`, `AddAddress`
- **Logic:** Add/edit/delete addresses, set default, persistence
- **Backend:** No — SharedPreferences via `AddressNotifier`
- **Status:** **Fully working locally**

### Payment Methods
- **Screens:** `PaymentMethodsPage`, `AddCard`
- **Logic:** Add/remove payment cards, set default, card brand detection, duplicate detection
- **Backend:** No — SharedPreferences via `PaymentCardNotifier`
- **Status:** **Fully working locally**

### Settings
- **Screens:** `SettingsPage`
- **Logic:** Theme toggle (light/dark/system), logout
- **Backend:** No — local persistence via `ThemeStorage`
- **Status:** **Fully working**

### Categories / Menu
- **Screens:** `CategoriesPage`
- **Logic:** Category grid with animations, Shop By list, navigates to ProductListingPage and SearchScreen
- **Backend:** No — static category list
- **Status:** **UI complete, backend not connected**

### Theme / Dark Mode
- **Logic:** Full light/dark theme support, persists choice via SharedPreferences, animated transitions
- **Status:** **Fully working**

---

## 5. Features — In Progress / Incomplete

### TODOs / FIXMEs
**None found.** No `TODO`, `FIXME`, `HACK`, or `XXX` comments exist in any Dart files.

### Screens Not Connected to Navigation/Routing
The `AppRouter` only defines routes for: `splash`, `auth`, `login`, `signup`, `main`, `search`, `wishlist`, `productListing`, `productDetail`. The following pages exist but are NOT in the router — they are accessed via direct `Navigator.push` with `MaterialPageRoute`:
- `CartPage`
- `Checkout`
- `PlaceOrder`
- `AddAddress`
- `AddCard`
- `OrdersPage`
- `OrderDetailsPage`
- `ProfilePage`
- `EditProfilePage`
- `AddressesPage`
- `PaymentMethodsPage`
- `SettingsPage`

This means deep linking and back navigation from these screens won't use the router's transition animations.

### Placeholder / Mock Data Still In Use
- `ProductModel.products` — **18 hardcoded products** in `lib/data/models/product_model.dart:26-213` (static list)
- `CategoryModel.categories` — **7 hardcoded categories** in `lib/data/models/category_model.dart:14-22` (static list)
- `CoverModel.covers` — **3 hardcoded covers** in `lib/data/models/cover_model.dart:5-9` (static list)
- `LocalProductRepository` — reads from `ProductModel.products` static list (`lib/data/repositories/product/local_product_repository.dart`)
- `LocalSearchRepository` — searches against `ProductModel.products` static list (`lib/data/repositories/search/local_search_repository.dart`)
- `FakeAuthService` — legacy fake auth service still exists at `lib/data/services/fake_auth_service.dart` (superseded by Supabase auth but not removed)
- `AuthRepository` (data layer) — legacy wrapper around `FakeAuthService` at `lib/data/repositories/auth_repository.dart` (superseded by `SupabaseAuthRepository`)

### Incomplete Implementations
- **No product images from Supabase** — all product images reference local `assets/product/` paths
- **No Supabase Storage integration** — profile image upload not connected to Supabase Storage (image is saved as local file path only)
- **No order sync to Supabase** — orders exist only in SharedPreferences
- **No real-time order tracking** — no Supabase Realtime subscriptions
- **No payment processing** — card form captures data but no actual payment gateway integration
- **`lib/core/services/` directory is empty** — intended for shared services but unused
- **`lib/features/product/widgets/` directory is empty** — referenced but contains no files

---

## 6. Database Schema (Supabase)

### Tables Referenced in Code

#### `profiles`
Referenced in: `supabase_auth_repository.dart`, `profile_model.dart`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID (PK) | References `auth.users.id` (foreign key) |
| `full_name` | text | User's full name |
| `phone_number` | text | Phone number |
| `avatar_url` | text (nullable) | Profile image URL |
| `gender` | text (nullable) | Male/Female/Other |
| `date_of_birth` | timestamp (nullable) | ISO 8601 string |
| `country` | text (nullable) | Country name |
| `bio` | text (nullable) | Short bio |
| `created_at` | timestamp | Profile creation date |
| `updated_at` | timestamp | Last profile update |

### Tables NOT Yet Created (from model inference)
Based on the models and providers in the codebase, the following tables would be needed for full backend integration:

#### `products` (not yet in Supabase)
Inferred from `ProductModel`:
| Column | Type |
|--------|------|
| `id` | text (PK) |
| `name` | text |
| `image` | text |
| `price` | numeric |
| `description` | text |
| `category` | text |
| `collection` | text |
| `keywords` | text[] (array) |
| `featured` | boolean |
| `sizes` | text[] (array) |

#### `categories` (not yet in Supabase)
Inferred from `CategoryModel`:
| Column | Type |
|--------|------|
| `id` | text (PK) |
| `name` | text |
| `icon` | text |

#### `orders` (not yet in Supabase)
Inferred from `OrderModel`:
| Column | Type |
|--------|------|
| `order_id` | text (PK) |
| `user_id` | UUID (FK → profiles) |
| `order_date` | timestamp |
| `items` | jsonb |
| `total_price` | numeric |
| `payment_method` | text |
| `delivery_address` | text |
| `status` | integer (enum index) |

#### `addresses` (not yet in Supabase)
Inferred from `AddressModel`:
| Column | Type |
|--------|------|
| `id` | text (PK) |
| `user_id` | UUID (FK → profiles) |
| `street` | text |
| `apartment` | text (nullable) |
| `city` | text |
| `state` | text |
| `country` | text |
| `zip` | text |
| `label` | text |
| `is_default` | boolean |

#### `payment_cards` (not yet in Supabase)
Inferred from `PaymentCardModel`:
| Column | Type |
|--------|------|
| `id` | text (PK) |
| `user_id` | UUID (FK → profiles) |
| `card_holder_name` | text |
| `last4_digits` | text |
| `expiry_month` | text |
| `expiry_year` | text |
| `card_brand` | text |
| `is_default` | boolean |
| `created_at` | timestamp |

#### `wishlists` (not yet in Supabase)
Inferred from `WishlistNotifier`:
| Column | Type |
|--------|------|
| `user_id` | UUID (FK → profiles) |
| `product_id` | text (FK → products) |

### Relationships
- `profiles.id` ← `auth.users.id` (Supabase Auth foreign key)
- `orders.user_id` → `profiles.id`
- `addresses.user_id` → `profiles.id`
- `payment_cards.user_id` → `profiles.id`
- `wishlists.user_id` → `profiles.id`, `wishlists.product_id` → `products.id`
- `orders.items` references products by `productId`

---

## 7. Authentication Flow

### Implementation
- **Method:** Email/password via Supabase GoTrue
- **Repository:** `SupabaseAuthRepository` (`lib/features/auth/data/repositories/supabase_auth_repository.dart`)
- **State:** `AuthNotifier` with `AuthState` (`lib/data/providers/auth_provider.dart`)

### Flow
1. **Splash → Auth Check:** `SplashPage._navigateToNext()` checks `Supabase.instance.client.auth.currentSession` — if session exists, navigates to `main`; otherwise to `auth`
2. **Signup:** Calls `_auth.signUp()` → if email confirmation required (no session returned), sets `emailConfirmationPending` state → on next auth event (`signedIn`), `_loadProfileFromSession()` calls `ensureProfileExists()` to create the `profiles` row
3. **Login:** Calls `_auth.signInWithPassword()` → then `_repository.getProfile()` to load profile from `profiles` table
4. **Session Restore:** `_restoreSession()` checks `getCurrentUserId()` → loads profile from Supabase
5. **Auth State Listening:** `_listenToAuthChanges()` subscribes to `onAuthStateChange` — handles `signedIn`, `tokenRefreshed`, `signedOut` events
6. **Logout:** Calls `_repository.signOut()` → resets state

### Auth-Related Issues
- `isEmailConfirmationPending` is accessed via `_repository as dynamic` cast (line 211-212 in `auth_provider.dart`) — fragile, not type-safe
- `ensureProfileExists` also accessed via `(_repository as dynamic).ensureProfileExists()` (line 101, 231 in `auth_provider.dart`) — not on the interface
- `AuthState` is not immutable — `user` field is nullable but `isAuthenticated` getter doesn't account for loading states
- No OAuth/Google/Apple sign-in implemented
- No password reset flow

---

## 8. State Management Map

### By Feature

#### Theme
| Provider | Type | File |
|----------|------|------|
| `themeProvider` | `StateNotifierProvider<ThemeNotifier, ThemeMode>` | `core/theme/theme_provider.dart` |

#### Auth
| Provider | Type | File |
|----------|------|------|
| `supabaseClientProvider` | `Provider<SupabaseClient>` | `features/auth/presentation/providers/auth_providers.dart` |
| `authRepositoryProvider` | `Provider<AuthRepositoryInterface>` | `features/auth/presentation/providers/auth_providers.dart` |
| `authStateProvider` | `StateNotifierProvider<AuthNotifier, AuthState>` | `data/providers/auth_provider.dart` |

#### Products
| Provider | Type | File |
|----------|------|------|
| `productRepositoryProvider` | `Provider<ProductRepository>` | `data/providers/product_provider.dart` |
| `allProductsProvider` | `Provider<List<ProductModel>>` | `data/providers/product_provider.dart` |
| `featuredProductsProvider` | `Provider<List<ProductModel>>` | `data/providers/product_provider.dart` |
| `categoryProductsProvider` | `Provider.family<List<ProductModel>, String>` | `data/providers/product_provider.dart` |
| `productByIdProvider` | `Provider.family<ProductModel?, String>` | `data/providers/product_provider.dart` |

#### Cart
| Provider | Type | File |
|----------|------|------|
| `cartProvider` | `StateNotifierProvider<CartNotifier, List<CartItemModel>>` | `data/providers/cart_provider.dart` |
| `cartSubtotalProvider` | `Provider<double>` | `data/providers/cart_provider.dart` |
| `cartTotalProvider` | `Provider<double>` | `data/providers/cart_provider.dart` |

#### Wishlist
| Provider | Type | File |
|----------|------|------|
| `wishlistProvider` | `StateNotifierProvider<WishlistNotifier, List<ProductModel>>` | `data/providers/wishlist_provider.dart` |
| `wishlistCountProvider` | `Provider<int>` | `data/providers/wishlist_provider.dart` |

#### Orders
| Provider | Type | File |
|----------|------|------|
| `ordersRepositoryProvider` | `Provider<OrdersRepository>` | `data/providers/orders_provider.dart` |
| `ordersProvider` | `StateNotifierProvider<OrdersNotifier, List<OrderModel>>` | `data/providers/orders_provider.dart` |
| `ordersCountProvider` | `Provider<int>` | `data/providers/orders_provider.dart` |

#### Addresses
| Provider | Type | File |
|----------|------|------|
| `addressProvider` | `StateNotifierProvider<AddressNotifier, List<AddressModel>>` | `data/providers/address_provider.dart` |
| `defaultAddressProvider` | `Provider<AddressModel?>` | `data/providers/address_provider.dart` |
| `addressCountProvider` | `Provider<int>` | `data/providers/address_provider.dart` |

#### Payment Cards
| Provider | Type | File |
|----------|------|------|
| `paymentCardProvider` | `StateNotifierProvider<PaymentCardNotifier, List<PaymentCardModel>>` | `data/providers/payment_card_provider.dart` |
| `defaultPaymentCardProvider` | `Provider<PaymentCardModel?>` | `data/providers/payment_card_provider.dart` |
| `paymentCardCountProvider` | `Provider<int>` | `data/providers/payment_card_provider.dart` |

#### Search
| Provider | Type | File |
|----------|------|------|
| `searchRepositoryProvider` | `Provider<SearchRepository>` | `data/providers/search_provider.dart` |
| `searchQueryProvider` | `StateProvider<String>` | `data/providers/search_provider.dart` |
| `searchSourceProvider` | `Provider<List<ProductModel>?>` | `data/providers/search_provider.dart` |
| `searchContextProvider` | `Provider<SearchContextType>` | `data/providers/search_provider.dart` |
| `searchProvider` | `StateNotifierProvider<SearchNotifier, SearchState>` | `data/providers/search_provider.dart` |
| `highlightedQueryProvider` | `Provider<String>` | `data/providers/search_provider.dart` |

#### Profile (Edit)
| Provider | Type | File |
|----------|------|------|
| `editProfileProvider` | `StateNotifierProvider<EditProfileNotifier, EditProfileState>` | `features/profile/presentation/providers/edit_profile_provider.dart` |

### Dead / Unused Code
- `lib/data/repositories/auth_repository.dart` — Legacy `AuthRepository` using `FakeAuthService`. Superseded by `SupabaseAuthRepository` but not removed.
- `lib/data/services/fake_auth_service.dart` — Legacy fake auth. No longer referenced by active code path (only by dead `AuthRepository`).
- `searchSourceProvider` — returns `null` by default, never overridden anywhere in the codebase.
- `productByIdProvider` — defined but never watched/read in any screen.

---

## 9. Routing

### Solution
**Navigator 1.0** with `onGenerateRoute` in `lib/core/router/app_router.dart`. Uses `PageRouteBuilder` with custom slide+fade transitions.

### Defined Routes
| Route | Page | Transition |
|-------|------|-----------|
| `/splash` | `SplashPage` | Default (right slide) |
| `/auth` | `AuthPage` | Right slide |
| `/login` | `LoginPage` | Right slide |
| `/signup` | `SignupPage` | Right slide |
| `/main` | `MainScreen(initialTab: args)` | Right slide |
| `/search` | `SearchScreen` | Bottom slide |
| `/wishlist` | `WishlistPage` | Right slide |
| `/product-listing` | `ProductListingPage(category: args)` | Right slide |
| `/product-detail` | `ProductDetailPage(product: args)` | Right slide |

### Broken / Unconnected Routes
- **No routes defined** for: `CartPage`, `Checkout`, `PlaceOrder`, `AddAddress`, `AddCard`, `OrdersPage`, `OrderDetailsPage`, `ProfilePage`, `EditProfilePage`, `AddressesPage`, `PaymentMethodsPage`, `SettingsPage`, `CategoriesPage`
- These screens are accessed via direct `Navigator.push(MaterialPageRoute(...))` calls throughout the codebase, bypassing the router's custom transitions
- Default fallback route goes to `SplashPage` (could cause loops if route name is mistyped)

---

## 10. Known Issues / Technical Debt

### Hardcoded Values

**Hardcoded Colors (not from AppColors):**
| File | Line | Value |
|------|------|-------|
| `signup_page.dart` | 83 | `Colors.green.shade700` |
| `signup_page.dart` | 207 | `Colors.green.shade50` |
| `signup_page.dart` | 209 | `Colors.green.shade200` |
| `signup_page.dart` | 214 | `Colors.green.shade700` |
| `signup_page.dart` | 222 | `Colors.green.shade800` |
| `checkout.dart` | 129 | `Colors.red.shade200` |
| `product_detail_page.dart` | 140 | `Colors.red.shade200` |
| `place_order.dart` | 552 | `Colors.red.shade200` |
| `edit_profile_page.dart` | 138 | `Colors.red.shade400` |
| `add_card.dart` | 48 | `Colors.grey.shade800` |

**Hardcoded `fontSize` (not using centralized text styles):**
37 instances across auth, settings, checkout, product detail, search, and widget files. No centralized text style system exists — only `CustomText` widget with inline `size` params.

**Hardcoded `fontFamily: 'Tenor_Sans'`:**
16 instances across widget files. While `CustomText` centralizes this, many files bypass `CustomText` and set the font directly (e.g., `confirm_delete_dialog.dart`, `profile_form_section.dart`, `highlighted_text.dart`).

### Large Files (300+ Lines)
| File | Lines | Issue |
|------|-------|-------|
| `lib/features/checkout/presentation/pages/place_order.dart` | **780** | Contains checkout UI, validation, order creation, success dialog, and `_CustomContainer` widget — should be split |
| `lib/features/profile/presentation/pages/edit_profile_page.dart` | **398** | Form with many fields — could extract form sections |
| lib/features/menu/presentation/pages/categories_page.dart` | **340** | Contains multiple private widget classes — acceptable but dense |
| `lib/data/providers/auth_provider.dart` | **414** | AuthState class + AuthNotifier — AuthState could be in its own file |

### Duplicated Code/Logic
- `LocalProductRepository.searchProducts()` and `LocalSearchRepository.searchProducts()` contain identical search logic (case-insensitive multi-field contains check)
- `IdGenerator.generate()` and `IdGenerator.generateOrderId()` are identical methods
- `OrderItemModel` and `CartItemModel` have nearly identical fields — `OrderItemModel.fromCartItem()` exists but the models themselves are duplicated
- Several pages construct `EdgeInsets.symmetric(horizontal: 15.0.w)` or `EdgeInsets.symmetric(horizontal: 20.w)` inline instead of using a shared padding constant

### Performance Concerns
- `Home` page uses `Future.delayed(Duration(milliseconds: 600))` to fake a loading state (`_isLoading`) — should use actual async data loading
- `PlaceOrder._placeOrderAndConfirm()` calls `ref.read()` multiple times in sequence — could batch reads
- `ProductModel.products` is a `static List` — all 18 products are always in memory, even when only a few are needed
- No `const` constructors used in several widget build methods (e.g., `SizedBox(height: 10.h)` instead of using const where possible)
- `SearchNotifier` creates a `Timer` on every query change — standard pattern but no cancellation on dispose if provider is auto-disposed

### Dead Code
- `lib/data/repositories/auth_repository.dart` — Legacy `AuthRepository` wrapping `FakeAuthService`
- `lib/data/services/fake_auth_service.dart` — Entire file is unused legacy
- `lib/core/services/` — Empty directory
- `lib/features/product/widgets/` — Empty directory
- `searchSourceProvider` — Returns `null`, never overridden
- `productByIdProvider` — Defined but never used
- `SearchResultModel` — Defined but never instantiated anywhere

---

## 11. UI / Design System Status

### Centralized Theme
**Yes.** `lib/core/theme/` contains:
- `AppColors` — 30+ named color constants (primary, blacks, greys, whites, accent, borders, text colors)
- `AppTheme` — `lightTheme` and `darkTheme` `ThemeData` objects defining: scaffold background, colorScheme (light/dark), appBarTheme, bottomNavigationBarTheme, dividerColor, iconTheme
- `ThemeNotifier` — `StateNotifier<ThemeMode>` with persistence via `ThemeStorage` (SharedPreferences)
- Design system is **minimalist black & white** — luxury fashion aesthetic

### What's Defined in Theme
- ✅ Colors (via `AppColors`)
- ✅ Light/Dark `ThemeData`
- ✅ Theme persistence
- ✅ Animated theme switching (300ms)
- ❌ No centralized text styles (no `TextTheme` extension)
- ❌ No spacing/padding constants
- ❌ No border radius constants
- ❌ No elevation/shadow constants

### Reusable Widgets Available
| Widget | Location | Purpose |
|--------|----------|---------|
| `CustomText` | `core/widgets/custom_text.dart` | Text with Tenor Sans font, letter spacing |
| `CustomButton` | `core/widgets/custom_button.dart` | Animated press-scale button with SVG icon |
| `CustomAppbar` | `core/widgets/custom_appbar.dart` | App bar with optional search bar |
| `CustomTextField` | `core/widgets/custom_text_field.dart` | Styled text input |
| `Header` | `core/widgets/header.dart` | Section header text |
| `BadgeWidget` | `core/widgets/badge_widget.dart` | Counter badge |
| `ActionChipWidget` | `core/widgets/action_chip_widget.dart` | Action chip |
| `PressScale` | `core/widgets/press_scale.dart` | Press-to-scale gesture wrapper |
| `SuccessDialog` | `core/widgets/success_dialog.dart` | Success confirmation dialog |
| `ConfirmDeleteDialog` | `core/widgets/confirm_delete_dialog.dart` | Delete confirmation dialog |
| 7 Skeleton widgets | `core/widgets/skeletons/` | Shimmer loading states for home, orders, products, search, wishlist |

### Consistency Issues
- Auth pages use `CustomAuthButton`/`CustomAuthTextField` instead of the core `CustomButton`/`CustomTextField` — duplicated widget variants
- Some pages use `Navigator.push(MaterialPageRoute(...))` directly while others use named routes — inconsistent navigation patterns
- Font sizes are all inline — no text style scale (e.g., `headlineMedium`, `bodyLarge`)
- Spacing values are ad-hoc (e.g., `Gap(10.h)`, `Gap(15.h)`, `Gap(20.h)`, `Gap(30.h)`, `Gap(40.h)`) — no spacing scale
- `fontSize: 64.w` used in `empty_addresses.dart` and `payment_methods_page.dart` — incorrect usage of `.w` instead of `.sp`

---

## 12. What's Next (Suggested)

Based on the current state (UI ~92%, business logic ~70%, backend ~5%):

### 1. Migrate Products to Supabase
Create `products` table in Supabase, upload product images to Supabase Storage, replace `LocalProductRepository` with a `SupabaseProductRepository`, update `productRepositoryProvider` to use it. This unlocks real product data across home, listing, detail, search, and wishlist screens.

### 2. Migrate Orders, Cart, Addresses, Payment Cards to Supabase
Create `orders`, `addresses`, `payment_cards`, `wishlists` tables. Replace SharedPreferences-based storage services with Supabase-backed repositories. Add `user_id` foreign keys for per-user data isolation.

### 3. Add Row Level Security (RLS)
Implement RLS policies on all Supabase tables to ensure users can only read/write their own data. This is critical before any production deployment.

### 4. Add Supabase Storage for Profile Images
Connect the `EditProfilePage` image picker to upload to Supabase Storage instead of saving local file paths. Update `SupabaseAuthRepository.updateProfile()` to accept and store uploaded image URLs.

### 5. Clean Up Technical Debt
- Remove legacy `FakeAuthService` and `AuthRepository` (data layer)
- Extract `place_order.dart` into smaller widgets (target < 300 lines)
- Create a text style scale in the theme to replace 37+ inline `fontSize` values
- Add missing routes to `AppRouter` for all screens
- Replace `Colors.red.shade200` etc. with `AppColors` constants
- Remove empty directories (`core/services/`, `features/product/widgets/`)
- Remove dead providers (`searchSourceProvider`, `productByIdProvider`)
