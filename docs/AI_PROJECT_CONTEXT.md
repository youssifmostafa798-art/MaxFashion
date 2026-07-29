# MaxFashion — AI Project Context

> **Primary reference document for AI assistants and developers.**
> Read this file first, then [ROADMAP.md](./ROADMAP.md) before making implementation decisions.

---

## 1. Project Summary

**MaxFashion** is a premium fashion e-commerce Flutter mobile application backed by Supabase. The app targets style-conscious shoppers (18–35) with a minimal, editorial, black-and-white design language. It follows Clean Architecture (feature-first organization) and uses `flutter_screenutil` for responsive sizing.

**Current state:** The project is in early Phase 1 (UI Completion) at **55% progress**. The UI foundation, splash screen, auth UI, app theme, centralized colors, screenutil integration, and initial navigation wiring are complete. The remaining Phase 1 work is finishing all core screen UIs with static/mock data.

**Estimated overall completion: ~15–18%** (the roadmap states 20% illustratively, but only Phase 1 is in progress at 55%, and no other phases have started).

---

## 2. Completed Features

| # | Feature | Evidence |
|---|---------|----------|
| 1 | Flutter project structure scaffolded | Section 2.1 ✓ |
| 2 | UI Foundation (design tokens, base widgets) | Section 2.1 ✓ |
| 3 | Splash Screen | Section 2.1 ✓ |
| 4 | Authentication UI (Login / Signup screens) | Section 2.1 ✓ |
| 5 | App Theme configured | Section 2.1 ✓ |
| 6 | Centralized App Colors (no hardcoded colors) | Section 2.1 ✓ |
| 7 | flutter_screenutil integrated for responsive sizing | Section 2.1 ✓ |
| 8 | Initial navigation flow wired between core screens | Section 2.1 ✓ |

---

## 3. Features Currently in Progress

| # | Feature | Progress | What Remains |
|---|---------|----------|--------------|
| 1 | **Phase 1 — UI Completion** | 55% | Tasks 1–7 (Home, Product Listing, Product Details, Search shell, Wishlist shell, Cart shell, Profile screen shells) and Task 8 (shared component library) are partially complete. The foundation widgets exist but full screen implementations are not confirmed complete. |

> The roadmap explicitly states in Section 2.2: *"Now — Finishing the complete UI before backend integration — all core screens should be visually complete and reviewed before Supabase work begins in Phase 5."*

---

## 4. Remaining Tasks

### Phase 1 — UI Completion (55% remaining)

- [ ] Finish Home screen (hero banner/carousel, category rail, featured products grid)
- [ ] Finish Product Listing / Category screen with grid layout and sort control
- [ ] Finish Product Details screen (image gallery, size/variant selector, description, add-to-cart)
- [ ] Finish Search screen shell (input, recent searches, empty state)
- [ ] Finish Wishlist screen shell
- [ ] Finish Cart screen shell
- [ ] Finish Profile screen shell
- [ ] Build shared component library (PrimaryButton, SecondaryButton, AppTextField, ProductCard, SectionHeader, EmptyStateView, LoadingIndicator, ErrorStateView)

### Phase 2 — UI Polish (0%)

- [ ] Spacing/alignment pass across all screens (4/8/12/16/24/32/48 scale)
- [ ] Skeleton loaders for all data-driven screens
- [ ] Empty states for wishlist, cart, search, orders
- [ ] Hero animations between product grid and product detail
- [ ] Wishlist heart micro-interaction and cart badge animation
- [ ] Accessibility pass (contrast + tap targets)

### Phase 3 — Navigation & User Experience (0%)

- [ ] Custom Bottom Navigation Bar (Home, Search, Wishlist, Cart, Profile)
- [ ] Live Cart Badge and Wishlist Badge
- [ ] Animated active tab indicator
- [ ] IndexedStack for per-tab navigation state preservation
- [ ] Smooth transition animations between screens
- [ ] Hero animations across full navigation flow
- [ ] Haptic feedback on tab switches and key actions
- [ ] Navigation persistence (resume to same tab/scroll position after backgrounding)

### Phase 4 — Architecture Cleanup (0%)

- [ ] Create `core/` and `features/` folders per Section 4.5
- [ ] Move each screen into its feature folder's `presentation/` layer
- [ ] Define domain entities and repository interfaces per feature
- [ ] Stub Data layer repositories returning mock data
- [ ] Select and integrate state management package (Riverpod / Bloc TBD)
- [ ] Re-run `flutter analyze` and fix all import/path issues

### Phase 5 — Supabase Setup (0%)

- [ ] Create Supabase project (region, URL, anon key)
- [ ] Enable email/password auth provider
- [ ] Create initial database schema/namespace
- [ ] Create storage buckets (product-images, avatars) with public/private rules
- [ ] Store Supabase URL and anon key via `.env` / `--dart-define`
- [ ] Add `supabase_flutter` and initialize in `main.dart`
- [ ] Write connection smoke test

### Phase 6 — Authentication (0%)

- [ ] Signup with Supabase email/password
- [ ] Login with Supabase sign-in
- [ ] Logout and clear locally cached user state
- [ ] Forgot Password email flow
- [ ] Email Verification with pending-verification UI state
- [ ] Session persistence and restoration on app launch
- [ ] Auto-create profiles row on signup (trigger or client-side)
- [ ] Add role column on profiles for future admin/staff distinction

### Phase 7 — Database Design (0%)

- [ ] Model and create all core tables (profiles, categories, brands, products, product_images, favorites, carts, cart_items, orders, order_items, addresses, reviews, coupons, notifications)
- [ ] Define foreign key relationships
- [ ] Write Row Level Security policies per table
- [ ] Add indexes on frequently filtered/joined columns
- [ ] Seed database with realistic sample data
- [ ] Commit migration files to repo

### Phase 8 — Home, Categories & Products (0%)

- [ ] Implement GetCategories and GetFeaturedProducts use cases
- [ ] Wire Home screen carousel/rails to live data
- [ ] Implement GetProductsByCategory with pagination
- [ ] Wire Product Details screen to GetProductById use case
- [ ] Integrate `cached_network_image` for all product photography

### Phase 9 — Search & Filters (0%)

- [ ] Implement SearchProducts use case (ILIKE or full-text search)
- [ ] Build filter UI (category, brand, price range, size)
- [ ] Implement sort options (price asc/desc, newest)
- [ ] Persist recent searches in local storage
- [ ] Wire Search screen empty/loading/error states to real data

### Phase 10 — Wishlist (0%)

- [ ] Implement ToggleWishlist and GetWishlist use cases
- [ ] Wire wishlist heart icon to real state across Home, Listing, Detail
- [ ] Wire Wishlist screen to live data with empty state
- [ ] Add 'Move to Cart' action from wishlist

### Phase 11 — Cart & Checkout (0%)

- [ ] Implement AddToCart, UpdateCartItemQuantity, RemoveFromCart use cases
- [ ] Wire Cart screen and cart badge to live data
- [ ] Build address selection/entry backed by addresses table
- [ ] Integrate payment step (provider TBD)
- [ ] Implement PlaceOrder (convert cart → orders + order_items, clear cart)
- [ ] Handle out-of-stock/edge cases at checkout

### Phase 12 — Orders (0%)

- [ ] Implement GetOrderHistory and GetOrderById use cases
- [ ] Build Order History screen
- [ ] Build Order Detail screen
- [ ] Wire empty state for users with no orders

### Phase 13 — Profile (0%)

- [ ] Implement GetProfile and UpdateProfile use cases
- [ ] Build Profile screen (editable name, avatar via Supabase Storage, contact info)
- [ ] Build Manage Addresses screen (add/edit/delete)
- [ ] Account actions: change password, logout, delete account

### Phase 14 — Performance Optimization (0%)

- [ ] Profile widget rebuilds with Flutter DevTools
- [ ] Audit and optimize product grid/list scrolling performance
- [ ] Reduce cold start time
- [ ] Audit Supabase query patterns for N+1 over-fetching
- [ ] Compress/resize images and confirm caching effectiveness

### Phase 15 — Testing (0%)

- [ ] Unit tests for use cases (cart total, checkout, auth flows)
- [ ] Widget tests for critical shared components
- [ ] Manual E2E test: signup → browse → search → wishlist → cart → checkout → order → profile
- [ ] Test on small-screen and large-screen devices
- [ ] Fix all bugs and re-test

### Phase 16 — Deployment (0%)

- [ ] Generate signed release APK
- [ ] Generate signed AAB for Play Store
- [ ] Finalize public GitHub repository
- [ ] Write polished README
- [ ] Prepare portfolio entry
- [ ] Write case study
- [ ] Prepare Play Store listing assets

---

## 5. High Priority Next Steps

| Order | Task | Rationale |
|-------|------|-----------|
| 1 | **Complete Phase 1 — UI Completion** | All core screens must be visually complete before any backend work. This is the explicit current focus (Section 2.2). |
| 2 | **Phase 2 — UI Polish** | Elevate screens from functional to premium. Depends on Phase 1. |
| 3 | **Phase 3 — Navigation & UX** | Lock in the navigation shell before architecture refactor. Depends on Phases 1–2. |
| 4 | **Phase 4 — Architecture Cleanup** | Refactor into Clean Architecture before Supabase integration. Depends on Phases 1–3. |
| 5 | **Phase 5 — Supabase Setup** | Foundation for all backend features. Depends on Phase 4. |
| 6 | **Phase 6 — Authentication** | Gates all user-specific features (wishlist, cart, orders, profile). Depends on Phase 5. |
| 7 | **Phase 7 — Database Design** | Full schema must exist before feature phases 8–13. Depends on Phases 5–6. |

---

## 6. Potential Issues

### Missing Requirements / Unclear Items

1. **State management not decided.** Section 5.8 and Phase 4.28 say "Riverpod / Bloc (TBD)" — this must be finalized in the Decision Log (Section 15) before Phase 4. No entry exists yet.
2. **Payment provider not selected.** Phase 11.67 says "provider selection deferred to Section 9/Decision Log." The Decision Log (Section 15) has no payment entry. This is a blocker for Phase 11.
3. **No Figma/design file linked.** Section 16.5 says "Figma / design file (link here if used)" but no link is provided. Without a design reference, pixel-perfect polish in Phase 2 may be ambiguous.
4. **No GitHub repository linked.** Section 16.5 placeholder is empty. Not a current blocker but needed for Phase 16.

### Possible Blockers

5. **Solo-developer time constraints.** Section 10 identifies this as a medium-impact risk. The 16-phase roadmap represents a substantial body of work for one person.
6. **Payment integration complexity/cost.** Section 10 flags this. If no provider is chosen before Phase 11, it could delay the most business-critical phase.
7. **RLS misconfiguration risk.** Section 10 flags high impact. Must be explicitly tested during Phase 7 and Phase 15.

### Technical Debt / Refactoring Risks

8. **Navigation built before architecture cleanup.** Phase 3 (Navigation) lands before Phase 4 (Architecture Cleanup) by design. This means navigation code will need to be reorganized in Phase 4 — expect some refactoring overhead.
9. **Auth UI built before real auth.** The login/signup UI was built in Phase 1 with mock logic. Phase 6 will need to replace mock calls with real Supabase calls — verify no hardcoded mock logic leaks through.
10. **Shared component library incomplete.** Task 8 in Phase 1 (build shared component library) is listed but the "UI Foundation established (design tokens, base widgets)" in Section 2.1 suggests partial completion. Confirm which components are done and which remain.

### Inconsistent / Outdated Items

11. **Progress percentages are illustrative.** Section 2.3 explicitly states "Percentages are illustrative starting values." The Phase 1 tracker shows 55% but no detailed per-task breakdown exists to validate this.
12. **No dates in Progress Tracker.** Section 12 has empty Start Date / End Date columns for all phases. No timeline tracking is active.
13. **Development Notes are empty.** Section 13 has four blank entry templates with no actual entries. No day-to-day progress is being logged.
14. **AI Prompt Log is empty.** Section 14 has no entries.
15. **Decision Log is empty.** Section 15 has only placeholder examples. No real decisions have been recorded.
16. **Future Enhancements (Section 9) overlap with reserved database tables.** Coupons and Reviews tables are reserved in Section 7.7 but features are deferred. This is intentional but should be noted to avoid confusion during schema work.

---

## 7. Suggested Development Order

### Milestone 1 — UI Foundation Complete (Phases 1–2)

1. Complete all Phase 1 screen implementations (Home, Product Listing, Product Details, Search shell, Wishlist shell, Cart shell, Profile shell)
2. Complete shared component library
3. Run `flutter analyze` — zero warnings
4. Phase 2: spacing/alignment pass, skeleton loaders, empty states, hero animations, micro-interactions, accessibility

### Milestone 2 — Navigation & Architecture Locked (Phases 3–4)

5. Phase 3: Build custom bottom nav, tabs, badges, IndexedStack, transitions, haptics, persistence
6. Phase 4: Refactor to Clean Architecture (feature-first folders, domain/data/presentation layers, state management selection)
7. Verify app runs end-to-end on mock data after refactor

### Milestone 3 — Backend Online (Phases 5–7)

8. Phase 5: Create Supabase project, env vars, initialize client, smoke test
9. Phase 6: Full auth lifecycle (signup, login, logout, forgot password, email verification, session persistence, profile creation)
10. Phase 7: Complete database schema, RLS policies, indexes, seed data

### Milestone 4 — Core Shopping Experience Live (Phases 8–11)

11. Phase 8: Home, Categories, Products wired to live Supabase data
12. Phase 9: Search and filters with real data
13. Phase 10: Wishlist with real data
14. Phase 11: Cart & Checkout (highest business risk — budget extra time)

### Milestone 5 — Full Feature Set Complete (Phases 12–13)

15. Phase 12: Order history and order detail
16. Phase 13: Profile management, addresses, account actions

### Milestone 6 — Release Ready (Phases 14–16)

17. Phase 14: Performance optimization (DevTools profiling, cold start, image caching)
18. Phase 15: Unit tests, widget tests, manual E2E testing
19. Phase 16: Signed builds, README, case study, portfolio, Play Store prep

---

## 8. Final Checklist

### Phase 1 — UI Completion

- [ ] Finish Home screen (hero banner/carousel, category rail, featured products grid)
- [ ] Finish Product Listing / Category screen with grid layout and sort control
- [ ] Finish Product Details screen (image gallery, size/variant selector, description, add-to-cart)
- [ ] Finish Search screen shell (input, recent searches, empty state)
- [ ] Finish Wishlist screen shell
- [ ] Finish Cart screen shell
- [ ] Finish Profile screen shell
- [ ] Build shared component library (PrimaryButton, SecondaryButton, AppTextField, ProductCard, SectionHeader, EmptyStateView, LoadingIndicator, ErrorStateView)
- [ ] All core screens exist and are reachable via navigation
- [ ] Every screen uses AppColors and AppTextStyles — zero hardcoded styling
- [ ] Every screen is wrapped/scaled with ScreenUtil correctly
- [ ] Shared widgets are extracted, not duplicated per screen
- [ ] `flutter analyze` passes clean
- [ ] Every core screen reviewed against Section 6 design guidelines
- [ ] No TODO placeholders left in shipped screens

### Phase 2 — UI Polish

- [ ] Spacing/alignment pass across all screens (4/8/12/16/24/32/48 scale)
- [ ] Skeleton loaders on Home, Listing, Search, Orders
- [ ] Empty states for Wishlist, Cart, Search, Orders
- [ ] Hero/shared-element transitions between grid and detail views
- [ ] Wishlist heart micro-interaction and cart badge animation
- [ ] Accessibility pass (contrast + tap targets)
- [ ] No screen shows a raw spinner-only loading state
- [ ] `flutter analyze` clean

### Phase 3 — Navigation & User Experience

- [ ] Custom Bottom Navigation Bar built and styled to spec
- [ ] Home, Search, Wishlist, Cart, Profile tabs implemented
- [ ] Live Cart Badge and Wishlist Badge
- [ ] Animated active tab indicator
- [ ] IndexedStack preserves per-tab navigation stacks
- [ ] Smooth transition animations between screens
- [ ] Hero animations across full navigation flow
- [ ] Haptic feedback on tab switches and key actions
- [ ] Navigation persistence (resume to correct tab/state after backgrounding)
- [ ] `flutter analyze` clean

### Phase 4 — Architecture Cleanup

- [ ] `core/` and `features/` folders created per Section 4.5
- [ ] Each screen moved into its feature folder's `presentation/` layer
- [ ] Domain entities and repository interfaces defined per feature
- [ ] Data layer repositories stubbed with mock data
- [ ] State management package selected and integrated
- [ ] One reference feature migrated to prove the pattern
- [ ] No feature imports another feature's internals directly
- [ ] No Presentation-layer file imports Supabase packages
- [ ] `flutter analyze` clean
- [ ] App still runs end-to-end on mock data

### Phase 5 — Supabase Setup

- [ ] Supabase project created and reachable
- [ ] Anon key and URL stored outside source control (.env in .gitignore)
- [ ] `supabase_flutter` initialized once at app startup
- [ ] Test call to Supabase succeeds from real device/emulator
- [ ] No secrets committed to Git history

### Phase 6 — Authentication

- [ ] Signup with Supabase email/password
- [ ] Login with Supabase sign-in
- [ ] Logout and clear locally cached user state
- [ ] Forgot Password email flow tested end-to-end
- [ ] Email Verification with pending-verification UI state
- [ ] Session persists across app restarts
- [ ] Profiles row created automatically for every new user
- [ ] Role column added on profiles
- [ ] Errors show clear, friendly UI messages
- [ ] `flutter analyze` clean

### Phase 7 — Database Design

- [ ] All core tables created (profiles, categories, brands, products, product_images, favorites, carts, cart_items, orders, order_items, addresses, reviews, coupons, notifications)
- [ ] Foreign key relationships defined
- [ ] Row Level Security policies written per table
- [ ] Indexes added on frequently filtered/joined columns
- [ ] Seed data loaded for development
- [ ] Migration files committed to repo
- [ ] RLS verified by cross-user access test

### Phase 8 — Home, Categories & Products

- [ ] GetCategories and GetFeaturedProducts use cases implemented
- [ ] Home screen renders real categories and featured products
- [ ] Category listing paginates correctly
- [ ] Product Details shows real images, price, and variant data
- [ ] `cached_network_image` integrated for all product photography
- [ ] No mock data remains
- [ ] Empty/error states trigger correctly
- [ ] `flutter analyze` clean

### Phase 9 — Search & Filters

- [ ] SearchProducts use case implemented against Supabase
- [ ] Filter UI built (category, brand, price range, size)
- [ ] Sort options implemented (price asc/desc, newest)
- [ ] Recent searches persist across app restarts
- [ ] Search and each filter individually tested
- [ ] Combined filter + search tested
- [ ] `flutter analyze` clean

### Phase 10 — Wishlist

- [ ] ToggleWishlist and GetWishlist use cases implemented
- [ ] Wishlist heart icon wired to real state across all screens
- [ ] Wishlist screen wired to live data with empty state
- [ ] 'Move to Cart' action from wishlist
- [ ] Wishlist state in sync across every screen
- [ ] Wishlist badge count updates immediately
- [ ] RLS confirmed (user cannot see another user's wishlist)
- [ ] `flutter analyze` clean

### Phase 11 — Cart & Checkout

- [ ] AddToCart, UpdateCartItemQuantity, RemoveFromCart use cases implemented
- [ ] Cart screen and cart badge wired to live data
- [ ] Address selection/entry backed by addresses table
- [ ] Payment step integrated (provider selected and configured)
- [ ] PlaceOrder implemented (cart → orders + order_items, cart cleared)
- [ ] Out-of-stock/edge case handling
- [ ] Cart totals calculate correctly
- [ ] Checkout handles first-time and returning users
- [ ] End-to-end purchase tested multiple times
- [ ] All monetary calculations verified
- [ ] `flutter analyze` clean

### Phase 12 — Orders

- [ ] GetOrderHistory and GetOrderById use cases implemented
- [ ] Order History screen built
- [ ] Order Detail screen built
- [ ] Empty state wired for users with no orders
- [ ] Order history lists only current user's orders (RLS-verified)
- [ ] Order detail matches what was placed at checkout
- [ ] `flutter analyze` clean

### Phase 13 — Profile

- [ ] GetProfile and UpdateProfile use cases implemented
- [ ] Profile screen built (editable name, avatar, contact info)
- [ ] Manage Addresses screen built (add/edit/delete)
- [ ] Account actions: change password, logout, delete account
- [ ] Profile edits persist to Supabase
- [ ] Avatar upload/replace works
- [ ] Address CRUD works and reflects at checkout
- [ ] RLS confirmed on profiles and addresses
- [ ] `flutter analyze` clean

### Phase 14 — Performance Optimization

- [ ] Widget rebuilds profiled and optimized
- [ ] Product list scrolling holds ~60fps on mid-range device
- [ ] Cold start meets <2.5s criterion
- [ ] Supabase query patterns audited (no N+1 over-fetching)
- [ ] Images compressed/resized, caching confirmed effective
- [ ] Before/after performance benchmarks recorded

### Phase 15 — Testing

- [ ] Unit tests for all cart/checkout/auth use cases
- [ ] Widget tests for core shared components
- [ ] Full manual E2E pass completed with no blocking bugs
- [ ] Tested on small-screen and large-screen devices
- [ ] All planned tests pass
- [ ] No known critical or high-severity bugs remain

### Phase 16 — Deployment

- [ ] Signed APK builds successfully and installs/runs correctly
- [ ] Signed AAB builds successfully and installs/runs correctly
- [ ] Public GitHub repository finalized (clean history, structure, LICENSE)
- [ ] Polished README written and reviewed
- [ ] Portfolio entry drafted
- [ ] Case study written
- [ ] Play Store listing assets prepared (screenshots, feature graphic, descriptions, privacy policy)
- [ ] Fresh install of release build tested on clean device
- [ ] API keys and service-role keys excluded from public repo

### Cross-Cutting Concerns

- [ ] Decision Log (Section 15) updated with state management choice
- [ ] Decision Log updated with payment provider selection
- [ ] Development Notes (Section 13) actively maintained
- [ ] Progress Tracker (Section 12) updated with dates as phases complete
- [ ] `.env` / secrets in `.gitignore` from Phase 5 onward
- [ ] `flutter analyze` passes with zero issues on every merged branch

---

## 9. Milestones Reference

| Milestone | Phases | Definition |
|---|---|---|
| **M1 — UI Foundation Complete** | 1–2 | Every core screen exists, is polished, and is reviewable as a clickable prototype. |
| **M2 — Navigation & Architecture Locked** | 3–4 | Navigation shell finalized and codebase refactored to Clean Architecture. |
| **M3 — Backend Online** | 5–7 | Supabase connected, authentication live, full schema and RLS in place. |
| **M4 — Core Shopping Experience Live** | 8–11 | Browse, search, wishlist, and a working cart/checkout are all functional against real data. |
| **M5 — Full Feature Set Complete** | 12–13 | Orders and Profile complete the customer-facing feature set. |
| **M6 — Release Ready** | 14–16 | Performance-optimized, tested, and packaged for release with full documentation. |

---

## 10. Risk Assessment

| Risk | Impact | Mitigation |
|---|---|---|
| Checkout/cart logic bug causes incorrect totals or lost orders | High | Extra unit test coverage (Phase 15); manual E2E testing repeated after every change to Phase 11 code. |
| RLS misconfiguration exposes another user's data | High | Explicit cross-user access tests during Phase 7 and again in Phase 15; enable RLS immediately on table creation. |
| Scope creep from Section 9 ideas delaying v1.0 | Medium | Section 9 items are explicitly out of scope until all 16 phases reach Definition of Done. |
| Solo-developer time constraints slow the timeline | Medium | Phases sized to be independently shippable; Section 11 milestones allow re-baselining without losing structure. |
| Performance issues in product image-heavy scrolling | Medium | Dedicated Phase 14 (Performance Optimization) before testing/release. |
| Payment provider integration complexity/cost | Medium | Provider decision logged in Section 15 (Decision Log) before Phase 11 begins; evaluate options early rather than mid-checkout-build. |
| Secrets accidentally committed to a public repo | High | `.env` in .gitignore from Phase 5 onward; explicit check before making the repo public in Phase 16. |
| Package/dependency breaking changes (Flutter/Supabase SDKs) | Low–Medium | Pin dependency versions; review changelogs before upgrading mid-project. |

---

## 11. Key Dependencies Between Phases

```
Phase 1 (UI Completion)
  └─> Phase 2 (UI Polish)
        └─> Phase 3 (Navigation & UX)
              └─> Phase 4 (Architecture Cleanup)
                    └─> Phase 5 (Supabase Setup)
                          ├─> Phase 6 (Authentication)
                          │     └─> Phase 7 (Database Design)
                          │           ├─> Phase 8 (Home, Categories & Products)
                          │           │     ├─> Phase 9 (Search & Filters)
                          │           │     ├─> Phase 10 (Wishlist) [also depends on Phase 6]
                          │           │     └─> Phase 11 (Cart & Checkout) [also depends on Phase 6]
                          │           │           └─> Phase 12 (Orders)
                          │           └─> Phase 13 (Profile) [also depends on Phase 6, 11]
                    └─> Phases 8–13 must all complete before:
                          └─> Phase 14 (Performance Optimization)
                                └─> Phase 15 (Testing)
                                      └─> Phase 16 (Deployment)
```

---

## 12. Database Schema Quick Reference

| Table | Purpose |
|---|---|
| `profiles` | User profile (extends auth.users) |
| `categories` | Product categories (nested via parent_id) |
| `brands` | Brand records |
| `products` | Core catalog items |
| `product_images` | Product photos (one-to-many) |
| `favorites` | Wishlist join table |
| `carts` | One active cart per user |
| `cart_items` | Cart line items |
| `orders` | Placed orders |
| `order_items` | Order line items (price snapshot) |
| `addresses` | Saved shipping/billing addresses |
| `reviews` | User reviews and ratings |
| `coupons` | Discount codes (future) |
| `notifications` | In-app notifications (future) |

---

## 13. Technology Stack

| Technology | Role |
|---|---|
| Flutter | Cross-platform UI framework |
| Dart | Application language |
| Supabase | Backend-as-a-Service (Postgres, Auth, Storage, Realtime) |
| flutter_screenutil | Responsive sizing |
| Git / GitHub | Version control and portfolio hosting |
| VS Code / Android Studio | Development environments |
| Riverpod / Bloc (TBD) | State management |
| cached_network_image (future) | Image caching |
| go_router (future) | Declarative navigation |

---

## 14. Usage Instructions for AI Assistants

1. **Read this file first** to understand current project state, completed work, and active blockers.
2. **Read [ROADMAP.md](./ROADMAP.md)** for the full implementation roadmap, design guidelines, architecture details, and phase-by-phase task breakdowns.
3. **Before implementing any feature**, check the phase dependencies in Section 11 and confirm the prerequisite phases are complete.
4. **Before starting work**, update the Progress Tracker in ROADMAP.md with the current date.
5. **After completing work**, update this file to reflect newly completed features and remaining tasks.
6. **Never mark something as completed** unless the roadmap clearly indicates it is done.
7. **If information is missing**, state that it is unknown instead of guessing.
8. **Run `flutter analyze`** after every change — zero warnings is the policy.
