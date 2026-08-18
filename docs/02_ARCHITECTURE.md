# 02 — Architecture

> **MaxFashion — System Architecture & Technical Design**
> Last Updated: August 16, 2026

---

## Overall Architecture

MaxFashion follows a **feature-first, hybrid Clean Architecture** pattern with Riverpod for state management and Supabase as the backend.

```
UI (Pages/Widgets)
  → Riverpod Providers (StateNotifier / StateProvider / Provider)
    → Repositories (Abstract interfaces + Supabase implementations)
      → Supabase Client (PostgreSQL + Storage + Auth + Edge Functions)
        → Supabase Backend
```

### Layers

| Layer | Location | Responsibility |
|-------|----------|---------------|
| Presentation | `lib/features/*/presentation/` | Pages, widgets, feature-level providers |
| Data | `lib/data/` | Models, providers, repositories, services |
| Core | `lib/core/` | Shared utilities, theme, routing, widgets, constants |

### Key Design Decisions

1. **Repository Pattern** — Abstract interfaces for all data access. Supabase implementations are wired via Riverpod providers.
2. **Riverpod** — All state management uses `StateNotifierProvider`, `StateProvider`, or `Provider`.
3. **Navigator 1.0** — `onGenerateRoute` with custom slide/fade transitions (24 named routes).
4. **ScreenUtil** — Design size 375x812, all sizing via `.w`, `.h`, `.r`, `.sp`.
5. **Theme-aware** — `Theme.of(context).colorScheme` used throughout, no hardcoded colors.
6. **Auth-Aware Providers** — All user-scoped providers watch `currentUserIdProvider` to auto-invalidate on login/logout, preventing cross-account data leakage.

---

## Project Structure

```
lib/
├── main.dart                          # App entry, Supabase init, ProviderScope
├── splash.dart                        # Animated splash with session check
├── core/
│   ├── constants/                     # App constants, asset paths
│   ├── router/                        # AppRouter (24 named routes)
│   ├── theme/                         # AppColors, AppTheme, ThemeProvider, ThemeStorage
│   ├── utils/                         # Validators, formatters, haptics, ID generator
│   └── widgets/                       # 18+ reusable widgets + skeletons
├── data/
│   ├── models/                        # 11 data models
│   ├── providers/                     # 9+ Riverpod providers
│   ├── repositories/                  # Abstract + Supabase implementations
│   │   ├── address/                   # AddressRepository, SupabaseAddressRepository
│   │   ├── cart/                      # CartRepository, SupabaseCartRepository
│   │   ├── orders/                    # OrderRepository, SupabaseOrderRepository
│   │   ├── payment_card/              # PaymentCardRepository, SupabasePaymentCardRepository
│   │   ├── product/                   # ProductRepository, SupabaseProductRepository
│   │   ├── search/                    # SearchRepository, SupabaseSearchRepository
│   │   ├── wishlist/                  # WishlistRepository, SupabaseWishlistRepository
│   │   ├── home_content_repository.dart
│   │   └── supabase_home_content_repository.dart
│   └── services/                      # OrdersMigrationService
└── features/
    ├── auth/                          # Auth (data/domain/presentation)
    │   ├── data/repositories/         # SupabaseAuthRepository
    │   ├── data/models/               # ProfileModel
    │   ├── domain/                    # AuthRepositoryInterface
    │   └── presentation/
    │       ├── pages/                 # AuthPage, LoginPage, SignupPage, ForgotPasswordPage,
    │       │                          # VerifyResetCodePage, ResetPasswordPage
    │       ├── providers/             # auth_providers.dart (DI)
    │       └── widgets/               # CustomAuthButton, CustomAuthTextField
    ├── cart/                          # Cart UI
    ├── checkout/                      # Checkout, PlaceOrder, AddAddress, AddCard
    ├── home/                          # Home page
    ├── main/                          # MainScreen (bottom nav)
    ├── menu/                          # CategoriesPage
    ├── orders/                        # OrdersPage, OrderDetailsPage
    ├── product/                       # ProductListing, ProductDetail
    ├── profile/                       # Profile, EditProfile, Addresses, PaymentMethods
    ├── search/                        # SearchScreen
    ├── settings/                      # SettingsPage
    └── wishlist/                      # WishlistPage
```

---

## Data Flow by Feature

### Authentication
```
LoginPage → authStateProvider → AuthNotifier.login()
  → SupabaseAuthRepository.signIn() → Supabase Auth
  → SupabaseAuthRepository.getProfile() → Supabase profiles table
  → AuthState (UserModel)
```

### OTP Password Recovery
```
ForgotPasswordPage → authStateProvider → AuthNotifier.sendResetCode()
  → SupabaseAuthRepository.sendResetCode()
  → Supabase Edge Function 'send-reset-code'
  → password_reset_codes table + Resend API email

VerifyResetCodePage → authStateProvider → AuthNotifier.verifyResetCode()
  → SupabaseAuthRepository.verifyResetCode()
  → Supabase Edge Function 'reset-password'
  → Verifies code (unused, not expired, attempts < 5)

ResetPasswordPage → authStateProvider → AuthNotifier.resetPasswordWithCode()
  → SupabaseAuthRepository.resetPasswordWithCode()
  → Supabase Edge Function 'reset-password'
  → Updates password via admin API, marks code as used
```

### Products
```
Home → filteredHomeProductsProvider → productRepositoryProvider
  → SupabaseProductRepository.loadAll()
  → Supabase (categories + products + product_images + product_sizes via join)
  → In-memory cache → productsLoaded flag
```

### Cart
```
ProductDetailPage → cartProvider → CartNotifier.addItem()
  → SupabaseCartRepository.addItem()
  → Supabase cart_items table (+ product join)
  → CartState (List<CartItemModel>)
```

### Wishlist (Supabase)
```
FavoriteButton → wishlistProvider → WishlistNotifier.toggle()
  → SupabaseWishlistRepository
  → Supabase wishlist_items table (+ product join)
  → WishlistState (List<ProductModel>)
```

### Orders (Supabase)
```
PlaceOrder → ordersProvider → OrdersNotifier.addOrder()
  → SupabaseOrderRepository.addOrder()
  → Supabase orders table
  → Supabase order_items table
  → OrdersState (List<OrderModel>)
```

### Addresses (Supabase)
```
AddressesPage → addressProvider → AddressNotifier.load()
  → SupabaseAddressRepository.loadAddresses()
  → Supabase addresses table
  → AddressState (List<AddressModel>)
```

### Payment Cards (Supabase)
```
PaymentMethodsPage → paymentCardProvider → PaymentCardNotifier.load()
  → SupabasePaymentCardRepository.loadCards()
  → Supabase payment_cards table
  → PaymentCardState (List<PaymentCardModel>)
```

### Search
```
SearchScreen → searchProvider → SearchNotifier.onQueryChanged()
  → (250ms debounce)
  → SupabaseSearchRepository.searchProducts()
  → Supabase RPC `search_products` (full-text search with trigram matching)
  → SearchState (results)
```

### Profile
```
EditProfilePage → authStateProvider → AuthNotifier.updateProfile()
  → SupabaseAuthRepository.updateProfile()
  → Supabase profiles table
```

### Avatar Upload
```
EditProfilePage → AuthNotifier.updateProfile()
  → SupabaseAuthRepository.uploadAvatar()
  → Supabase Storage (avatars bucket)
  → profiles.avatar_url update
```

---

## Supabase Architecture

### Initialization
- `lib/main.dart` — Loads `.env`, validates keys, calls `Supabase.initialize()`
- `.env` contains `SUPABASE_URL` and `SUPABASE_ANON_KEY`

### Auth
- `Supabase.instance.client.auth` used throughout
- `signUp()`, `signInWithPassword()`, `signOut()`, `onAuthStateChange`
- Email confirmation flow supported
- Session persistence via Supabase SDK (automatic)

### OTP Password Recovery
- Three Supabase Edge Functions (Deno/TypeScript):
  - `send-reset-code` — generates 6-digit OTP, stores in `password_reset_codes`, sends via Resend API
  - `verify-reset-code` — verifies OTP code without changing password (enforces max 5 attempts)
  - `reset-password` — verifies OTP code again (defense-in-depth), updates password via admin API, marks code as used
- `password_reset_codes` table with rate limiting (60s cooldown) and attempt limiting (max 5)
- `cleanup_expired_codes()` SQL function for automatic cleanup
- ✅ **RLS correctly secured** — Migration 016 has NO anon policies. Edge functions use service_role which bypasses RLS.

### Database Tables

| Table | Purpose | RLS |
|-------|---------|-----|
| `profiles` | User profile (extends auth.users) | User-owned |
| `categories` | Product categories (with icon_name, display_order) | Public read |
| `products` | Core catalog items | Public read |
| `product_images` | Multiple images per product | Public read |
| `product_sizes` | Size/stock per product | Public read |
| `cart_items` | User cart items | User-owned |
| `wishlist_items` | User wishlist items | User-owned |
| `home_content` | Home page cover image | Public read (active only) |
| `orders` | User orders | User-owned |
| `order_items` | Order line items | User-owned (via orders) |
| `addresses` | User shipping addresses | User-owned |
| `payment_cards` | Saved payment methods | User-owned |
| `password_reset_codes` | OTP codes for password reset | ✅ Service-role only (no anon policies) |

### Storage

| Bucket | Purpose | Access |
|--------|---------|--------|
| `avatars` | Profile avatars | Public read, owner write |
| `product-images` | Product images | Public read, service-role write |

### SQL Migrations

```
supabase/migrations/
├── 001_products_schema.sql          — Schema for categories, products, product_images, product_sizes + RLS
├── 002_seed_categories.sql          — INSERT 22 categories
├── 003_seed_products.sql            — INSERT 249 products
├── 004_seed_product_images.sql      — INSERT 250 images
├── 005_seed_product_sizes.sql       — INSERT 998 sizes
├── 006_home_content.sql             — home_content table + seed
├── 007_product_images_storage_policies.sql — Storage RLS for product-images bucket
├── 008_sync_cleanup.sql             — Remove stale records (3 products, 1 category)
├── 009_cart_items_schema.sql        — cart_items table + RLS
├── 010_wishlist_items_schema.sql    — wishlist_items table + RLS
├── 011_orders_schema.sql            — orders + order_items tables + RLS
├── 012_dynamic_categories.sql       — Dynamic category support (icon_name, display_order, is_active)
├── 013_drop_categories_image_url.sql — Drop image_url from categories
├── 014_addresses_schema.sql         — addresses table + RLS
├── 015_payment_cards_schema.sql     — payment_cards table + RLS
├── 016_create_password_reset_codes.sql — password_reset_codes table + cleanup function + RLS (service-role only)
├── 017_otp_security_hardening.sql   — Rate limiting columns (attempt_count, last_request_at)
├── 018_profiles_schema.sql          — profiles table formalization + RLS + updated_at trigger
├── 019_avatars_storage.sql          — avatars bucket + storage policies
└── 020_full_text_search.sql         — pg_trgm extension, search_vector column, search_products RPC function
```

### Edge Functions

```
supabase/functions/
├── send-reset-code/
│   └── index.ts                     — Sends 6-digit OTP via Resend API
├── verify-reset-code/
│   └── index.ts                     — Verifies OTP code without changing password
└── reset-password/
    └── index.ts                     — Verifies OTP and resets password via admin API
```

---

## Key Providers

| Provider | Type | File |
|----------|------|------|
| `authStateProvider` | StateNotifierProvider | `data/providers/auth_provider.dart` |
| `currentUserIdProvider` | Provider | `data/providers/auth_provider.dart` |
| `productRepositoryProvider` | Provider | `data/providers/product_provider.dart` |
| `allProductsProvider` | Provider | `data/providers/product_provider.dart` |
| `categoriesProvider` | Provider | `data/providers/product_provider.dart` |
| `filteredHomeProductsProvider` | Provider | `data/providers/product_provider.dart` |
| `cartProvider` | StateNotifierProvider | `data/providers/cart_provider.dart` |
| `cartItemsProvider` | Provider | `data/providers/cart_provider.dart` |
| `cartSubtotalProvider` | Provider | `data/providers/cart_provider.dart` |
| `wishlistProvider` | StateNotifierProvider | `data/providers/wishlist_provider.dart` |
| `wishlistCountProvider` | Provider | `data/providers/wishlist_provider.dart` |
| `orderRepositoryProvider` | Provider | `data/providers/orders_provider.dart` |
| `ordersMigrationServiceProvider` | Provider | `data/providers/orders_provider.dart` |
| `ordersProvider` | StateNotifierProvider | `data/providers/orders_provider.dart` |
| `ordersCountProvider` | Provider | `data/providers/orders_provider.dart` |
| `addressRepositoryProvider` | Provider | `data/providers/address_provider.dart` |
| `addressProvider` | StateNotifierProvider | `data/providers/address_provider.dart` |
| `defaultAddressProvider` | Provider | `data/providers/address_provider.dart` |
| `addressCountProvider` | Provider | `data/providers/address_provider.dart` |
| `paymentCardRepositoryProvider` | Provider | `data/providers/payment_card_provider.dart` |
| `paymentCardProvider` | StateNotifierProvider | `data/providers/payment_card_provider.dart` |
| `defaultPaymentCardProvider` | Provider | `data/providers/payment_card_provider.dart` |
| `paymentCardCountProvider` | Provider | `data/providers/payment_card_provider.dart` |
| `searchProvider` | StateNotifierProvider | `data/providers/search_provider.dart` |
| `homeContentProvider` | FutureProvider | `data/providers/home_content_provider.dart` |
| `themeProvider` | StateNotifierProvider | `core/theme/theme_provider.dart` |
| `authRepositoryProvider` | Provider | `features/auth/presentation/providers/auth_providers.dart` |

### Auth-Aware Provider Invalidation

All user-scoped providers (`cartProvider`, `wishlistProvider`, `ordersProvider`, `addressProvider`, `paymentCardProvider`) watch `currentUserIdProvider` to auto-invalidate when the user changes. This prevents cross-account data leakage.

**Defense in depth (3 layers):**
1. **Application layer:** Explicit `user_id` filters in all Supabase queries
2. **Database layer:** RLS policies enforce `auth.uid() = user_id`
3. **Lifecycle layer:** `mounted` checks prevent state updates after disposal

---

## Key Models

| Model | File | Fields |
|-------|------|--------|
| `UserModel` | `data/models/user_model.dart` | id, fullName, email, phoneNumber, profileImage, memberSince, dateOfBirth, gender, country, bio |
| `ProductModel` | `data/models/product_model.dart` | id, categoryId, name, description, price, discountPrice, brand, thumbnailUrl, isFeatured, isAvailable, productImages, productSizes |
| `CategoryModel` | `data/models/category_model.dart` | id, name, slug, iconName, displayOrder, isActive |
| `CartItemModel` | `data/models/cart_item_model.dart` | id, productId, productName, productImage, selectedColor, selectedSize, quantity, unitPrice, createdAt, updatedAt |
| `OrderModel` | `data/models/order_model.dart` | orderId, orderDate, items, totalPrice, paymentMethod, deliveryAddress, status |
| `OrderItemModel` | `data/models/order_item_model.dart` | productId, productName, productImage, selectedColor, selectedSize, quantity, unitPrice |
| `AddressModel` | `data/models/address_model.dart` | id, street, apartment, city, state, country, zip, label, isDefault |
| `PaymentCardModel` | `data/models/payment_card_model.dart` | id, cardHolderName, last4Digits, expiryMonth, expiryYear, cardBrand, isDefault, createdAt |
| `ProfileModel` | `features/auth/data/models/profile_model.dart` | id, fullName, phoneNumber, avatarUrl, gender, dateOfBirth, country, bio, createdAt, updatedAt |
| `HomeContentModel` | `data/models/home_content_model.dart` | id, coverUrl, isActive |
| `ProductImageModel` | `data/models/product_image_model.dart` | id, productId, imageUrl, sortOrder |
| `ProductSizeModel` | `data/models/product_size_model.dart` | productId, size, stock |

---

## Navigation

### Bottom Navigation (4 tabs)
| Tab | Page | Badge |
|-----|------|-------|
| Home | `Home` | — |
| Menu | `CategoriesPage` | — |
| Cart | `CartPage` | Cart count |
| You | `ProfilePage` | Wishlist count |

### Named Routes (24)
`/splash`, `/auth`, `/login`, `/signup`, `/main`, `/search`, `/wishlist`, `/product-listing`, `/product-detail`, `/cart`, `/place-order`, `/add-address`, `/add-card`, `/orders`, `/order-details`, `/profile`, `/edit-profile`, `/addresses`, `/payment-methods`, `/settings`, `/categories`, `/forgot-password`, `/verify-reset-code`, `/reset-password`

---

*See [01_PROJECT_STATUS.md](./01_PROJECT_STATUS.md) for current state, [03_FEATURES_AND_DATA.md](./03_FEATURES_AND_DATA.md) for feature details, and [04_ROADMAP_AND_TECHNICAL_DEBT.md](./04_ROADMAP_AND_TECHNICAL_DEBT.md) for remaining work.*
