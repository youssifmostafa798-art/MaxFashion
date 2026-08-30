# 03 — Features & Data

> **MaxFashion — Feature-by-Feature Status & Data Architecture**
> Last Updated: August 30, 2026

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
| Checkout | ✅ Complete | Supabase (cart, orders, order_items) | Supabase |
| Search | ✅ Complete | Supabase RPC (full-text search) | SharedPreferences (recent, per-user) |
| Menu / Categories | ✅ Complete | Supabase | Supabase |
| Settings | ✅ Complete | None | SharedPreferences |
| Dark/Light Theme | ✅ Complete | None | SharedPreferences |
| Wishlist | ✅ Complete | Supabase wishlist_items | Supabase |
| Orders | ✅ Complete | Supabase orders + order_items | Supabase |
| Addresses | ✅ Complete | Supabase addresses | Supabase |
| Payment Cards | ✅ Complete | Supabase payment_cards | Supabase |
| Collections | ✅ Complete | Supabase collections + collection_categories | Supabase |
| OTP Password Recovery | ✅ Complete | Supabase Edge Functions + password_reset_codes (SHA-256 hashed) | Supabase |
| Route Auth Guards | ✅ Complete | AuthGuard widget | In-memory |
| Promo Code | ⚠️ UI Only | None | None |
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
- `ensureProfileExists` creates profile if missing after auth
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

### OTP Password Recovery

**Status:** ✅ Completed
**Backend:** Supabase Edge Functions + `password_reset_codes` table (SHA-256 hashed)
**Persistence:** Supabase

**Implementation:**
- 3-page UI flow: ForgotPasswordPage → VerifyResetCodePage → ResetPasswordPage
- `sendResetCode()` calls `send-reset-code` Edge Function (sends 6-digit OTP via Resend API)
- `verifyResetCode()` calls `verify-reset-code` Edge Function (verifies code without changing password)
- `resetPasswordWithCode()` calls `reset-password` Edge Function (updates password via admin API)
- OTP codes are SHA-256 hashed before storage (migration 021)
- `password_reset_codes` table stores OTP codes with expiry, attempt limiting, and rate limiting
- Security: 60-second rate limit between code requests, max 5 verification attempts per code, 10-minute code expiry
- Session invalidation after password reset (global signOut)
- Dev mode: If no RESEND_API_KEY configured, codes are logged to console
- `cleanup_expired_codes()` SQL function for automatic cleanup of expired codes
- ✅ **RLS correctly secured** — Migration 016 has NO anon policies. Edge functions use service_role which bypasses RLS.

**Key Files:**
- `lib/features/auth/presentation/pages/forgot_password_page.dart`
- `lib/features/auth/presentation/pages/verify_reset_code_page.dart`
- `lib/features/auth/presentation/pages/reset_password_page.dart`
- `lib/features/auth/data/repositories/supabase_auth_repository.dart` — `sendResetCode()`, `verifyResetCode()`, `resetPasswordWithCode()`
- `supabase/functions/send-reset-code/index.ts`
- `supabase/functions/verify-reset-code/index.ts`
- `supabase/functions/reset-password/index.ts`
- `supabase/migrations/016_create_password_reset_codes.sql`
- `supabase/migrations/017_otp_security_hardening.sql`

**Data Flow:**
```
ForgotPasswordPage → authStateProvider → AuthNotifier.sendResetCode()
  → SupabaseAuthRepository.sendResetCode()
  → Supabase Edge Function 'send-reset-code'
  → password_reset_codes table + Resend API email

VerifyResetCodePage → authStateProvider → AuthNotifier.verifyResetCode()
  → SupabaseAuthRepository.verifyResetCode()
  → Supabase Edge Function 'verify-reset-code'
  → Verifies code (unused, not expired, attempts < 5)

ResetPasswordPage → authStateProvider → AuthNotifier.resetPasswordWithCode()
  → SupabaseAuthRepository.resetPasswordWithCode()
  → Supabase Edge Function 'reset-password'
  → Updates password via admin API, marks code as used
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
- 244 products, 22 categories in live Supabase (after migration 008 cleanup)
- Product detail page with size selection, quantity, add to cart
- Product listing page with category filtering
- Product grid card with hero animation, favorite button
- Images served from Supabase Storage `product-images` bucket via `Image.network()`

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
- Menu page: category grid (4 columns) with icons from `assets/categories_icons/`

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
- Auth-aware provider (watches `currentUserIdProvider`)

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
**Backend:** Supabase (cart, orders, order_items)
**Persistence:** Supabase

**Implementation:**
- Place Order page with shipping address, payment method, cart items, total
- Address selection (from saved addresses or add new)
- Payment card entry via `flutter_credit_card` widget
- Saved card selection with visual indicator
- Order validation (requires address and payment method)
- Order creation: converts cart items to order items, saves to Supabase `orders` + `order_items` tables
- Cart clearing after successful order creation (with proper error handling)
- Order success dialog

**Key Files:**
- `lib/features/checkout/presentation/pages/place_order.dart`
- `lib/features/checkout/presentation/pages/add_address.dart`
- `lib/features/checkout/presentation/pages/add_card.dart`
- `lib/features/checkout/presentation/widgets/order_success_dialog.dart`

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
- Auth-aware provider (watches `currentUserIdProvider`)

**Key Files:**
- `lib/data/repositories/wishlist/wishlist_repository.dart` (interface)
- `lib/data/repositories/wishlist/supabase_wishlist_repository.dart`
- `lib/data/providers/wishlist_provider.dart`
- `lib/features/wishlist/presentation/pages/wishlist_page.dart`
- `lib/features/wishlist/presentation/widgets/wishlist_item_card.dart`
- `lib/features/checkout/presentation/widgets/favorite_button.dart`

---

### Orders

**Status:** ✅ Completed
**Backend:** Supabase orders + order_items tables
**Persistence:** Supabase

**Implementation:**
- `SupabaseOrderRepository` — full CRUD (load, add, update status)
- `orders` table with RLS policies (user-owned)
- `order_items` table with RLS policies (user-owned via orders)
- Order creation from cart items with historical snapshot preservation
- Order history page with list view, order cards, empty state
- Order details page with order ID, date, status chip, product list, totals, timeline
- Order status enum: processing, shipped, delivered, cancelled
- Orders count provider for badge display
- Local SharedPreferences orders migrated via `OrdersMigrationService`
- Auth-aware provider (watches `currentUserIdProvider`)

**Key Files:**
- `lib/data/repositories/orders/order_repository.dart` (interface)
- `lib/data/repositories/orders/supabase_order_repository.dart`
- `lib/data/providers/orders_provider.dart`
- `lib/data/services/orders_migration_service.dart`
- `lib/features/orders/presentation/pages/orders_page.dart`
- `lib/features/orders/presentation/pages/order_details_page.dart`

**Data Flow:**
```
PlaceOrder → ordersProvider → OrdersNotifier.addOrder()
  → SupabaseOrderRepository.addOrder()
  → Supabase orders table
  → Supabase order_items table
```

---

### Search

**Status:** ✅ Completed
**Backend:** Supabase RPC (full-text search with trigram matching)
**Persistence:** SharedPreferences (recent searches, per-user via userId key)

**Implementation:**
- Debounced search (300ms)
- Recent searches (persisted per-user, max 10)
- Suggested products (top 10 shuffled products)
- Context-aware search (global, home, category, wishlist, cart, orders)
- Search results with highlighted query text
- Search skeleton loading state
- Server-side pagination (load more)
- `SupabaseSearchRepository` uses `search_products` RPC with full-text search via migration 020
- Recent searches keyed by userId (`recent_searches_{userId}`), preventing cross-account history leakage

**Key Files:**
- `lib/data/providers/search_provider.dart`
- `lib/data/repositories/search/supabase_search_repository.dart`
- `lib/data/repositories/search/search_repository.dart` (interface)
- `lib/features/search/presentation/pages/search_screen.dart`

---

### Address Management

**Status:** ✅ Completed
**Backend:** Supabase addresses table
**Persistence:** Supabase

**Implementation:**
- `SupabaseAddressRepository` — full CRUD (load, add, update, delete, setDefault)
- `addresses` table with RLS policies (user-owned)
- Add/Edit/Delete addresses, set default
- AddressCard with edit/delete/set-default actions
- Empty addresses state
- Default address management with automatic reassignment on delete
- Auth-aware provider (watches `currentUserIdProvider`)
- Lifecycle `mounted` checks in all async methods

**Key Files:**
- `lib/data/repositories/address/address_repository.dart` (interface)
- `lib/data/repositories/address/supabase_address_repository.dart`
- `lib/data/providers/address_provider.dart`
- `lib/features/profile/presentation/pages/addresses_page.dart`
- `lib/features/checkout/presentation/pages/add_address.dart`

---

### Payment Card Management

**Status:** ✅ Completed
**Backend:** Supabase payment_cards table
**Persistence:** Supabase

**Implementation:**
- `SupabasePaymentCardRepository` — full CRUD (load, add, delete, setDefault)
- `payment_cards` table with RLS policies (user-owned)
- Add cards, delete with confirmation, set default
- Duplicate card detection, card brand auto-detection
- Credit card form via `flutter_credit_card` widget
- Default card management with automatic reassignment on delete
- Auth-aware provider (watches `currentUserIdProvider`)
- Lifecycle `mounted` checks in all async methods

**Key Files:**
- `lib/data/repositories/payment_card/payment_card_repository.dart` (interface)
- `lib/data/repositories/payment_card/supabase_payment_card_repository.dart`
- `lib/data/providers/payment_card_provider.dart`
- `lib/features/profile/presentation/pages/payment_methods_page.dart`
- `lib/features/checkout/presentation/pages/add_card.dart`

---

### Collections

**Status:** ✅ Completed
**Backend:** Supabase collections + collection_categories tables
**Persistence:** Supabase

**Implementation:**
- `SupabaseCollectionRepository` — fetches active collections with category mappings
- `collections` table with RLS (public read for active collections)
- `collection_categories` junction table linking collections to categories
- Home page carousel showing top 5 active collections
- All Collections page showing all active collections in a grid
- Collection Products page filtering products by a collection's categories
- `collection-images` storage bucket (public read, service-role write)
- Collection images served from Supabase Storage via `Image.network()`
- 10 collections seeded (6 active, 4 inactive)

**Key Files:**
- `lib/data/repositories/collection/collection_repository.dart` (interface)
- `lib/data/repositories/collection/supabase_collection_repository.dart`
- `lib/data/providers/collection_provider.dart`
- `lib/data/models/collection_model.dart`
- `lib/features/collection/presentation/pages/all_collections_page.dart`
- `lib/features/collection/presentation/pages/collection_products_page.dart`
- `lib/features/collection/presentation/widgets/home_collections_section.dart`

**Data Flow:**
```
Home → collectionsProvider → SupabaseCollectionRepository.getActiveCollections()
  → Supabase collections table (active only) + collection_categories
  → HomeCollectionsSection carousel (top 5)
  → CollectionProductsPage (filter by collection's categories)
```

---

### Settings

**Status:** ✅ Completed
**Backend:** None
**Persistence:** SharedPreferences (theme only)

**Implementation:**
- Theme selector (Light / Dark / System) with persistence
- Language selector (English / Arabic) with runtime locale switching via `localeProvider`
- Privacy, Terms, Support placeholders

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
| `icon_name` | TEXT | NOT NULL, DEFAULT '' |
| `display_order` | INTEGER | DEFAULT 0 |
| `is_active` | BOOLEAN | DEFAULT true |

**RLS:** Public read access.
**Note:** `image_url` column was dropped in migration 013. Categories now use `icon_name` to reference PNG icons in `assets/categories_icons/`.

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

#### orders
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK, DEFAULT gen_random_uuid() |
| `user_id` | UUID | FK → auth.users(id) ON DELETE CASCADE |
| `order_number` | TEXT | NOT NULL, UNIQUE |
| `total_price` | NUMERIC(10,2) | NOT NULL |
| `status` | TEXT | NOT NULL, DEFAULT 'processing' |
| `delivery_address` | TEXT | NOT NULL |
| `payment_method` | TEXT | NOT NULL |
| `created_at` | TIMESTAMPTZ | NOT NULL, DEFAULT now() |
| `updated_at` | TIMESTAMPTZ | NOT NULL, DEFAULT now() |

**RLS:** User can only SELECT/INSERT/UPDATE/DELETE their own orders.
**Indexes:** UNIQUE on order_number; indexes on user_id and created_at (DESC).

#### order_items
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK, DEFAULT gen_random_uuid() |
| `order_id` | UUID | FK → orders(id) ON DELETE CASCADE |
| `product_id` | BIGINT | FK → products(id) ON DELETE SET NULL |
| `product_name` | TEXT | NOT NULL |
| `product_image` | TEXT | NOT NULL, DEFAULT '' |
| `selected_color` | TEXT | Nullable |
| `selected_size` | TEXT | NOT NULL, DEFAULT 'S' |
| `quantity` | INTEGER | NOT NULL, DEFAULT 1, CHECK >= 1 |
| `unit_price` | NUMERIC(10,2) | NOT NULL |
| `created_at` | TIMESTAMPTZ | NOT NULL, DEFAULT now() |

**RLS:** User can only SELECT/INSERT/UPDATE/DELETE order items from their own orders (via orders table).
**Indexes:** Indexes on order_id and product_id.

#### addresses
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK |
| `user_id` | UUID | FK → auth.users(id) ON DELETE CASCADE |
| `street` | TEXT | NOT NULL |
| `apartment` | TEXT | Nullable |
| `city` | TEXT | NOT NULL |
| `state` | TEXT | NOT NULL |
| `country` | TEXT | NOT NULL |
| `zip` | TEXT | DEFAULT '' |
| `label` | TEXT | DEFAULT 'Home' |
| `is_default` | BOOL | DEFAULT false |
| `created_at` | TIMESTAMPTZ | DEFAULT now() |
| `updated_at` | TIMESTAMPTZ | DEFAULT now() |

**RLS:** User can only SELECT/INSERT/UPDATE/DELETE their own addresses.
**Indexes:** Indexes on user_id and created_at (DESC). Partial index on (user_id, is_default) WHERE is_default.

#### payment_cards
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK |
| `user_id` | UUID | FK → auth.users(id) ON DELETE CASCADE |
| `card_holder_name` | TEXT | NOT NULL |
| `last4_digits` | TEXT | NOT NULL |
| `expiry_month` | TEXT | NOT NULL |
| `expiry_year` | TEXT | NOT NULL |
| `card_brand` | TEXT | DEFAULT 'unknown' |
| `is_default` | BOOL | DEFAULT false |
| `created_at` | TIMESTAMPTZ | DEFAULT now() |
| `updated_at` | TIMESTAMPTZ | DEFAULT now() |

**RLS:** User can only SELECT/INSERT/UPDATE/DELETE their own payment cards.
**Indexes:** Indexes on user_id and created_at (DESC). Partial index on (user_id, is_default) WHERE is_default.

#### password_reset_codes
| Column | Type | Constraint |
|--------|------|------------|
| `id` | UUID | PK |
| `email` | TEXT | NOT NULL |
| `code_hash` | TEXT | NOT NULL |
| `expires_at` | TIMESTAMPTZ | NOT NULL |
| `used` | BOOL | DEFAULT false |
| `attempt_count` | INT | DEFAULT 0 |
| `last_request_at` | TIMESTAMPTZ | DEFAULT NOW() |
| `created_at` | TIMESTAMPTZ | DEFAULT NOW() |

**RLS:** ✅ Service-role only (no anon policies). Edge functions use service_role which bypasses RLS.
**Indexes:** Partial index on (email, used) WHERE used = FALSE.
**Function:** `cleanup_expired_codes()` — deletes codes older than 1 hour past expiry.
**Note:** OTP codes are stored as SHA-256 hashes (migration 021), not plaintext.

#### collections
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGINT | PK |
| `name` | TEXT | NOT NULL |
| `image_url` | TEXT | Nullable |
| `display_order` | INTEGER | DEFAULT 0 |
| `is_active` | BOOLEAN | DEFAULT true |
| `created_at` | TIMESTAMPTZ | DEFAULT now() |
| `updated_at` | TIMESTAMPTZ | DEFAULT now() |

**RLS:** Public read access for active collections only (`is_active = true`).
**Note:** `updated_at` auto-updates via trigger.

#### collection_categories
| Column | Type | Constraint |
|--------|------|------------|
| `id` | BIGINT | PK |
| `collection_id` | BIGINT | FK → collections(id) ON DELETE CASCADE |
| `category_id` | BIGINT | FK → categories(id) ON DELETE CASCADE |

**RLS:** Public read access.
**Indexes:** Indexes on collection_id and category_id.
**Constraint:** UNIQUE on (collection_id, category_id).

### Storage Policies

#### product-images bucket
- SELECT: Public (anon + authenticated)
- INSERT/UPDATE/DELETE: Service role only (no client writes)

#### avatars bucket
- SELECT: Public (anon + authenticated)
- INSERT/UPDATE/DELETE: Authenticated users (own avatar only)

#### collection-images bucket
- SELECT: Public (anon + authenticated)
- INSERT/UPDATE/DELETE: Service role only (no client writes)

### Seed Data

| Table | Records | Source |
|-------|---------|--------|
| categories | 22 (initial) → 22 (after cleanup) | `002_seed_categories.sql` |
| products | 247 (initial) → 244 (after cleanup) | `003_seed_products.sql` |
| product_images | 248 (initial) → 244 (after cleanup) | `004_seed_product_images.sql` |
| product_sizes | 998 (initial) → 977 (after cleanup) | `005_seed_product_sizes.sql` |
| collections | 10 (6 active) | `022_collections_schema.sql` |

---

## Local Assets

### Category Icons
- Path: `assets/categories_icons/`
- Used by: `CategoryModel.iconAssetPath` → `assets/categories_icons/{iconName}`
- Referenced by categories table `icon_name` column

### Other Assets
- `assets/logo/` — App logo (`new_logo.png`, `spalsh_logo_2.svg`, `spalsh_logo.png`)
- `assets/svgs/` — SVG graphics (delivery, Mastercard, Visa, promo, shopping bag, plus, min, line)
- `assets/texts/` — SVG text overlays (10.svg, Collection.svg, October.svg)
- `assets/pop/` — Pop-up images (done.svg)
- `assets/fonts/` — Tenor Sans and Noto Sans Arabic fonts

---

*See [01_PROJECT_STATUS.md](./01_PROJECT_STATUS.md) for overall status, [02_ARCHITECTURE.md](./02_ARCHITECTURE.md) for architecture, and [04_ROADMAP_AND_TECHNICAL_DEBT.md](./04_ROADMAP_AND_TECHNICAL_DEBT.md) for remaining work.*
