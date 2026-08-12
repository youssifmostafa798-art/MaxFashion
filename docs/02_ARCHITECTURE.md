# 02 — Architecture

> **MaxFashion — System Architecture & Technical Design**
> Last Updated: August 12, 2026

---

## Overall Architecture

MaxFashion follows a **feature-first, hybrid Clean Architecture** pattern with Riverpod for state management and Supabase as the backend.

```
UI (Pages/Widgets)
  → Riverpod Providers (StateNotifier / StateProvider / Provider)
    → Repositories (Abstract interfaces + Supabase implementations)
      → Supabase Client (PostgreSQL + Storage + Auth)
        → Supabase Backend
```

### Layers

| Layer | Location | Responsibility |
|-------|----------|---------------|
| Presentation | `lib/features/*/presentation/` | Pages, widgets, feature-level providers |
| Data | `lib/data/` | Models, providers, repositories, services, datasources |
| Core | `lib/core/` | Shared utilities, theme, routing, widgets, constants |

### Key Design Decisions

1. **Repository Pattern** — Abstract interfaces for all data access. Supabase implementations are wired via Riverpod providers.
2. **Riverpod** — All state management uses `StateNotifierProvider`, `StateProvider`, or `Provider`.
3. **Navigator 1.0** — `onGenerateRoute` with custom slide/fade transitions (22 named routes).
4. **ScreenUtil** — Design size 375x812, all sizing via `.w`, `.h`, `.r`, `.sp`.
5. **Theme-aware** — `Theme.of(context).colorScheme` used throughout, no hardcoded colors.

---

## Project Structure

```
lib/
├── main.dart                          # App entry, Supabase init, ProviderScope
├── splash.dart                        # Animated splash with session check
├── core/
│   ├── config/                        # Supabase client getter
│   ├── constants/                     # App constants, asset paths
│   ├── router/                        # AppRouter (22 named routes)
│   ├── theme/                         # AppColors, AppTheme, ThemeProvider, ThemeStorage
│   ├── utils/                         # Validators, formatters, haptics, ID generator
│   └── widgets/                       # 18+ reusable widgets + skeletons
├── data/
│   ├── datasources/local/             # LocalProductDataSource (JSON fallback)
│   ├── models/                        # 11 data models
│   ├── providers/                     # 9 Riverpod providers
│   ├── repositories/                  # Abstract + Supabase implementations
│   │   ├── cart/                      # CartRepository, SupabaseCartRepository
│   │   ├── orders/                    # OrderRepository, SupabaseOrderRepository
│   │   ├── product/                   # ProductRepository, SupabaseProductRepository
│   │   ├── search/                    # SearchRepository, SupabaseSearchRepository
│   │   ├── wishlist/                  # WishlistRepository, SupabaseWishlistRepository
│   │   └── home_content_repository.dart
│   └── services/                      # OrdersMigrationService, PaymentCardStorage
└── features/
    ├── auth/                          # Auth (data/domain/presentation)
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

### Search
```
SearchScreen → searchProvider → SearchNotifier.onQueryChanged()
  → (250ms debounce)
  → SupabaseSearchRepository.searchProducts()
  → In-memory filter of Supabase-cached products
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

### Database Tables

| Table | Purpose | RLS |
|-------|---------|-----|
| `profiles` | User profile (extends auth.users) | User-owned |
| `categories` | Product categories | Public read |
| `products` | Core catalog items | Public read |
| `product_images` | Multiple images per product | Public read |
| `product_sizes` | Size/stock per product | Public read |
| `cart_items` | User cart items | User-owned |
| `wishlist_items` | User wishlist items | User-owned |
| `home_content` | Home page cover image | Public read (active only) |
| `orders` | User orders | User-owned |
| `order_items` | Order line items | User-owned (via orders) |

### Storage

| Bucket | Purpose | Access |
|--------|---------|--------|
| `avatars` | Profile avatars | Public read, owner write |
| `product-images` | Product images | Public read, service-role write |

### SQL Migrations

```
supabase/migrations/
├── 001_products_schema.sql          — Schema for categories, products, product_images, product_sizes + RLS
├── 002_seed_categories.sql          — INSERT 23 categories
├── 003_seed_products.sql            — INSERT 251 products
├── 004_seed_product_images.sql      — INSERT 251 images
├── 005_seed_product_sizes.sql       — INSERT 977 sizes
├── 006_home_content.sql             — home_content table + seed
├── 007_product_images_storage_policies.sql — Storage RLS for product-images bucket
├── 008_sync_cleanup.sql             — Remove stale records (3 products, 1 category)
├── 009_cart_items_schema.sql        — cart_items table + RLS
├── 010_wishlist_items_schema.sql    — wishlist_items table + RLS
└── 011_orders_schema.sql            — orders + order_items tables + RLS
```

---

## Key Providers

| Provider | Type | File |
|----------|------|------|
| `authStateProvider` | StateNotifierProvider | `data/providers/auth_provider.dart` |
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
| `addressProvider` | StateNotifierProvider | `data/providers/address_provider.dart` |
| `paymentCardProvider` | StateNotifierProvider | `data/providers/payment_card_provider.dart` |
| `searchProvider` | StateNotifierProvider | `data/providers/search_provider.dart` |
| `homeContentProvider` | FutureProvider | `data/providers/home_content_provider.dart` |
| `themeProvider` | StateNotifierProvider | `core/theme/theme_provider.dart` |

---

## Key Models

| Model | File | Fields |
|-------|------|--------|
| `UserModel` | `data/models/user_model.dart` | id, fullName, email, phoneNumber, profileImage, memberSince, dateOfBirth, gender, country, bio |
| `ProductModel` | `data/models/product_model.dart` | id, categoryId, name, description, price, discountPrice, brand, thumbnailUrl, isFeatured, isAvailable, productImages, productSizes |
| `CategoryModel` | `data/models/category_model.dart` | id, name, slug, imageUrl |
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

### Named Routes (22)
`/splash`, `/auth`, `/login`, `/signup`, `/main`, `/search`, `/wishlist`, `/product-listing`, `/product-detail`, `/cart`, `/place-order`, `/add-address`, `/add-card`, `/orders`, `/order-details`, `/profile`, `/edit-profile`, `/addresses`, `/payment-methods`, `/settings`, `/categories`

---

*See [01_PROJECT_STATUS.md](./01_PROJECT_STATUS.md) for current state, [03_FEATURES_AND_DATA.md](./03_FEATURES_AND_DATA.md) for feature details, and [04_ROADMAP_AND_TECHNICAL_DEBT.md](./04_ROADMAP_AND_TECHNICAL_DEBT.md) for remaining work.*
