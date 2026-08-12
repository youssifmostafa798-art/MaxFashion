# 03 — Features & Data

> **MaxFashion — Feature-by-Feature Status & Data Architecture**
> Last Updated: August 12, 2026

---

## Feature Status Matrix

| Feature | Status | Backend | Persistence |
|---------|--------|---------|-------------|
| Authentication | ✅ Complete | Supabase Auth | Supabase |
| Profile | ✅ Complete | Supabase profiles | Supabase |
| Avatar Upload | ✅ Complete | Supabase Storage | Supabase |
| Products | ✅ Complete | Supabase products | Supabase |
| Categories | ✅ Complete | Supabase categories | Supabase |
| Home Content | ✅ Complete | Supabase home_content | Supabase |
| Home Page | ✅ Complete | Supabase | Supabase |
| Product Listing | ✅ Complete | Supabase | Supabase |
| Product Details | ✅ Complete | Supabase | Supabase |
| Cart | ✅ Complete | Supabase cart_items | Supabase |
| Checkout | ✅ Complete | Mixed | Mixed |
| Search | ✅ Complete | In-memory (Supabase cache) | SharedPreferences (recent) |
| Menu / Categories | ✅ Complete | Supabase | Supabase |
| Settings | ✅ Complete | None | SharedPreferences |
| Dark/Light Theme | ✅ Complete | None | SharedPreferences |
| Wishlist | ✅ Complete | Supabase wishlist_items | Supabase |
| Orders | ✅ Complete | None | SharedPreferences |
| Addresses | ✅ Complete | None | SharedPreferences |
| Payment Cards | ✅ Complete | None | SharedPreferences |
| Promo Code | ⚠️ UI Only | None | None |
| Forgot Password | ❌ Not Implemented | — | — |
| Product Reviews | ❌ Not Implemented | — | — |
| Push Notifications | ❌ Not Implemented | — | — |
| Real Payment Gateway | ❌ Not Implemented | — | — |

---

## Feature Details

### Authentication

**Status:** ✅ Completed
**Backend:** Supabase Auth
**Persistence:** Supabase SDK (automatic)

**Implementation:**
- `SupabaseAuthRepository` — signUp, signIn, signOut, getProfile, updateProfile
- Email confirmation flow supported
- Session restore on app start via `splash.dart`
- Auth state listener for token refresh and sign-out events
- Guest mode (bypass auth)
- Error handling with user-friendly messages

**Key Files:**
- `lib/features/auth/data/repositories/supabase_auth_repository.dart`
- `lib/features/auth/domain/auth_repository_interface.dart`
- `lib/data/providers/auth_provider.dart`
- `lib/features/auth/presentation/providers/auth_providers.dart`

**Data Flow:**
```
LoginPage → authStateProvider → AuthNotifier.login()
  → SupabaseAuthRepository.signIn() → Supabase Auth
  → SupabaseAuthRepository.getProfile() → profiles table
```

---

### Profile

**Status:** ✅ Completed
**Backend:** Supabase profiles table
**Persistence:** Supabase

**Implementation:**
- Profile page with avatar, name, email, phone, gender, country, DOB, bio, member since
- Edit profile with form validation
- Profile updates via Supabase
- Guest user handling (shows "Guest User", taps navigate to signup)

**Key Files:**
- `lib/features/profile/presentation/pages/profile_page.dart`
- `lib/features/profile/presentation/pages/edit_profile_page.dart`
- `lib/features/profile/presentation/providers/edit_profile_provider.dart`

---

### Avatar Upload

**Status:** ✅ Completed
**Backend:** Supabase Storage (avatars bucket)
**Persistence:** Supabase

**Implementation:**
- Upload avatar to Supabase Storage at `{userId}/{timestamp}.jpg`
- Remove avatar (deletes from storage, sets URL to null)
- Update `profiles.avatar_url` in database

**Key Files:**
- `lib/features/auth/data/repositories/supabase_auth_repository.dart` — `uploadAvatar()`, `removeAvatar()`

---

### Products

**Status:** ✅ Completed
**Backend:** Supabase products + product_images + product_sizes (joined)
**Persistence:** Supabase

**Implementation:**
- `SupabaseProductRepository` fetches products with joined images and sizes
- 251 products, 23 categories, 251 images, 977 sizes in live Supabase
- Product detail page with size selection, quantity, add to cart
- Product listing page with category filtering
- Product grid card with hero animation, favorite button
- Images use local asset paths (`assets/products_supa/...`) via `Image.asset()`

**Key Files:**
- `lib/data/repositories/product/supabase_product_repository.dart`
- `lib/data/repositories/product/product_repository.dart` (interface)
- `lib/data/providers/product_provider.dart`
- `lib/data/models/product_model.dart`

**Data Flow:**
```
Home → filteredHomeProductsProvider → productRepositoryProvider
  → SupabaseProductRepository.loadAll()
  → Supabase (categories + products + product_images + product_sizes)
  → In-memory cache
```

---

### Categories

**Status:** ✅ Completed
**Backend:** Supabase categories table
**Persistence:** Supabase

**Implementation:**
- Categories loaded from Supabase via `categoriesProvider`
- Dynamic category resolution via `categoryNameById()` helper
- Home page: horizontal category filter chips with "All" option
- Menu page: category grid (4 columns) with icons

**Key Files:**
- `lib/data/providers/product_provider.dart` — `categoriesProvider`
- `lib/features/home/presentation/pages/home.dart` — category filter
- `lib/features/menu/presentation/pages/categories_page.dart` — category grid

---

### Home Page

**Status:** ✅ Completed
**Backend:** Supabase (products + home_content)
**Persistence:** Supabase

**Implementation:**
- SVG text overlays ("10 October Collection")
- Cover image from Supabase `home_content` table (loaded via `Image.network()`)
- Horizontal category filter chips
- Product grid (2 columns) with filtered/shuffled products
- "You may also like" section
- Footer with social links, contact info, copyright
- Skeleton loading during initial load

**Key Files:**
- `lib/features/home/presentation/pages/home.dart`
- `lib/features/home/presentation/widgets/home_cover.dart`
- `lib/features/home/presentation/widgets/home_category_filter.dart`
- `lib/features/home/presentation/widgets/home_product_grid.dart`
- `lib/data/providers/home_content_provider.dart`

---

### Cart

**Status:** ✅ Completed
**Backend:** Supabase cart_items table
**Persistence:** Supabase

**Implementation:**
- `SupabaseCartRepository` — full CRUD (load, add, update quantity, remove, clear)
- `cart_items` table with RLS policies (user-owned)
- Duplicate item detection (same product + size = merge quantities)
- Product data joined from `products` table
- Cart page with swipe-to-delete, quantity controls
- Empty cart state, checkout navigation
- Cart badge on bottom navigation bar
- Total calculation via providers

**Key Files:**
- `lib/data/repositories/cart/supabase_cart_repository.dart`
- `lib/data/repositories/cart/cart_repository.dart` (interface)
- `lib/data/providers/cart_provider.dart`
- `lib/features/cart/presentation/pages/cart_page.dart`
- `lib/features/cart/presentation/widgets/cart_item_card.dart`

**Data Flow:**
```
ProductDetailPage → cartProvider → CartNotifier.addItem()
  → SupabaseCartRepository.addItem()
  → Supabase cart_items table (+ product join)
  → CartState (List<CartItemModel>)
```

---

### Checkout

**Status:** ✅ Completed (UI + order creation)
**Backend:** Mixed (cart from Supabase, orders/addresses/cards from SharedPreferences)
**Persistence:** Mixed

**Implementation:**
- Place Order page with shipping address, payment method, cart items, total
- Address selection (from saved addresses or add new)
- Payment card entry via `flutter_credit_card` widget
- Saved card selection with visual indicator
- Order validation (requires address and payment method)
- Order creation: converts cart items to order items, saves to SharedPreferences
- Cart clearing after order placement
- Order success dialog

**Key Files:**
- `lib/features/checkout/presentation/pages/place_order.dart`
- `lib/features/checkout/presentation/pages/add_address.dart`
- `lib/features/checkout/presentation/pages/add_card.dart`
- `lib/features/checkout/presentation/widgets/order_success_dialog.dart`

**Note:** Orders created during checkout are saved to SharedPreferences (not Supabase). This will be migrated in Phase 3.6.

---

### Wishlist

**Status:** ✅ Completed
**Backend:** Supabase wishlist_items table
**Persistence:** Supabase

**Implementation:**
- `SupabaseWishlistRepository` — full CRUD (load, add, remove, check)
- `wishlist_items` table with RLS policies (user-owned)
- Product data joined from `products` table with images and sizes
- Duplicate detection (one entry per user per product)
- Add/remove/toggle wishlist items
- Badge count on bottom navigation bar
- Wishlist page with list view, swipe-to-delete, empty state
- Favorite button on product grid cards and detail pages (animated heart)
- "Move to Cart" adds item to cart with default size

**Key Files:**
- `lib/data/repositories/wishlist/wishlist_repository.dart` (interface)
- `lib/data/repositories/wishlist/supabase_wishlist_repository.dart`
- `lib/data/providers/wishlist_provider.dart`
- `lib/features/wishlist/presentation/pages/wishlist_page.dart`
- `lib/features/wishlist/presentation/widgets/wishlist_item_card.dart`
- `lib/features/checkout/presentation/widgets/favorite_button.dart`

---

### Orders

**Status:** ✅ Completed (local only)
**Backend:** None
**Persistence:** SharedPreferences

**Implementation:**
- Order creation from cart items
- Order persistence via SharedPreferences
- Order history page with list view, order cards, empty state
- Order details page with order ID, date, status chip, product list, totals, timeline
- Order status enum: processing, shipped, delivered, cancelled
- Orders count provider for badge display

**Key Files:**
- `lib/data/providers/orders_provider.dart`
- `lib/data/repositories/orders_repository.dart`
- `lib/data/services/orders_storage.dart`
- `lib/features/orders/presentation/pages/orders_page.dart`
- `lib/features/orders/presentation/pages/order_details_page.dart`

**Remaining:** Migrate to Supabase `orders` + `order_items` tables (Phase 3.6).

---

### Search

**Status:** ✅ Completed
**Backend:** In-memory (filters Supabase-cached products)
**Persistence:** SharedPreferences (recent searches only)

**Implementation:**
- Debounced search (250ms)
- Recent searches (persisted, max 10)
- Suggested products (first 3 products)
- Context-aware search (global, home, category, wishlist, cart, orders)
- Search results with highlighted query text
- Search skeleton loading state
- `SupabaseSearchRepository` searches in-memory cached products

**Key Files:**
- `lib/data/providers/search_provider.dart`
- `lib/data/repositories/search/supabase_search_repository.dart`
- `lib/features/search/presentation/pages/search_screen.dart`

---

### Address Management

**Status:** ✅ Completed (local only)
**Backend:** None
**Persistence:** SharedPreferences

**Implementation:**
- Add/Edit/Delete addresses, set default
- AddressCard with edit/delete/set-default actions
- Empty addresses state

**Key Files:**
- `lib/data/providers/address_provider.dart`
- `lib/features/profile/presentation/pages/addresses_page.dart`
- `lib/features/checkout/presentation/pages/add_address.dart`

**Remaining:** Migrate to Supabase `addresses` table.

---

### Payment Card Management

**Status:** ✅ Completed (local only)
**Backend:** None
**Persistence:** SharedPreferences

**Implementation:**
- Add cards, delete with confirmation, set default
- Duplicate card detection, card brand auto-detection
- Credit card form via `flutter_credit_card` widget

**Key Files:**
- `lib/data/providers/payment_card_provider.dart`
- `lib/data/services/payment_card_storage.dart`
- `lib/features/profile/presentation/pages/payment_methods_page.dart`
- `lib/features/checkout/presentation/pages/add_card.dart`

**Remaining:** Consider third-party payment processor for PCI compliance.

---

### Settings

**Status:** ✅ Completed
**Backend:** None
**Persistence:** SharedPreferences (theme only)

**Implementation:**
- Theme selector (Light / Dark / System) with persistence
- Language, Privacy, Terms, Support placeholders

**Key Files:**
- `lib/features/settings/presentation/pages/settings_page.dart`
- `lib/core/theme/theme_provider.dart`
- `lib/core/theme/theme_storage.dart`

---

## Supabase Database Schema

### Implemented Tables

#### profiles
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK, FK → auth.users(id) |
| `full_name` | TEXT | NOT NULL |
| `phone_number` | TEXT | NOT NULL |
| `avatar_url` | TEXT | Nullable |
| `gender` | TEXT | Nullable |
| `date_of_birth` | TIMESTAMP | Nullable |
| `country` | TEXT | Nullable |
| `bio` | TEXT | Nullable |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT now() |
| `updated_at` | TIMESTAMP | NOT NULL, DEFAULT now() |

**RLS:** User can only SELECT/UPDATE their own row.

#### categories
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGINT | PK |
| `name` | TEXT | NOT NULL, UNIQUE |
| `slug` | TEXT | NOT NULL, UNIQUE |
| `image_url` | TEXT | NOT NULL, DEFAULT '' |

**RLS:** Public read access.

#### products
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGINT | PK |
| `category_id` | BIGINT | FK → categories(id) |
| `name` | TEXT | NOT NULL |
| `description` | TEXT | DEFAULT '' |
| `price` | NUMERIC(10,2) | NOT NULL |
| `discount_price` | NUMERIC(10,2) | Nullable |
| `brand` | TEXT | DEFAULT 'MaxFashion' |
| `thumbnail_url` | TEXT | DEFAULT '' |
| `is_featured` | BOOLEAN | DEFAULT false |
| `is_available` | BOOLEAN | DEFAULT true |

**RLS:** Public read access.

#### product_images
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGINT | PK |
| `product_id` | BIGINT | FK → products(id) ON DELETE CASCADE |
| `image_url` | TEXT | NOT NULL |
| `sort_order` | INTEGER | DEFAULT 1 |

**RLS:** Public read access.

#### product_sizes
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGSERIAL | PK |
| `product_id` | BIGINT | FK → products(id) ON DELETE CASCADE |
| `size` | TEXT | NOT NULL |
| `stock` | INTEGER | DEFAULT 0 |

**RLS:** Public read access. UNIQUE on (product_id, size).

#### cart_items
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK, DEFAULT gen_random_uuid() |
| `user_id` | UUID | FK → auth.users(id) ON DELETE CASCADE |
| `product_id` | BIGINT | FK → products(id) ON DELETE CASCADE |
| `size` | TEXT | Nullable |
| `quantity` | INTEGER | DEFAULT 1, CHECK >= 1 |
| `created_at` | TIMESTAMPTZ | DEFAULT now() |
| `updated_at` | TIMESTAMPTZ | DEFAULT now() |

**RLS:** User can only SELECT/INSERT/UPDATE/DELETE their own cart items.
**Indexes:** UNIQUE on (user_id, product_id, size) WHERE size IS NOT NULL; UNIQUE on (user_id, product_id) WHERE size IS NULL.

#### wishlist_items
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK, DEFAULT gen_random_uuid() |
| `user_id` | UUID | FK → auth.users(id) ON DELETE CASCADE |
| `product_id` | BIGINT | FK → products(id) ON DELETE CASCADE |
| `created_at` | TIMESTAMPTZ | DEFAULT now() |

**RLS:** User can only SELECT/INSERT/DELETE their own wishlist items.
**Indexes:** UNIQUE on (user_id, product_id); indexes on user_id and product_id.

#### home_content
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGINT | PK, GENERATED BY DEFAULT AS IDENTITY |
| `cover_url` | TEXT | Nullable |
| `is_active` | BOOLEAN | DEFAULT true |
| `created_at` | TIMESTAMPTZ | DEFAULT now() |
| `updated_at` | TIMESTAMPTZ | DEFAULT now() |

**RLS:** Anyone can view active home content.

### Storage Policies

#### product-images bucket
- SELECT: Public (anon + authenticated)
- INSERT/UPDATE/DELETE: Service role only (no client writes)

### Seed Data

| Table | Records | Source |
|-------|---------|--------|
| categories | 23 | `002_seed_categories.sql` |
| products | 251 | `003_seed_products.sql` |
| product_images | 251 | `004_seed_product_images.sql` |
| product_sizes | 977 | `005_seed_product_sizes.sql` |

---

## Local Assets

### Product Images
- Path: `assets/products_supa/`
- Structure: `{gender}/{category_type}/{subcategory}/{image}.jpg`
- Loaded via: `Image.asset(product.image)`
- `cached_network_image` NOT required

### Local JSON Data (Legacy/Reference)
- `assets/data/categories.json` — 23 categories
- `assets/data/products.json` — 251 products
- `assets/data/product_images.json` — 251 images
- `assets/data/product_sizes.json` — 997 sizes

These JSON files are loaded by `LocalProductDataSource` as a fallback data source. The primary source is Supabase.

### Other Assets
- `assets/cover/` — Cover images
- `assets/logo/` — App logo
- `assets/svgs/` — SVG graphics
- `assets/texts/` — SVG text overlays
- `assets/pop/` — Pop-up images
- `assets/fonts/` — Tenor Sans font

---

*See [01_PROJECT_STATUS.md](./01_PROJECT_STATUS.md) for overall status, [02_ARCHITECTURE.md](./02_ARCHITECTURE.md) for architecture, and [04_ROADMAP_AND_TECHNICAL_DEBT.md](./04_ROADMAP_AND_TECHNICAL_DEBT.md) for remaining work.*
