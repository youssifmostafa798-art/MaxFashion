# Supabase Backend Architecture - MaxFashion

> Single source of truth for the upcoming Supabase integration.
> This document is read-only by design - no source code, database, or package changes should be made until the migration phases begin.

---

## Table of Contents

1. [Current Project Analysis](#1-current-project-analysis)
2. [Future Backend Architecture](#2-future-backend-architecture)
3. [Database Relationships](#3-database-relationships)
4. [Fake Data Migration Strategy](#4-fake-data-migration-strategy)
5. [Feature-by-Feature Migration Plan](#5-feature-by-feature-migration-plan)
6. [Repository Strategy](#6-repository-strategy)
7. [Riverpod Providers Strategy](#7-riverpod-providers-strategy)
8. [Data Models](#8-data-models)
9. [Row Level Security Plan](#9-row-level-security-plan)
10. [Backend Folder Structure](#10-backend-folder-structure)
11. [API / Data Flow](#11-api--data-flow)
12. [Risks and Migration Notes](#12-risks-and-migration-notes)
13. [Final Roadmap](#13-final-roadmap)

---

## 1. Current Project Analysis

### 1.1 Architecture Overview

The application follows **Clean Architecture** with three visible layers:

```
lib/
  core/              # Shared utilities, theme, router, widgets, constants
  data/              # Models, Providers, Repositories, Services
    models/          # Plain Dart data classes with JSON serialization
    providers/       # Riverpod StateNotifier / StateProvider definitions
    repositories/    # Abstract interfaces + local (fake) implementations
    services/        # Local storage services (SharedPreferences)
  features/          # Feature modules, each with presentation/ only
    auth/
    cart/
    checkout/
    home/
    main/
    menu/
    orders/
    product/
    profile/
    search/
    settings/
    wishlist/
```

**Key observations:**

- Every feature folder contains only `presentation/` (pages, widgets, and sometimes feature-level providers).
- There are no dedicated `domain/` or `data/` sub-folders inside features - all data logic lives in `lib/data/`.
- The app uses **Riverpod** (`flutter_riverpod ^2.6.1`) for state management.
- Local persistence is handled via **SharedPreferences** (`shared_preferences ^2.2.2`).
- There is **no backend, no REST API, no real authentication** - everything runs locally.

### 1.2 How Fake Data Flows Through the Application

```
+-----------------------------------------------------+
|                    DATA LAYER                        |
|                                                     |
|  FakeAuthService --> AuthRepository --> AuthProvider |
|  ProductModel.products (static) --> LocalProductRepo |
|       --> Product Providers                         |
|  CartStorage (SharedPreferences) --> CartProvider    |
|  OrdersStorage (SharedPreferences) --> OrdersProvider|
|  Wishlist (SharedPreferences + static product list)  |
|       --> WishlistProvider                           |
|  AddressProvider (SharedPreferences directly)        |
|  PaymentCardStorage --> PaymentCardProvider          |
+-----------------------------------------------------+
                          |
                          v
+-----------------------------------------------------+
|                 PRESENTATION LAYER                   |
|                                                     |
|  LoginPage --ref.watch--> authStateProvider          |
|  Home --ref.watch--> featuredProductsProvider        |
|  CartPage --ref.watch--> cartProvider                |
|  WishlistPage --ref.watch--> wishlistProvider        |
|  OrdersPage --ref.watch--> ordersProvider            |
|  ProfilePage --ref.watch--> authStateProvider        |
+-----------------------------------------------------+
```

### 1.3 Repositories

| Repository | Type | Data Source | Status |
|---|---|---|---|
| `AuthRepository` | Concrete class | `FakeAuthService` (SharedPreferences) | Fake |
| `ProductRepository` | Abstract interface | - | Interface exists |
| `LocalProductRepository` | Concrete (implements `ProductRepository`) | `ProductModel.products` static list | Fake |
| `SearchRepository` | Abstract interface | - | Interface exists |
| `LocalSearchRepository` | Concrete (implements `SearchRepository`) | `ProductModel.products` static list | Fake |
| `OrdersRepository` | Concrete class | `OrdersStorage` (SharedPreferences) | Fake |

**Important:** `ProductRepository` and `SearchRepository` already have **abstract interfaces** - this makes swapping implementations trivial. `AuthRepository` and `OrdersRepository` are concrete classes that directly instantiate their fake dependencies.

### 1.4 Providers

| Provider | State Type | Depends On | Data Source |
|---|---|---|---|
| `authStateProvider` | `AuthState` (contains `UserModel?`) | `AuthRepository` | FakeAuthService |
| `productRepositoryProvider` | `ProductRepository` | - | `LocalProductRepository` |
| `allProductsProvider` | `List<ProductModel>` | `productRepositoryProvider` | Static list |
| `featuredProductsProvider` | `List<ProductModel>` | `productRepositoryProvider` | Static list |
| `categoryProductsProvider` | `List<ProductModel>` (family) | `productRepositoryProvider` | Static list |
| `productByIdProvider` | `ProductModel?` (family) | `productRepositoryProvider` | Static list |
| `cartProvider` | `List<CartItemModel>` | `CartStorage` | SharedPreferences |
| `cartSubtotalProvider` | `double` | `cartProvider` | Derived |
| `cartTotalProvider` | `double` | `cartSubtotalProvider` | Derived |
| `wishlistProvider` | `List<ProductModel>` | SharedPreferences | SharedPreferences + static list |
| `wishlistCountProvider` | `int` | `wishlistProvider` | Derived |
| `ordersProvider` | `List<OrderModel>` | `OrdersRepository` | SharedPreferences |
| `ordersCountProvider` | `int` | `ordersProvider` | Derived |
| `addressProvider` | `List<AddressModel>` | SharedPreferences | SharedPreferences |
| `defaultAddressProvider` | `AddressModel?` | `addressProvider` | Derived |
| `addressCountProvider` | `int` | `addressProvider` | Derived |
| `paymentCardProvider` | `List<PaymentCardModel>` | `PaymentCardStorage` | SharedPreferences |
| `defaultPaymentCardProvider` | `PaymentCardModel?` | `paymentCardProvider` | Derived |
| `paymentCardCountProvider` | `int` | `paymentCardProvider` | Derived |
| `searchProvider` | `SearchState` | `SearchRepository`, SharedPreferences | Fake + SharedPreferences |
| `editProfileProvider` | `EditProfileState` | `authStateProvider` | Derived |

### 1.5 Models

All models are plain Dart classes with `toJson()` / `fromJson()` serialization:

| Model | File | Fields |
|---|---|---|
| `UserModel` | `user_model.dart` | id, fullName, email, phoneNumber, profileImage?, memberSince, dateOfBirth?, gender?, country? |
| `ProductModel` | `product_model.dart` | id, image, name, price, description, category, collection, keywords, featured, sizes |
| `CategoryModel` | `category_model.dart` | id, name, icon (IconData) |
| `CartItemModel` | `cart_item_model.dart` | productId, productName, productImage, selectedColor?, selectedSize, quantity, unitPrice |
| `OrderModel` | `order_model.dart` | orderId, orderDate, items, totalPrice, paymentMethod, deliveryAddress, status |
| `OrderItemModel` | `order_item_model.dart` | productId, productName, productImage, selectedColor?, selectedSize, quantity, unitPrice |
| `AddressModel` | `address_model.dart` | id, street, apartment?, city, state, country, zip, label, isDefault |
| `PaymentCardModel` | `payment_card_model.dart` | id, cardHolderName, last4Digits, expiryMonth, expiryYear, cardBrand, isDefault, createdAt |
| `CoverModel` | `cover_model.dart` | image, name |
| `SearchResultModel` | `search_result_model.dart` | products, query |

### 1.6 Fake Data Inventory

| Fake Data | Location | Type | Persistence |
|---|---|---|---|
| 18 products | `ProductModel.products` (static list) | Hardcoded in model | None (in-memory) |
| 7 categories | `CategoryModel.categories` (static list) | Hardcoded in model | None (in-memory) |
| 3 covers | `CoverModel.covers` (static list) | Hardcoded in model | None (in-memory) |
| User accounts | `FakeAuthService._getStoredUsers()` | SharedPreferences | Local only |
| Current session | `FakeAuthService._saveCurrentUser()` | SharedPreferences | Local only |
| Cart items | `CartStorage` | SharedPreferences | Local only |
| Orders | `OrdersStorage` | SharedPreferences | Local only |
| Wishlist IDs | `WishlistNotifier._load()` | SharedPreferences | Local only |
| Addresses | `AddressNotifier._load()` | SharedPreferences | Local only |
| Payment cards | `PaymentCardStorage` | SharedPreferences | Local only |
| Recent searches | `SearchNotifier._loadRecentSearchesFromPrefs()` | SharedPreferences | Local only |

### 1.7 Duplicated Logic and Items That Should Stay Unchanged

- **Core theme system** (`app_theme.dart`, `app_colors.dart`, `theme_provider.dart`, `theme_storage.dart`) - purely UI, no backend dependency.
- **Router** (`app_router.dart`) - will not change; product navigation currently passes `ProductModel` objects directly. Once Supabase is live, products will still be `ProductModel` objects.
- **Core widgets** (`custom_appbar.dart`, `custom_button.dart`, `custom_text_field.dart`, etc.) - UI only.
- **Form validators** (`form_validators.dart`) - pure logic, no backend dependency.
- **Utility functions** (`date_formatter.dart`, `haptic_utils.dart`, `card_utils.dart`, `id_generator.dart`, `list_extensions.dart`) - pure logic.
- **Skeletons** - UI loading placeholders, no data dependency.
- **Splash page** currently reads `fake_auth_remember_me` and `fake_auth_is_logged_in` from SharedPreferences. This will need to change to use Supabase session persistence.
- **`CartItemModel.generateProductId()`** - this generates composite IDs from name+image+size. After migration, Supabase will provide real UUIDs. The cart deduplication logic needs to adapt.

---

## 2. Future Backend Architecture

### 2.1 Overview

The application will migrate to **Supabase** as the complete backend, providing:

- **Authentication** - Supabase Auth (email/password)
- **Database** - Supabase PostgreSQL with Row Level Security
- **File Storage** - Supabase Storage (profile images, product images)
- **Realtime** - Supabase Realtime (future: order status updates, notifications)

### 2.2 Authentication

**Why it exists:** Every user needs a secure, unique identity. Supabase Auth handles signup, login, session management, and token refresh automatically.

**How it works:**

- Supabase Auth manages `auth.users` internally (email, password, session tokens).
- A `profiles` table stores the public user data (name, phone, avatar, etc.) linked to `auth.users.id`.
- On signup, a database trigger automatically creates a `profiles` row.
- The Flutter app uses `supabase_flutter` SDK for `signUp()`, `signInWithPassword()`, `signOut()`, and `onAuthStateChange`.
- Session persistence is handled by Supabase SDK automatically (replaces SharedPreferences-based session storage).

**Current to Future mapping:**

| Current | Future |
|---|---|
| `FakeAuthService.signUp()` | `Supabase.instance.client.auth.signUp()` + insert into `profiles` |
| `FakeAuthService.login()` | `Supabase.instance.client.auth.signInWithPassword()` |
| `FakeAuthService.logout()` | `Supabase.instance.client.auth.signOut()` |
| `FakeAuthService.getCurrentUser()` | `Supabase.instance.client.auth.currentUser` + join with `profiles` |
| `FakeAuthService.updateProfile()` | Update `profiles` table via Supabase client |
| SharedPreferences session | Supabase SDK built-in session persistence |

### 2.3 Profiles

**Why it exists:** Stores public-facing user data that does not belong in the auth system. Separates identity (auth) from display (profile).

**Table purpose:**

- `id` - references `auth.users.id` (one-to-one)
- `full_name`, `phone_number`, `profile_image`, `date_of_birth`, `gender`, `country`
- `member_since` - set on creation
- RLS ensures users can only read/update their own profile

### 2.4 Categories

**Why it exists:** Groups products into browsable collections. Currently hardcoded as 7 static items. Supabase will serve them dynamically.

**Table purpose:**

- `id` - UUID primary key
- `name` - display name (Men, Women, Kids, Shoes, Accessories, Brands, Sale)
- `icon_name` - string identifier for the icon (e.g., "male", "female") since `IconData` cannot be stored in a database
- `sort_order` - controls display ordering
- Admin-editable in the future

### 2.5 Products

**Why it exists:** The core catalog entity. Currently 18 hardcoded products. Supabase will serve products dynamically with full CRUD capability.

**Table purpose:**

- `id` - UUID primary key
- `name`, `description`, `price`, `category_id` (FK), `collection`, `featured`
- `created_at`, `updated_at` - timestamps
- Separated from images and sizes for normalization

### 2.6 Product Images

**Why it exists:** A product can have multiple images. Currently each product stores a single `image` string (local asset path). Supabase will support multiple network-hosted images per product.

**Table purpose:**

- `id` - UUID primary key
- `product_id` - FK to products
- `image_url` - Supabase Storage URL or external URL
- `sort_order` - controls display ordering
- `is_primary` - identifies the main product image

### 2.7 Product Sizes

**Why it exists:** Products have multiple available sizes. Currently stored as `List<String>` in `ProductModel.sizes`. Supabase will normalize this into a proper table.

**Table purpose:**

- `id` - UUID primary key
- `product_id` - FK to products
- `size_label` - the size string (S, M, L, XL, XXL)
- `stock_quantity` - enables inventory tracking in the future
- `is_available` - allows disabling specific sizes

### 2.8 Cart

**Why it exists:** Represents a user's shopping session. Currently cart items are stored in SharedPreferences with no user association. Supabase will link carts to authenticated users.

**Table purpose:**

- `id` - UUID primary key
- `user_id` - FK to auth.users (one cart per user)
- `created_at`, `updated_at` - timestamps
- A user has at most one active cart

**Future consideration:** Guest carts can be merged into the user cart upon login.

### 2.9 Cart Items

**Why it exists:** Individual line items within a cart. Currently stored as a flat list in SharedPreferences. Supabase will normalize this with proper relationships.

**Table purpose:**

- `id` - UUID primary key
- `cart_id` - FK to carts
- `product_id` - FK to products
- `selected_size`, `selected_color` - variant selection
- `quantity` - how many of this item
- `unit_price` - snapshot of price at time of add (prevents price drift)
- Unique constraint on `(cart_id, product_id, selected_size, selected_color)`

### 2.10 Wishlist

**Why it exists:** Allows users to save products for later. Currently stores product IDs in SharedPreferences. Supabase will persist this per-user.

**Table purpose:**

- `id` - UUID primary key
- `user_id` - FK to auth.users
- `product_id` - FK to products
- `created_at` - when it was wishlisted
- Unique constraint on `(user_id, product_id)` - prevents duplicates
- One-to-many: one user to many wishlist items

### 2.11 Orders

**Why it exists:** Records completed purchases. Currently stored in SharedPreferences. Supabase will persist orders server-side with full audit trail.

**Table purpose:**

- `id` - UUID primary key
- `user_id` - FK to auth.users
- `total_price` - final order total
- `payment_method` - text or reference
- `delivery_address_snapshot` - denormalized address text at time of order
- `status` - enum: processing, shipped, delivered, cancelled
- `created_at`, `updated_at` - timestamps
- One-to-many: one user to many orders

### 2.12 Order Items

**Why it exists:** Individual line items within an order. Denormalizes product data at time of purchase for historical accuracy.

**Table purpose:**

- `id` - UUID primary key
- `order_id` - FK to orders
- `product_id` - FK to products (reference, product may be deleted later)
- `product_name`, `product_image` - snapshot at time of order
- `selected_size`, `selected_color` - variant selection
- `quantity`, `unit_price` - line item details
- One-to-many: one order to many order items

### 2.13 Addresses

**Why it exists:** Stores user delivery addresses. Currently in SharedPreferences. Supabase will persist per-user with proper RLS.

**Table purpose:**

- `id` - UUID primary key
- `user_id` - FK to auth.users
- `street`, `apartment?`, `city`, `state`, `country`, `zip`
- `label` - Home, Work, etc.
- `is_default` - marks the default address
- One-to-many: one user to many addresses

### 2.14 Coupons (Optional / Future)

**Why it exists:** Promotional discount codes. Not currently in the app. This table is prepared for future checkout integration.

**Table purpose:**

- `id` - UUID primary key
- `code` - unique promo code string
- `discount_percent`, `discount_amount` - one or both
- `min_order_value` - minimum cart total to apply
- `max_uses`, `used_count` - usage limits
- `valid_from`, `valid_until` - date range
- `is_active` - enable/disable toggle

### 2.15 Notifications (Future)

**Why it exists:** Push or in-app notifications for order status, promotions, etc. Not currently in the app. Prepared for future implementation.

**Table purpose:**

- `id` - UUID primary key
- `user_id` - FK to auth.users
- `title`, `body` - notification content
- `type` - order_update, promotion, system
- `is_read` - read/unread status
- `created_at` - timestamp
- One-to-many: one user to many notifications

---

## 3. Database Relationships

### 3.1 Relationship Diagram

```
auth.users (Supabase Auth)
    |
    | 1:1
    v
profiles
    |
    | 1:N
    +------------------------------+
    |                              |
    v                              v
carts                         wishlist_items
    |                              |
    | 1:N                          | FK
    v                              v
cart_items                     products
    |                              |
    | FK                           +------- 1:N -------> product_images
    |                              |
    |                              +------- 1:N -------> product_sizes
    |                              |
    |                              | FK
    v                              v
orders ------------------------> order_items
    |
    | 1:N
    v
addresses
```

### 3.2 Detailed Relationships

#### User to Profile (One-to-One)

```
auth.users.id ------- profiles.user_id
```

- Every authenticated user has exactly one profile row.
- The profile is created automatically via a database trigger on signup.
- The profile stores public-facing data; auth.users stores credentials.

#### Category to Products (One-to-Many)

```
categories.id ------- products.category_id
```

- One category contains many products (e.g., "Men" has 100 products).
- One product belongs to exactly one category.
- Deleting a category should be restricted if products reference it (ON DELETE RESTRICT or SET NULL).

#### Product to Product Images (One-to-Many)

```
products.id ------- product_images.product_id
```

- One product can have multiple images (gallery).
- Each image has a sort order and an `is_primary` flag.
- Deleting a product cascades to delete its images (ON DELETE CASCADE).

#### Product to Product Sizes (One-to-Many)

```
products.id ------- product_sizes.product_id
```

- One product has multiple size options.
- Each size entry tracks availability and stock.
- Deleting a product cascades to delete its sizes (ON DELETE CASCADE).

#### User to Cart (One-to-One)

```
auth.users.id ------- carts.user_id (unique)
```

- Each user has at most one active cart.
- A cart is created when the user first adds an item.

#### Cart to Cart Items (One-to-Many)

```
carts.id ------- cart_items.cart_id
```

- One cart contains many line items.
- Each cart item references a product and stores variant selection.
- Deleting a cart cascades to delete its items (ON DELETE CASCADE).

#### User to Wishlist Items (One-to-Many)

```
auth.users.id ------- wishlist_items.user_id
```

- One user can wish-list many products.
- Each wishlist entry links to one product.
- Unique constraint on `(user_id, product_id)` prevents duplicates.

#### User to Orders (One-to-Many)

```
auth.users.id ------- orders.user_id
```

- One user can place many orders.
- Each order belongs to exactly one user.

#### Order to Order Items (One-to-Many)

```
orders.id ------- order_items.order_id
```

- One order contains many line items.
- Each order item stores a snapshot of product data at time of purchase.
- Deleting an order cascades to delete its items (ON DELETE CASCADE).

#### User to Addresses (One-to-Many)

```
auth.users.id ------- addresses.user_id
```

- One user can have many saved addresses.
- One address is marked as default.
- Deleting a user should cascade to delete their addresses (ON DELETE CASCADE).

### 3.3 Relationship Summary Table

| Relationship | Type | Parent | Child | FK Column | On Delete |
|---|---|---|---|---|---|
| User to Profile | One-to-One | auth.users | profiles | user_id | CASCADE |
| Category to Products | One-to-Many | categories | products | category_id | RESTRICT |
| Product to Images | One-to-Many | products | product_images | product_id | CASCADE |
| Product to Sizes | One-to-Many | products | product_sizes | product_id | CASCADE |
| User to Cart | One-to-One | auth.users | carts | user_id | CASCADE |
| Cart to Cart Items | One-to-Many | carts | cart_items | cart_id | CASCADE |
| User to Wishlist | One-to-Many | auth.users | wishlist_items | user_id | CASCADE |
| User to Orders | One-to-Many | auth.users | orders | user_id | CASCADE |
| Order to Order Items | One-to-Many | orders | order_items | order_id | CASCADE |
| User to Addresses | One-to-Many | auth.users | addresses | user_id | CASCADE |

---

## 4. Fake Data Migration Strategy

### 4.1 Current Fake Data Inventory

| Component | File | Fake Source | Migration Target |
|---|---|---|---|
| `FakeAuthService` | `services/fake_auth_service.dart` | SharedPreferences | Supabase Auth + `profiles` table |
| `AuthRepository` | `repositories/auth_repository.dart` | `FakeAuthService` | Supabase auth + profile repository |
| `LocalProductRepository` | `repositories/product/local_product_repository.dart` | `ProductModel.products` static list | Supabase `products` table |
| `LocalSearchRepository` | `repositories/search/local_search_repository.dart` | `ProductModel.products` static list | Supabase full-text search |
| `OrdersRepository` | `repositories/orders_repository.dart` | `OrdersStorage` (SharedPreferences) | Supabase `orders` + `order_items` tables |
| `CartStorage` | `services/cart_storage.dart` | SharedPreferences | Supabase `carts` + `cart_items` tables |
| `CartNotifier` | `providers/cart_provider.dart` | `CartStorage` | Supabase cart repository |
| `WishlistNotifier` | `providers/wishlist_provider.dart` | SharedPreferences + static list | Supabase `wishlist_items` table |
| `AddressNotifier` | `providers/address_provider.dart` | SharedPreferences | Supabase `addresses` table |
| `PaymentCardStorage` | `services/payment_card_storage.dart` | SharedPreferences | Supabase or third-party payment processor |
| `ProductModel.products` | `models/product_model.dart` (static list) | Hardcoded | Removed (data from Supabase) |
| `CategoryModel.categories` | `models/category_model.dart` (static list) | Hardcoded | Removed (data from Supabase) |
| `CoverModel.covers` | `models/cover_model.dart` (static list) | Hardcoded | Optional: Supabase `covers` table or keep static |
| `SplashPage` | `splash.dart` | SharedPreferences keys | Supabase session check |

### 4.2 Safest Migration Strategy

The golden rule: **the UI should never break during migration**.

#### Principle 1: Abstract Before Replace

Every repository that is currently concrete (`AuthRepository`, `OrdersRepository`) must first be converted to an **abstract interface** with a fake implementation, before a Supabase implementation is created. This mirrors the existing pattern already used by `ProductRepository` and `SearchRepository`.

#### Principle 2: Feature Flags via Provider Override

Use Riverpod's provider override mechanism to switch between fake and real implementations:

```dart
// During migration, override the provider:
productRepositoryProvider.overrideWithValue(SupabaseProductRepository())
```

This allows gradual migration - one feature at a time - without touching UI code.

#### Principle 3: Never Modify UI During Backend Migration

The presentation layer (pages, widgets) watches providers. As long as providers expose the same state types (`List<ProductModel>`, `AuthState`, etc.), the UI remains untouched.

#### Principle 4: Keep Fake Data Available

Do not delete fake implementations until the Supabase implementation is fully tested. Keep them as fallback for development/testing.

### 4.3 Migration Safety Matrix

| Step | Action | Risk Level | UI Impact |
|---|---|---|---|
| 1 | Create abstract interfaces for all repositories | None | None |
| 2 | Create Supabase data sources | None | None |
| 3 | Create Supabase repository implementations | None | None |
| 4 | Override providers one at a time | Low | None (same state types) |
| 5 | Test each feature independently | None | None |
| 6 | Remove old fake implementations | Low | None (after full migration) |

---

## 5. Feature-by-Feature Migration Plan

### 5.1 Recommended Migration Order

```
1. Authentication
       |
2. Products (Catalog)
       |
3. Categories
       |
4. Cart
       |
5. Wishlist
       |
6. Orders
       |
7. Profile and Addresses
       |
8. Search (Supabase full-text)
       |
9. Payment Cards (optional)
       |
10. Coupons (future)
       |
11. Notifications (future)
```

### 5.2 Why This Order Is the Safest

#### Phase 1: Authentication

**Why first:** Everything else depends on user identity. Cart, wishlist, orders, and addresses all need a `user_id`. Without auth, Supabase RLS policies cannot function.

**Dependencies:** None.

**What changes:**
- `FakeAuthService` to Supabase Auth
- `AuthRepository` to abstract interface + Supabase implementation
- `splash.dart` to check Supabase session instead of SharedPreferences keys
- `authStateProvider` keeps same state type, different data source

**What stays the same:**
- All auth pages (`login_page.dart`, `signup_page.dart`, `auth_page.dart`)
- `AuthState` class definition
- `AuthNotifier` class (only its repository dependency changes)
- `EditProfileProvider`

#### Phase 2: Products (Catalog)

**Why second:** Products are read-only for the user and do not require authentication. This is the simplest data migration - replace static list with database query.

**Dependencies:** None (products are public).

**What changes:**
- `LocalProductRepository` to Supabase implementation (new class)
- `productRepositoryProvider` to override to return Supabase implementation
- Static `ProductModel.products` list is no longer the source of truth
- Product images from Supabase Storage URLs instead of asset paths

**What stays the same:**
- `ProductRepository` abstract interface
- `ProductModel` class definition (field names may need minor additions)
- `ProductDetailPage`, `ProductListingPage`, `ProductGridCard`
- `allProductsProvider`, `featuredProductsProvider`, `categoryProductsProvider`, `productByIdProvider`
- Home page, category pages

#### Phase 3: Categories

**Why third:** Categories are also read-only and simple. They support the product catalog browsing experience.

**Dependencies:** None (categories are public).

**What changes:**
- `CategoryModel.categories` static list to Supabase query
- `CategoryModel.icon` (IconData) stored as string name, mapped back in code

**What stays the same:**
- `CategoryModel` class (minor field adjustment: `icon_name` string instead of `IconData`)
- Categories page
- Category filtering in product listing

#### Phase 4: Cart

**Why fourth:** Cart requires authentication (to persist per-user). It is the first user-specific feature to migrate.

**Dependencies:** Phase 1 (Authentication).

**What changes:**
- `CartStorage` (SharedPreferences) to Supabase `carts` + `cart_items` tables
- `CartNotifier` uses Supabase repository instead of local storage
- Cart state becomes async (loading from network)

**What stays the same:**
- `CartItemModel` class definition
- `cartProvider`, `cartSubtotalProvider`, `cartTotalProvider`
- `CartPage`, `CartItemCard`
- Add-to-cart logic in `ProductDetailPage`

#### Phase 5: Wishlist

**Why fifth:** Simple user-specific feature with minimal complexity.

**Dependencies:** Phase 1 (Authentication), Phase 2 (Products - to resolve product details).

**What changes:**
- SharedPreferences IDs to Supabase `wishlist_items` table
- `WishlistNotifier` uses Supabase repository
- Wishlist lookup joins with products table

**What stays the same:**
- `wishlistProvider`, `wishlistCountProvider`
- `WishlistPage`, `WishlistItemCard`
- Toggle/add/remove logic

#### Phase 6: Orders

**Why sixth:** Orders depend on cart (source of order items), auth (user_id), and products (pricing).

**Dependencies:** Phase 1 (Authentication), Phase 4 (Cart), Phase 2 (Products).

**What changes:**
- `OrdersStorage` (SharedPreferences) to Supabase `orders` + `order_items` tables
- `OrdersRepository` to abstract interface + Supabase implementation
- Order creation inserts into both `orders` and `order_items` tables

**What stays the same:**
- `OrderModel`, `OrderItemModel` class definitions
- `ordersProvider`, `ordersCountProvider`
- `OrdersPage`, `OrderDetailsPage`, `OrderCard`
- `OrderItemModel.fromCartItem()` factory

#### Phase 7: Profile and Addresses

**Why seventh:** Profile data is already partially handled by auth. Addresses are simple but require auth.

**Dependencies:** Phase 1 (Authentication).

**What changes:**
- Profile updates to Supabase `profiles` table
- Address SharedPreferences to Supabase `addresses` table
- Profile image to Supabase Storage

**What stays the same:**
- `UserModel`, `AddressModel` class definitions
- `addressProvider`, `defaultAddressProvider`, `addressCountProvider`
- `ProfilePage`, `EditProfilePage`, `AddressesPage`
- `EditProfileProvider`

#### Phase 8: Search

**Why later:** Search can initially continue using client-side filtering on Supabase-fetched products. Full-text search is an optimization.

**Dependencies:** Phase 2 (Products).

**What changes:**
- `LocalSearchRepository` to Supabase full-text search (using `pg_trgm` or similar)
- Search queries hit the database instead of filtering in memory

**What stays the same:**
- `SearchRepository` abstract interface
- `searchProvider`, `SearchState`
- `SearchScreen`, search widgets

#### Phase 9: Payment Cards

**Why optional:** Real payment processing requires a payment gateway (Stripe, etc.). Storing card details directly is a PCI compliance risk. This may be deferred or replaced with a third-party integration.

---

## 6. Repository Strategy

### 6.1 Current Pattern

```
UI (Pages/Widgets)
    |
    | ref.watch() / ref.read()
    v
Provider (StateNotifier / Provider)
    |
    | calls repository methods
    v
Repository (Concrete class)
    |
    | instantiates directly
    v
Fake Service / Local Storage
    |
    v
SharedPreferences / Static List
```

**Problem:** Some repositories are concrete and directly instantiate their fake dependencies:
- `AuthRepository()` creates `FakeAuthService()` internally
- `OrdersRepository()` calls `OrdersStorage` directly
- `CartNotifier()` calls `CartStorage` directly
- `WishlistNotifier()` reads `SharedPreferences` directly
- `AddressNotifier()` reads `SharedPreferences` directly

### 6.2 Future Pattern

```
UI (Pages/Widgets)
    |
    | ref.watch() / ref.read()
    v
Provider (StateNotifier / Provider)  <--- SAME interface
    |
    | calls repository methods
    v
Abstract Repository Interface  <--- NEW abstraction layer
    |
    +---> LocalProductRepository (fake, for testing)
    |
    +---> SupabaseProductRepository (real)
              |
              v
         Supabase Remote Data Source
              |
              v
         Supabase Backend (Auth, Database, Storage)
```

### 6.3 Why the UI Should Never Communicate Directly with Supabase

1. **Separation of concerns:** UI handles presentation logic, not data fetching.
2. **Testability:** Repositories can be mocked for unit and widget tests.
3. **Swappability:** Backend can change (Supabase to Firebase to custom API) without touching UI.
4. **Single responsibility:** Each layer has one job.
5. **State management:** Riverpod providers mediate between UI and data, handling loading/error states consistently.
6. **Security:** Supabase credentials and client initialization stay in the data layer, not scattered across widgets.

### 6.4 Migration Path for Each Repository

| Current Repository | Step 1: Create Interface | Step 2: Keep Fake Impl | Step 3: Create Supabase Impl | Step 4: Override Provider |
|---|---|---|---|---|
| `AuthRepository` (concrete) | Create `IAuthRepository` | `FakeAuthRepository` | `SupabaseAuthRepository` | Override `authRepositoryProvider` |
| `LocalProductRepository` | Already has interface | Already exists | `SupabaseProductRepository` | Override `productRepositoryProvider` |
| `LocalSearchRepository` | Already has interface | Already exists | `SupabaseSearchRepository` | Override `searchRepositoryProvider` |
| `OrdersRepository` (concrete) | Create `IOrdersRepository` | `FakeOrdersRepository` | `SupabaseOrdersRepository` | Override `ordersRepositoryProvider` |
| `CartNotifier` (direct storage) | Create `CartRepository` | `LocalCartRepository` | `SupabaseCartRepository` | Override `cartRepositoryProvider` |
| `WishlistNotifier` (direct storage) | Create `WishlistRepository` | `LocalWishlistRepository` | `SupabaseWishlistRepository` | Override `wishlistRepositoryProvider` |
| `AddressNotifier` (direct storage) | Create `AddressRepository` | `LocalAddressRepository` | `SupabaseAddressRepository` | Override `addressRepositoryProvider` |

---

## 7. Riverpod Providers Strategy

### 7.1 Providers That Remain Completely Unchanged

These providers have zero backend dependency and require no modification:

| Provider | Reason |
|---|---|
| `themeProvider` | UI-only theme state |
| `searchQueryProvider` | UI state (search text input) |
| `searchContextProvider` | UI state (search context type) |
| `highlightedQueryProvider` | Derived from `searchProvider`, pure UI |
| `cartSubtotalProvider` | Derived from `cartProvider`, pure computation |
| `cartTotalProvider` | Derived from `cartSubtotalProvider`, pure computation |
| `wishlistCountProvider` | Derived from `wishlistProvider`, pure computation |
| `ordersCountProvider` | Derived from `ordersProvider`, pure computation |
| `addressCountProvider` | Derived from `addressProvider`, pure computation |
| `paymentCardCountProvider` | Derived from `paymentCardProvider`, pure computation |
| `defaultAddressProvider` | Derived from `addressProvider`, pure computation |
| `defaultPaymentCardProvider` | Derived from `paymentCardProvider`, pure computation |

### 7.2 Providers That Change Only Their Data Source

These providers keep the **same state type** and **same public API** but switch their underlying data source:

| Provider | Current Source | Future Source | UI Impact |
|---|---|---|---|
| `authStateProvider` | `AuthRepository` to `FakeAuthService` | `AuthRepository` to Supabase Auth | None (same `AuthState` type) |
| `productRepositoryProvider` | Returns `LocalProductRepository` | Returns `SupabaseProductRepository` | None (same `ProductRepository` interface) |
| `allProductsProvider` | Calls `repo.getAllProducts()` (sync) | Calls `repo.getAllProducts()` (async) | **Minor**: providers become `FutureProvider` or `AsyncNotifier` |
| `featuredProductsProvider` | Calls `repo.getFeaturedProducts()` (sync) | Calls `repo.getFeaturedProducts()` (async) | **Minor**: becomes async |
| `categoryProductsProvider` | Calls `repo.getProductsByCategory()` (sync) | Calls `repo.getProductsByCategory()` (async) | **Minor**: becomes async |
| `productByIdProvider` | Calls `repo.getProductById()` (sync) | Calls `repo.getProductById()` (async) | **Minor**: becomes async |
| `cartProvider` | `CartNotifier` to `CartStorage` | `CartNotifier` to Supabase cart repository | None (same `List<CartItemModel>` state) |
| `wishlistProvider` | `WishlistNotifier` to SharedPreferences | `WishlistNotifier` to Supabase wishlist repository | None (same `List<ProductModel>` state) |
| `ordersProvider` | `OrdersNotifier` to `OrdersRepository` to `OrdersStorage` | `OrdersNotifier` to Supabase orders repository | None (same `List<OrderModel>` state) |
| `addressProvider` | `AddressNotifier` to SharedPreferences | `AddressNotifier` to Supabase address repository | None (same `List<AddressModel>` state) |
| `paymentCardProvider` | `PaymentCardNotifier` to `PaymentCardStorage` | `PaymentCardNotifier` to Supabase or third-party | None (same state type) |
| `searchProvider` | `SearchNotifier` to `LocalSearchRepository` | `SearchNotifier` to Supabase search repository | None (same `SearchState` type) |

### 7.3 Providers That Need Architectural Changes

| Provider | Change Required | Reason |
|---|---|---|
| `allProductsProvider` | `Provider` to `FutureProvider` or `AsyncNotifierProvider` | Supabase queries are async |
| `featuredProductsProvider` | `Provider` to `FutureProvider` | Supabase queries are async |
| `categoryProductsProvider` | `Provider.family` to `FutureProvider.family` | Supabase queries are async |
| `productByIdProvider` | `Provider.family` to `FutureProvider.family` | Supabase queries are async |

**Key insight:** The transition from sync to async providers is the biggest UI-impacting change. Pages that currently do `ref.watch(featuredProductsProvider)` (synchronous) will need to handle the `AsyncValue<List<ProductModel>>` wrapper (loading/error/data states). However, the app **already uses skeleton loading patterns** everywhere, so this aligns with the existing UX.

### 7.4 Goal: Minimize UI Changes

- All state types remain the same (`UserModel`, `ProductModel`, `CartItemModel`, etc.).
- All provider names remain the same.
- The only UI changes: handling `AsyncValue` for product-related providers (if switched to `FutureProvider`).
- All derived/computed providers remain unchanged.
- All widget code remains unchanged.

---

## 8. Data Models

### 8.1 Current Models (Existing)

These models already exist in `lib/data/models/` and will be retained with minor modifications:

#### UserModel

```
UserModel
  id: String
  fullName: String
  email: String
  phoneNumber: String
  profileImage: String?
  memberSince: DateTime
  dateOfBirth: DateTime?
  gender: String?
  country: String?
```

**Migration notes:**
- `id` will be the Supabase `auth.users.id` (UUID format, not timestamp).
- `toJson()` / `fromJson()` remain for API serialization.
- `copyWith()`, computed getters (`firstName`, `lastName`) remain unchanged.

#### ProductModel

```
ProductModel
  id: String
  name: String
  image: String          <-- will become primary image URL
  price: double
  description: String
  category: String       <-- will become category_id or category name
  collection: String
  keywords: List<String>
  featured: bool
  sizes: List<String>    <-- will be fetched separately or joined
```

**Migration notes:**
- Static `ProductModel.products` list will be removed.
- `image` will hold a network URL instead of an asset path.
- `sizes` may remain as a joined field or be fetched from `product_sizes` table.
- Consider adding `images: List<String>` for multiple images.

#### CategoryModel

```
CategoryModel
  id: String
  name: String
  icon: IconData         <-- will become iconName: String
```

**Migration notes:**
- `icon` (`IconData`) cannot be stored in a database. Replace with `iconName: String` and map back to `IconData` in code.
- Static `CategoryModel.categories` list will be removed.

#### CartItemModel

```
CartItemModel
  productId: String
  productName: String
  productImage: String
  selectedColor: String?
  selectedSize: String
  quantity: int
  unitPrice: double
```

**Migration notes:**
- `productId` will be the Supabase product UUID.
- `productName` and `productImage` are denormalized snapshots (keep for order history).
- `generateProductId()` static method will be deprecated (Supabase provides UUIDs).

#### OrderModel

```
OrderModel
  orderId: String
  orderDate: DateTime
  items: List<OrderItemModel>
  totalPrice: double
  paymentMethod: String
  deliveryAddress: String
  status: OrderStatus
```

**Migration notes:**
- `orderId` will be the Supabase order UUID.
- `items` will be fetched from `order_items` table (joined or separate query).
- `OrderStatus` enum remains unchanged.

#### OrderItemModel

```
OrderItemModel
  productId: String
  productName: String
  productImage: String
  selectedColor: String?
  selectedSize: String
  quantity: int
  unitPrice: double
```

**Migration notes:**
- All fields remain the same. Denormalized product data ensures historical accuracy.

#### AddressModel

```
AddressModel
  id: String
  street: String
  apartment: String?
  city: String
  state: String
  country: String
  zip: String
  label: String
  isDefault: bool
```

**Migration notes:**
- `id` will be the Supabase UUID.
- `encodeList()` / `decodeList()` methods can be removed (no longer stored as JSON string).
- `fullAddress` computed getter remains.

#### PaymentCardModel

```
PaymentCardModel
  id: String
  cardHolderName: String
  last4Digits: String
  expiryMonth: String
  expiryYear: String
  cardBrand: String
  isDefault: bool
  createdAt: DateTime
```

**Migration notes:**
- Consider replacing with a third-party payment processor (Stripe, etc.) for PCI compliance.
- If kept, store in Supabase with encrypted sensitive fields.

#### CoverModel

```
CoverModel
  image: String
  name: String
```

**Migration notes:**
- Currently 3 hardcoded covers. Can remain static or be moved to Supabase for admin management.

#### SearchResultModel

```
SearchResultModel
  products: List<ProductModel>
  query: String
```

**Migration notes:**
- Remains as a UI-layer model. The search logic moves to Supabase full-text search.

### 8.2 New Models (To Be Created)

#### ProductImage

```
ProductImage
  id: String (UUID)
  productId: String (FK)
  imageUrl: String
  sortOrder: int
  isPrimary: bool
```

#### ProductSize

```
ProductSize
  id: String (UUID)
  productId: String (FK)
  sizeLabel: String
  stockQuantity: int
  isAvailable: bool
```

#### Cart (User Cart)

```
Cart
  id: String (UUID)
  userId: String (FK)
  createdAt: DateTime
  updatedAt: DateTime
```

#### WishlistItem

```
WishlistItem
  id: String (UUID)
  userId: String (FK)
  productId: String (FK)
  createdAt: DateTime
```

#### Coupon (Future)

```
Coupon
  id: String (UUID)
  code: String
  discountPercent: double?
  discountAmount: double?
  minOrderValue: double?
  maxUses: int?
  usedCount: int
  validFrom: DateTime
  validUntil: DateTime
  isActive: bool
```

#### Notification (Future)

```
Notification
  id: String (UUID)
  userId: String (FK)
  title: String
  body: String
  type: String
  isRead: bool
  createdAt: DateTime
```

### 8.3 Model Relationships Summary

```
UserModel ---1:1---> ProfileModel (embedded in UserModel or separate)
CategoryModel ---1:N---> ProductModel
ProductModel ---1:N---> ProductImageModel
ProductModel ---1:N---> ProductSizeModel
UserModel ---1:1---> CartModel
CartModel ---1:N---> CartItemModel
CartItemModel ---N:1---> ProductModel
UserModel ---1:N---> WishlistItemModel
WishlistItemModel ---N:1---> ProductModel
UserModel ---1:N---> OrderModel
OrderModel ---1:N---> OrderItemModel
OrderItemModel ---N:1---> ProductModel
UserModel ---1:N---> AddressModel
```

---

## 9. Row Level Security Plan

### 9.1 Core Principle

> **Every user must only access their own data. No user can read, modify, or delete another user's data.**

Supabase RLS policies enforce this at the database level, making it impossible to bypass even if the client code has bugs.

### 9.2 Required Policies

#### profiles

| Operation | Policy | Condition |
|---|---|---|
| SELECT | `profiles_select_own` | `auth.uid() = user_id` |
| INSERT | `profiles_insert_own` | `auth.uid() = user_id` |
| UPDATE | `profiles_update_own` | `auth.uid() = user_id` |
| DELETE | `profiles_delete_own` | `auth.uid() = user_id` |

#### categories

| Operation | Policy | Condition |
|---|---|---|
| SELECT | `categories_select_public` | `true` (everyone can read) |
| INSERT | `categories_insert_admin` | Admin only (future) |
| UPDATE | `categories_update_admin` | Admin only (future) |
| DELETE | `categories_delete_admin` | Admin only (future) |

#### products

| Operation | Policy | Condition |
|---|---|---|
| SELECT | `products_select_public` | `true` (everyone can read) |
| INSERT | `products_insert_admin` | Admin only (future) |
| UPDATE | `products_update_admin` | Admin only (future) |
| DELETE | `products_delete_admin` | Admin only (future) |

#### product_images

| Operation | Policy | Condition |
|---|---|---|
| SELECT | `product_images_select_public` | `true` (everyone can read) |
| INSERT | `product_images_insert_admin` | Admin only |
| UPDATE | `product_images_update_admin` | Admin only |
| DELETE | `product_images_delete_admin` | Admin only |

#### product_sizes

| Operation | Policy | Condition |
|---|---|---|
| SELECT | `product_sizes_select_public` | `true` (everyone can read) |
| INSERT | `product_sizes_insert_admin` | Admin only |
| UPDATE | `product_sizes_update_admin` | Admin only |
| DELETE | `product_sizes_delete_admin` | Admin only |

#### carts

| Operation | Policy | Condition |
|---|---|---|
| SELECT | `carts_select_own` | `auth.uid() = user_id` |
| INSERT | `carts_insert_own` | `auth.uid() = user_id` |
| UPDATE | `carts_update_own` | `auth.uid() = user_id` |
| DELETE | `carts_delete_own` | `auth.uid() = user_id` |

#### cart_items

| Operation | Policy | Condition |
|---|---|---|
| SELECT | `cart_items_select_own` | ` EXISTS (SELECT 1 FROM carts WHERE carts.id = cart_items.cart_id AND carts.user_id = auth.uid())` |
| INSERT | `cart_items_insert_own` | Same join condition |
| UPDATE | `cart_items_update_own` | Same join condition |
| DELETE | `cart_items_delete_own` | Same join condition |

#### wishlist_items

| Operation | Policy | Condition |
|---|---|---|
| SELECT | `wishlist_select_own` | `auth.uid() = user_id` |
| INSERT | `wishlist_insert_own` | `auth.uid() = user_id` |
| UPDATE | `wishlist_update_own` | `auth.uid() = user_id` |
| DELETE | `wishlist_delete_own` | `auth.uid() = user_id` |

#### orders

| Operation | Policy | Condition |
|---|---|---|
| SELECT | `orders_select_own` | `auth.uid() = user_id` |
| INSERT | `orders_insert_own` | `auth.uid() = user_id` |
| UPDATE | `orders_update_own` | `auth.uid() = user_id` |
| DELETE | `orders_delete_own` | `auth.uid() = user_id` |

#### order_items

| Operation | Policy | Condition |
|---|---|---|
| SELECT | `order_items_select_own` | ` EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid())` |
| INSERT | `order_items_insert_own` | Same join condition |
| UPDATE | `order_items_update_own` | Same join condition |
| DELETE | `order_items_delete_own` | Same join condition |

#### addresses

| Operation | Policy | Condition |
|---|---|---|
| SELECT | `addresses_select_own` | `auth.uid() = user_id` |
| INSERT | `addresses_insert_own` | `auth.uid() = user_id` |
| UPDATE | `addresses_update_own` | `auth.uid() = user_id` |
| DELETE | `addresses_delete_own` | `auth.uid() = user_id` |

### 9.3 RLS Implementation Notes

- All policies use `auth.uid()` to get the current user's ID from the JWT.
- Public tables (categories, products, product_images, product_sizes) have `SELECT` open to everyone.
- User-specific tables (carts, cart_items, wishlist_items, orders, order_items, addresses, profiles) restrict all operations to the owning user.
- Admin operations (INSERT/UPDATE/DELETE on public tables) are deferred to a future admin panel and can use a custom claim or a separate admin role.
- RLS is enabled per table. Tables without policies will reject all operations by default when RLS is enabled.

---

## 10. Backend Folder Structure

### 10.1 Recommended Future Structure

```
lib/
  core/
    constants/
    router/
    theme/
    utils/
    widgets/
  data/
    models/                    # All data models (existing + new)
      user_model.dart
      product_model.dart
      category_model.dart
      cart_item_model.dart
      order_model.dart
      order_item_model.dart
      address_model.dart
      payment_card_model.dart
      cover_model.dart
      search_result_model.dart
      product_image_model.dart      # NEW
      product_size_model.dart       # NEW
      cart_model.dart               # NEW (user cart)
      wishlist_item_model.dart      # NEW
    repositories/              # Abstract interfaces
      auth_repository.dart          # Interface only
      product/
        product_repository.dart     # Interface (exists)
      search/
        search_repository.dart      # Interface (exists)
      orders_repository.dart        # Interface only
      cart_repository.dart          # NEW (interface)
      wishlist_repository.dart      # NEW (interface)
      address_repository.dart       # NEW (interface)
    remote/                    # NEW: Supabase implementations
      data_sources/
        supabase_auth_data_source.dart
        supabase_product_data_source.dart
        supabase_cart_data_source.dart
        supabase_wishlist_data_source.dart
        supabase_orders_data_source.dart
        supabase_address_data_source.dart
        supabase_search_data_source.dart
        supabase_storage_service.dart
      repositories/
        supabase_auth_repository.dart
        supabase_product_repository.dart
        supabase_cart_repository.dart
        supabase_wishlist_repository.dart
        supabase_orders_repository.dart
        supabase_address_repository.dart
        supabase_search_repository.dart
    local/                     # Existing fake implementations (kept for testing)
      repositories/
        fake_auth_repository.dart
        local_product_repository.dart
        local_search_repository.dart
        fake_orders_repository.dart
        local_cart_repository.dart
        local_wishlist_repository.dart
        local_address_repository.dart
    providers/                 # Riverpod providers (existing, minor changes)
      auth_provider.dart
      product_provider.dart
      cart_provider.dart
      wishlist_provider.dart
      orders_provider.dart
      address_provider.dart
      search_provider.dart
      payment_card_provider.dart
  features/                    # Presentation layer (unchanged)
    auth/
    cart/
    checkout/
    home/
    main/
    menu/
    orders/
    product/
    profile/
    search/
    settings/
    wishlist/
```

### 10.2 Folder Responsibilities

| Folder | Responsibility |
|---|---|
| `core/` | Shared utilities, theme, routing, reusable widgets, constants |
| `data/models/` | Plain Dart data classes with JSON serialization |
| `data/repositories/` | Abstract repository interfaces (contracts) |
| `data/remote/data_sources/` | Supabase client calls (raw queries, auth calls, storage uploads) |
| `data/remote/repositories/` | Concrete implementations using remote data sources |
| `data/local/repositories/` | Fake/local implementations for testing and development |
| `data/providers/` | Riverpod provider definitions, state notifiers |
| `features/*/presentation/` | UI pages, widgets, feature-level providers |

### 10.3 Key Design Principles

1. **Data sources** handle raw Supabase client calls.
2. **Repositories** orchestrate data sources and contain business logic.
3. **Providers** expose repository results to the UI via Riverpod.
4. **Features** only know about providers and models, never about Supabase directly.
5. **Local implementations** are kept alongside remote ones for easy switching during development and testing.

---

## 11. API / Data Flow

### 11.1 Complete Data Flow

```
Supabase Backend (Auth, Database, Storage)
    |
    | HTTP/WebSocket via supabase_flutter SDK
    v
Supabase Remote Data Source
    |
    | Raw Supabase client calls
    | (Supabase.instance.client.from('table').select())
    v
Repository Implementation
    |
    | Maps Supabase response to Dart models
    | Handles errors, returns typed results
    v
Abstract Repository Interface
    |
    | Contract that providers depend on
    v
Riverpod Provider
    |
    | Wraps repository calls in StateNotifier / AsyncNotifier
    | Manages loading, error, and data states
    v
UI (Pages / Widgets)
    |
    | ref.watch() / ref.read()
    | Builds UI based on state
    v
User Interaction
    |
    | Button taps, form submissions, gestures
    | Call provider methods to trigger data changes
    v
Provider updates state --> UI rebuilds automatically
```

### 11.2 Example: Adding Item to Cart

```
1. User taps "Add to Cart" on ProductDetailPage
2. Widget calls ref.read(cartProvider.notifier).addItem(cartItem)
3. CartNotifier.addItem() calls cartRepository.addItem()
4. SupabaseCartRepository:
   a. Gets current user ID from Supabase Auth
   b. Gets or creates cart for user
   c. Inserts cart_item into Supabase
   d. Returns success
5. CartNotifier updates state = [...state, newItem]
6. cartProvider notifies listeners
7. CartPage rebuilds with new item count and subtotal
```

### 11.3 Example: Fetching Products

```
1. Home page loads
2. ref.watch(featuredProductsProvider) is called
3. FeaturedProductsProvider (FutureProvider) calls:
   a. productRepository.getFeaturedProducts()
4. SupabaseProductRepository:
   a. Queries Supabase: client.from('products').select('*, product_images(*), product_sizes(*)').eq('featured', true)
   b. Maps JSON response to List<ProductModel>
   c. Returns list
5. FutureProvider emits AsyncData(products)
6. Home page renders product grid
```

### 11.4 Example: Placing an Order

```
1. User taps "Place Order" on PlaceOrder page
2. Widget calls ref.read(ordersProvider.notifier).addOrder(order)
3. OrdersNotifier.addOrder() calls ordersRepository.addOrder()
4. SupabaseOrdersRepository:
   a. Gets current user ID
   b. Inserts into 'orders' table
   c. Batch inserts into 'order_items' table
   d. Clears the user's cart
   e. Returns the created order
5. OrdersNotifier refreshes state from Supabase
6. OrdersPage rebuilds with new order
```

### 11.5 Realtime Updates (Future)

```
Supabase Realtime --> onAuthStateChange
    |
    v
AuthRepository listens for auth events
    |
    v
AuthProvider updates AuthState
    |
    v
UI rebuilds (e.g., login/logout without manual refresh)
```

---

## 12. Risks and Migration Notes

### 12.1 Breaking UI

**Risk:** UI breaks when data types change or providers become async.

**Mitigation:**
- Keep all model class names and field names identical.
- Use Riverpod's `AsyncValue` pattern which the app already handles via skeletons.
- Never change provider names or state types.
- Test every screen after each migration phase.

### 12.2 Duplicating Repositories

**Risk:** Creating both fake and real implementations without clear separation.

**Mitigation:**
- Use abstract interfaces as the single contract.
- Keep fake implementations in `data/local/` and real ones in `data/remote/`.
- Only one implementation is active at a time via provider override.
- Delete the provider override when migration is complete.

### 12.3 Duplicate Models

**Risk:** Creating new model classes that conflict with existing ones.

**Mitigation:**
- Reuse all existing models (`UserModel`, `ProductModel`, etc.).
- Only create new models for new database tables (`ProductImageModel`, `CartModel`, etc.).
- Never create a "Supabase version" of an existing model - modify the existing one if needed.

### 12.4 Provider Conflicts

**Risk:** Multiple providers writing to the same state causing inconsistencies.

**Mitigation:**
- Each feature has exactly one primary provider.
- Use `ref.watch()` for reactive updates, `ref.read()` for one-time actions.
- Never directly modify state outside of the designated StateNotifier.
- Use Riverpod's `autoDispose` for providers that should clean up when unused.

### 12.5 Fake Data Conflicts

**Risk:** Old SharedPreferences data conflicting with Supabase data.

**Mitigation:**
- On first Supabase login, clear all SharedPreferences keys used by fake services.
- Migrate existing local cart/wishlist data to Supabase (optional merge strategy).
- Keep `FakeAuthService` keys namespaced (`fake_auth_*`) to avoid collision with Supabase keys.

### 12.6 State Inconsistencies

**Risk:** UI showing stale data after Supabase writes.

**Mitigation:**
- After every write operation, re-fetch the affected data from Supabase.
- Use Riverpod's `refresh()` to invalidate cached providers.
- Consider Supabase Realtime subscriptions for critical data (orders, cart).
- Always update local state immediately after a successful Supabase write (optimistic updates).

### 12.7 Network Failures

**Risk:** App becomes unusable without internet connection.

**Mitigation:**
- Implement proper error handling in all repositories (try-catch with user-friendly messages).
- Show SnackBar errors for failed operations.
- Cache critical data locally (recent products, user profile) for offline browsing.
- Cart and wishlist can queue operations and sync when online.

### 12.8 Data Migration

**Risk:** Existing users losing their cart, wishlist, or order history.

**Mitigation:**
- For new Supabase users: start fresh.
- For existing local users: implement a one-time data migration screen on first Supabase login.
- Or: treat the Supabase launch as a clean start (acceptable for MVP).

---

## 13. Final Roadmap

### 13.1 Project Setup

- [ ] Create Supabase project and obtain API keys
- [ ] Add `supabase_flutter` and `supabase_dart` to `pubspec.yaml`
- [ ] Initialize Supabase client in `main.dart` with `Supabase.initialize()`
- [ ] Create environment configuration for Supabase URL and anon key
- [ ] Set up Supabase Storage buckets (profile-images, product-images)

### 13.2 Authentication

- [ ] Create `profiles` table in Supabase with trigger for auto-creation on signup
- [ ] Create `IAuthRepository` abstract interface
- [ ] Create `SupabaseAuthRepository` implementation
- [ ] Create `FakeAuthRepository` (rename existing `AuthRepository`)
- [ ] Override `authRepositoryProvider` to use `SupabaseAuthRepository`
- [ ] Update `splash.dart` to check Supabase session instead of SharedPreferences
- [ ] Test signup, login, logout, session restore, profile update

### 13.3 Database

- [ ] Create `categories` table with seed data (7 categories)
- [ ] Create `products` table with seed data (18 products)
- [ ] Create `product_images` table
- [ ] Create `product_sizes` table
- [ ] Create `carts` table
- [ ] Create `cart_items` table
- [ ] Create `wishlist_items` table
- [ ] Create `orders` table
- [ ] Create `order_items` table
- [ ] Create `addresses` table
- [ ] Upload product images to Supabase Storage
- [ ] Create database triggers for profile auto-creation

### 13.4 Products

- [ ] Create `SupabaseProductRepository` implementing `ProductRepository`
- [ ] Override `productRepositoryProvider` to use `SupabaseProductRepository`
- [ ] Update `ProductModel` to support network image URLs
- [ ] Handle sync-to-async transition for product providers
- [ ] Update UI to handle `AsyncValue` for product data
- [ ] Test product listing, detail, category filtering, featured products

### 13.5 Cart

- [ ] Create `CartRepository` abstract interface
- [ ] Create `SupabaseCartRepository` implementation
- [ ] Create `LocalCartRepository` (rename existing logic)
- [ ] Override `cartProvider` to use `SupabaseCartRepository`
- [ ] Handle guest-to-authenticated cart merge (optional)
- [ ] Test add to cart, update quantity, remove item, clear cart

### 13.6 Wishlist

- [ ] Create `WishlistRepository` abstract interface
- [ ] Create `SupabaseWishlistRepository` implementation
- [ ] Create `LocalWishlistRepository` (rename existing logic)
- [ ] Override `wishlistProvider` to use `SupabaseWishlistRepository`
- [ ] Test toggle wishlist, remove, move to cart

### 13.7 Orders

- [ ] Create `IOrdersRepository` abstract interface
- [ ] Create `SupabaseOrdersRepository` implementation
- [ ] Create `FakeOrdersRepository` (rename existing `OrdersRepository`)
- [ ] Override `ordersRepositoryProvider` to use `SupabaseOrdersRepository`
- [ ] Test place order, view orders, order details, status updates

### 13.8 Profile and Addresses

- [ ] Implement profile image upload to Supabase Storage
- [ ] Create `AddressRepository` abstract interface
- [ ] Create `SupabaseAddressRepository` implementation
- [ ] Override `addressProvider` to use `SupabaseAddressRepository`
- [ ] Test edit profile, add/edit/delete addresses, set default

### 13.9 Row Level Security

- [ ] Enable RLS on all user-specific tables
- [ ] Create SELECT policies for all tables
- [ ] Create INSERT policies for all tables
- [ ] Create UPDATE policies for all tables
- [ ] Create DELETE policies for all tables
- [ ] Test RLS by attempting cross-user data access
- [ ] Create admin policies for public tables (categories, products)

### 13.10 Testing

- [ ] Write unit tests for all Supabase repositories
- [ ] Write widget tests for critical screens
- [ ] Test authentication flow end-to-end
- [ ] Test cart flow end-to-end
- [ ] Test order placement flow end-to-end
- [ ] Test offline behavior and error handling
- [ ] Test RLS policies with multiple user accounts

### 13.11 Fake Data Removal

- [ ] Remove `FakeAuthService` class
- [ ] Remove `FakeAuthRepository` class
- [ ] Remove `LocalProductRepository` class
- [ ] Remove `LocalSearchRepository` class
- [ ] Remove `FakeOrdersRepository` class
- [ ] Remove `LocalCartRepository` class
- [ ] Remove `LocalWishlistRepository` class
- [ ] Remove `LocalAddressRepository` class
- [ ] Remove `CartStorage`, `OrdersStorage`, `PaymentCardStorage` services
- [ ] Remove static `ProductModel.products` list
- [ ] Remove static `CategoryModel.categories` list
- [ ] Remove static `CoverModel.covers` list (optional - can keep)
- [ ] Clean up SharedPreferences keys in `splash.dart`
- [ ] Delete unused files

### 13.12 Deployment

- [ ] Configure Supabase production environment
- [ ] Set up proper API key rotation strategy
- [ ] Configure Supabase Storage for production (CDN, caching)
- [ ] Set up database backups
- [ ] Configure error monitoring (Sentry or similar)
- [ ] Performance test with realistic data volume
- [ ] Security audit of RLS policies
- [ ] Deploy to app stores

---

> **End of Document**
> 
> This document serves as the single source of truth for the Supabase integration.
> All implementation decisions should reference this document before making changes.
> Update this document as the migration progresses and new decisions are made.
