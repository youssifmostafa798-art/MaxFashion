# M A X F A S H I O N

## PREMIUM FASHION E-COMMERCE

### Software Development Roadmap

A Software Development Plan for a Flutter + Supabase Mobile Application

**Version 1.0**

Built with Flutter • Supabase • Clean Architecture

| | |
|---|---|
| **Prepared By** | Youssif |
| **Role** | Founder & Lead Developer |
| **Date** | July 29, 2026 |
| **Platform** | Flutter (iOS & Android) |
| **Backend** | Supabase |
| **Document Status** | Living Document – Updated Throughout Development |

---

## Table of Contents

This roadmap is organized as a living Software Development Plan (SDP). Update the tracker and log sections as phases are completed.

1. [Project Overview](#1-project-overview)
2. [Current Project Status](#2-current-project-status)
3. [Technology Stack](#3-technology-stack)
4. [Software Architecture](#4-software-architecture)
5. [Development Standards](#5-development-standards)
6. [UI / UX Design Guidelines](#6-ui--ux-design-guidelines)
7. [Full Development Roadmap](#7-full-development-roadmap)
8. [Supabase Planning](#8-supabase-planning)
9. [Future Enhancements](#9-future-enhancements)
10. [Risk Assessment](#10-risk-assessment)
11. [Milestones](#11-milestones)
12. [Progress Tracker](#12-progress-tracker)
13. [Development Notes](#13-development-notes)
14. [AI Prompt Log](#14-ai-prompt-log)
15. [Decision Log](#15-decision-log)
16. [Appendix](#16-appendix)

---

## 1. Project Overview

### 1.1 Project Vision

MaxFashion exists to bring a genuinely premium, editorial shopping experience to mobile fashion e-commerce. Where most fashion apps default to busy, promo-driven layouts, MaxFashion is built around restraint: a monochrome, gallery-like interface that lets product photography carry the story. The long-term vision is an app that feels closer to a boutique flagship store than a marketplace — curated, confident, and fast.

### 1.2 Project Goal

Deliver a fully functional, production-ready Flutter shopping application — covering browsing, search, wishlist, cart, checkout, and order tracking — backed by a secure and scalable Supabase backend, built to a standard suitable for a public portfolio, a client handoff, or a real launch.

### 1.3 Target Audience

- Style-conscious shoppers aged 18–35 who value minimal, high-quality design over cluttered marketplace UX.
- Mobile-first buyers who expect the speed and polish of flagship retail apps.
- Early adopters of a single-brand or curated-multi-brand fashion catalog rather than a mass marketplace.

### 1.4 Business Idea

MaxFashion operates as a direct-to-consumer fashion storefront: a curated product catalog organized by category and brand, with a streamlined path from discovery to checkout. The Supabase backend supports authentication, product and inventory data, order management, and secure row-level access control, making the same foundation reusable for a single-brand store or a small curated multi-brand catalog.

### 1.5 Expected User Experience

- Open the app to a fast, distraction-free home screen — not a wall of banners.
- Browse by category or brand with confident, image-led product grids.
- Search and filter without friction; results feel instant.
- Save items to a wishlist and move fluidly into a simple, trustworthy checkout.
- Track orders and manage a profile without hunting through menus.

### 1.6 Project Scope

In scope for the version 1.0 release:

- ☐ Customer-facing shopping app (browse, search, filter, wishlist, cart, checkout, orders, profile).
- ☐ Supabase-backed authentication, product catalog, cart, and order management.
- ☐ Clean Architecture codebase organized by feature.
- ☐ Responsive layout using flutter_screenutil across common device sizes.
- ☐ Release-ready Android build (APK/AAB); iOS build path documented for future release.

### 1.7 Out of Scope

Explicitly deferred beyond version 1.0 (see Section 9, Future Enhancements, for the longer-term list):

- Seller/vendor-facing admin dashboard (a lightweight admin surface may live directly in Supabase Studio initially).
- Native payment gateway integration beyond a single provider for launch.
- Multi-language / localization support.
- AI-driven recommendations and voice search.

### 1.8 Success Criteria

| Criterion | Definition of Success |
|---|---|
| Functional completeness | All 16 roadmap phases reach Definition of Done. |
| Stability | No crash-level bugs in core purchase flow (browse → cart → checkout → order). |
| Performance | Cold start under ~2.5s on a mid-range device; smooth 60fps scrolling on product lists. |
| Code quality | flutter analyze passes with zero warnings on every merged branch. |
| Design integrity | UI matches the Minimal Fashion design language defined in Section 6. |
| Portfolio-readiness | Public GitHub repo, README, and case study are release-ready (Phase 16). |

---

## 2. Current Project Status

This section reflects a snapshot of progress and should be updated as phases close. See Section 12 (Progress Tracker) for the full phase-by-phase table.

### 2.1 Completed Work

- ✓ Flutter project structure scaffolded.
- ✓ UI Foundation established (design tokens, base widgets).
- ✓ All core screens built (Home, Product Listing, Product Detail, Search, Cart, Checkout, Orders, Wishlist, Profile, Settings).
- ✓ Authentication UI (Login / Signup screens) built.
- ✓ App Theme configured with light/dark support.
- ✓ Centralized App Colors (no hardcoded colors in UI code).
- ✓ flutter_screenutil integrated for responsive sizing.
- ✓ Navigation flow wired between core screens.
- ✓ Supabase project created and configured.
- ✓ `supabase_flutter` and `flutter_dotenv` packages integrated.
- ✓ `.env` files created (root and scripts).
- ✓ Supabase initialized in `main.dart` with connection test in splash.
- ✓ Full Supabase Authentication (signUp, signIn, signOut, session restore, email confirmation).
- ✓ Profile CRUD on `profiles` table, avatar upload/remove via Supabase Storage.
- ✓ `SupabaseProductRepository` created and wired into `productRepositoryProvider`.
- ✓ SQL migrations for `categories`, `products`, `product_images`, `product_sizes`.
- ✓ Import scripts for data seeding.

### 2.2 Current Focus

**Now** — Completing Phase 3.3 (Products): verifying Supabase data population, migrating `categoriesProvider` to Supabase, replacing the hardcoded category lookup, and adding `cached_network_image` for network product images.

### 2.3 Visual Progress Summary

| Area | Progress |
|---|---|
| Overall Roadmap Completion (Phases 1–16) | 45% |
| UI Layer (Phases 1–4) | 90% |
| Backend Integration (Phases 5–7) | 70% |
| Core Shopping Features (Phases 8–13) | 30% |
| Hardening & Release (Phases 14–16) | 0% |

> Percentages updated from audit — update them in Section 12 as each phase is checked off.

---

## 3. Technology Stack

Every tool in this stack was chosen for a specific reason — not by default. The table below documents the decision, not just the choice.

| Technology | Role | Why It Was Selected |
|---|---|---|
| Flutter | Cross-platform UI framework | Single codebase for iOS and Android with native-level performance and a rich widget system suited to a highly custom, design-led UI. |
| Dart | Application language | Flutter's native language; sound null safety and strong tooling reduce runtime errors. |
| Supabase | Backend-as-a-Service (Postgres, Auth, Storage, Realtime) | Gives a real relational database (Postgres) with Row Level Security, built-in auth, and file storage — avoiding a custom backend while keeping full SQL control. |
| flutter_screenutil | Responsive sizing | Ensures consistent spacing, font sizes, and layout across the wide range of Android/iOS screen sizes. |
| Git | Version control | Industry-standard history tracking, branching, and safe collaboration. |
| GitHub | Remote repository & portfolio host | Central home for source history, issues, and the public-facing case study (Phase 16). |
| VS Code | Primary editor | Lightweight, fast Flutter/Dart tooling with strong extension support. |
| Android Studio | Android tooling & emulator | Required for Android SDK management, emulator testing, and native build debugging. |
| Riverpod / Bloc (TBD) | State management (future package) | A predictable, testable state layer will be selected in Phase 4 once architecture is finalized — see Section 5.8. |
| cached_network_image (future) | Image loading & caching | Product photography is central to the app; caching keeps scrolling smooth and reduces bandwidth. |
| go_router (future) | Declarative navigation (future package) | Needed once nested navigation (bottom nav + stacks) grows beyond simple Navigator.push calls — see Phase 3. |

> **Note:** Package choices marked "future" are placeholders. Confirm the final choice in the Decision Log (Section 15) before adopting it project-wide.

---

## 4. Software Architecture

### 4.1 Clean Architecture

MaxFashion follows Clean Architecture principles: each feature is split into three layers — Presentation, Domain, and Data — with dependencies pointing inward. The UI never talks to Supabase directly; it goes through the Domain layer, which keeps business logic testable and backend-agnostic.

### 4.2 Feature-First Organization

Rather than grouping files by type across the whole app (all screens together, all models together), MaxFashion groups files by feature. Each feature folder is self-contained and owns its own presentation, domain, and data layers, which keeps the codebase navigable as it grows.

### 4.3 The Three Layers

**Data Layer**

- Models (DTOs) that map Supabase rows to Dart objects.
- Data sources (remote — Supabase client calls; local — cache if needed).
- Repository implementations that satisfy the Domain layer's repository contracts.

**Domain Layer**

- Entities — pure Dart objects with no Flutter or Supabase dependencies.
- Repository interfaces (abstract contracts).
- Use cases — one class per business action (e.g. GetProducts, AddToCart, PlaceOrder).

**Presentation Layer**

- Screens and widgets.
- State management (controllers/providers/blocs depending on the choice made in Phase 4).
- No direct Supabase calls — ever. The UI only calls use cases.

### 4.4 Dependency Flow

**Rule:** Presentation → Domain ← Data. The Domain layer depends on nothing. Data and Presentation both depend on Domain, never on each other directly.

### 4.5 Recommended Project Structure

```
lib/
├── core/
│   ├── constants/        # AppColors, AppTextStyles, AppSizes
│   ├── theme/            # ThemeData, light/dark themes
│   ├── utils/            # validators, formatters, extensions
│   ├── widgets/          # shared reusable widgets
│   ├── routing/          # go_router config, route names
│   └── errors/           # Failure classes, exception mapping
├── features/
│   ├── auth/
│   │   ├── data/         # models, datasources, repository impl
│   │   ├── domain/       # entities, repository contract, use cases
│   │   └── presentation/ # screens, widgets, state
│   ├── home/
│   ├── products/
│   ├── search/
│   ├── wishlist/
│   ├── cart/
│   ├── orders/
│   └── profile/
├── services/             # Supabase client setup, env config
└── main.dart
```

Each feature's internal structure mirrors this pattern, e.g. `features/products/data/`, `features/products/domain/`, `features/products/presentation/`.

---

## 5. Development Standards

These standards exist to keep a solo-developed, long-running project consistent from the first commit to the last. Every rule here should be enforceable by code review or by `flutter analyze`.

### 5.1 Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Files & folders | snake_case | `product_details_screen.dart` |
| Classes / Widgets / Enums | UpperCamelCase | `ProductDetailsScreen`, `OrderStatus` |
| Variables & functions | lowerCamelCase | `fetchProducts()`, `isLoading` |
| Constants | lowerCamelCase with k prefix (or const class) | `kDefaultPadding` |
| Providers / Blocs | FeatureNameProvider / FeatureNameBloc | `CartProvider`, `CheckoutBloc` |
| Supabase tables | snake_case, plural | `products`, `cart_items`, `order_items` |

### 5.2 Folder Structure Rules

- A new feature always gets its own folder under `lib/features/` with `data/domain/presentation` subfolders.
- Nothing in `core/` may import from `features/` — core is shared foundation only, never feature-specific.
- Shared widgets used by 2+ features move to `core/widgets/`; single-feature widgets stay local to that feature.

### 5.3 Widget Design Principles

- Prefer small, single-purpose widgets over large `build()` methods.
- Stateless by default; only use StatefulWidget (or state management) when local UI state is genuinely needed.
- Extract any widget reused more than once into its own class — not a private `_build` method.
- Keep business logic out of widgets; widgets call use cases / providers, they don't contain decisions.

### 5.4 Reusable Components

A shared component library lives in `core/widgets/`, including at minimum: `PrimaryButton`, `SecondaryButton`, `AppTextField`, `ProductCard`, `SectionHeader`, `EmptyStateView`, `LoadingIndicator`, and `ErrorStateView`. New screens should assemble from this library before creating one-off widgets.

### 5.5 Theme Usage

- All text styles come from `AppTextStyles` (core/constants) — no inline `TextStyle()` with hardcoded values in screens.
- All spacing/padding uses ScreenUtil extensions (`.w`, `.h`, `.r`, `.sp`) — never raw pixel values.
- Dark mode is out of scope for v1.0 (see Section 9) but the theme should stay centralized to make it feasible later.

### 5.6 Color Management

- Every color reference goes through `AppColors` — no `Color(0xFF...)` literals inside widgets.
- New colors are added to `AppColors` first, with a short comment on intended usage, before being used anywhere.

### 5.7 ScreenUtil Rules

- Initialize `ScreenUtilInit` once at the root of the app with the design's reference size (e.g. 375x812).
- Use `.sp` for font sizes, `.w/.h` for spacing and sizing, `.r` for radii — consistently, not mixed with raw values.

### 5.8 State Management Principles

The specific package (Riverpod, Bloc, etc.) is confirmed in Phase 4, but regardless of package the same principles apply:

- UI reads state; UI never mutates state directly — it calls a method on the controller/notifier/bloc.
- Each feature owns its own state objects; no single global God-state.
- Loading / success / error are explicit states, not booleans scattered across a widget.

### 5.9 Code Review Checklist

- ☐ `flutter analyze` passes with zero issues.
- ☐ No hardcoded colors, sizes, or magic strings.
- ☐ New widgets are stateless where possible.
- ☐ No Supabase calls inside the presentation layer.
- ☐ Naming matches the conventions in Section 5.1.
- ☐ Commit message follows the convention in Section 5.11.

### 5.10 Flutter Analyze Policy

**Policy:** `flutter analyze` must return zero issues before any branch is merged into main. Warnings are not acceptable exceptions — fix or explicitly suppress with a documented reason.

### 5.11 Git Commit Conventions

Conventional Commits format is used throughout:

- `feat:` add wishlist toggle to product card
- `fix:` correct cart badge count after checkout
- `refactor:` extract ProductCard from home screen
- `docs:` update roadmap phase 5 notes
- `chore:` bump supabase_flutter version

### 5.12 Branch Strategy

| Branch | Purpose |
|---|---|
| `main` | Always buildable, release-ready code only. |
| `develop` | Integration branch for completed, tested features. |
| `feature/<name>` | One branch per feature or phase task, merged into develop via PR. |
| `release/<version>` | Cut from develop when preparing a store release (Phase 16). |

---

## 6. UI / UX Design Guidelines

MaxFashion's design philosophy in one line: **let the clothes speak.** Every screen should feel Luxury, Minimal, Fashion-forward, Black & White, and Modern.

### 6.1 Design Philosophy

| Principle | In Practice |
|---|---|
| Luxury | Generous white space, restrained color, high-quality imagery treated as the hero of every screen. |
| Minimal | No unnecessary chrome, badges, or decoration; every element earns its place. |
| Fashion-forward | Editorial-style grids and typography inspired by fashion lookbooks, not generic marketplace UI. |
| Black & White | A near-monochrome palette (black, white, warm greys) with a single restrained accent used sparingly. |
| Modern | Contemporary Flutter UI patterns — smooth motion, soft shadows, rounded geometry used with intent. |
| Premium | Consistent polish: no unstyled default widgets, no placeholder-looking screens. |

### 6.2 Typography

- One primary typeface family across the app; weight (not extra fonts) creates hierarchy.
- Headings: bold, generous size, tight letter-spacing for an editorial feel.
- Body copy: comfortable line-height (~1.4–1.5x) for readability over long descriptions.
- Prices and key CTAs get a distinct, consistent weight so they're scannable at a glance.

### 6.3 Spacing

Spacing follows a consistent scale (e.g. 4 / 8 / 12 / 16 / 24 / 32 / 48, applied via ScreenUtil) rather than arbitrary values per screen. Generous outer margins reinforce the premium feel; internal spacing stays tight and intentional.

### 6.4 Animation Philosophy

- Motion is subtle and purposeful — easing transitions, not bouncy or playful effects.
- Hero animations connect product grid → product detail for spatial continuity.
- Loading and state transitions use gentle fades/slides rather than abrupt swaps.

### 6.5 Responsive Design

All screens are built against a defined reference size via `flutter_screenutil` and verified on at least a small phone, a standard phone, and a tablet-width emulator before a phase is marked done.

### 6.6 Accessibility

- Minimum tappable target size of 44x44 logical pixels for all interactive elements.
- Sufficient contrast between text and background even within a monochrome palette (verify against WCAG AA).
- Semantic labels on icons and images for screen reader support.

### 6.7 Loading States

Every data-driven screen defines a loading state — skeleton placeholders for grids/lists rather than a single centered spinner, to keep perceived performance high.

### 6.8 Empty States

Empty wishlist, empty cart, empty search results, and empty order history each get a purpose-built empty state: a short message, an icon or illustration consistent with the black & white theme, and a clear next action.

### 6.9 Error States

Network and server errors show a friendly message plus a retry action — never a raw exception string or a blank screen.

### 6.10 Micro-interactions

- Wishlist heart icon animates on toggle.
- Add-to-cart gives brief, confident visual feedback (e.g. cart badge count animates).
- Haptic feedback on key actions (add to cart, place order) on supported devices.

---

## 7. Full Development Roadmap

This is the operational core of the document: sixteen phases spanning UI, architecture, backend integration, feature delivery, and release. Each phase is self-contained, with dependencies noted so phases can be reordered if priorities shift — though the default sequence below reflects the recommended build order.

**How To Use This Section:** Work top to bottom by default. Check off tasks and Definition of Done items as they're completed, and mirror status into Section 12 (Progress Tracker).

---

### Phase 1 — UI Completion

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| Medium | 2–3 weeks | None — foundation phase. |

**Purpose:** Bring every core customer-facing screen to a visually complete, navigable state before any backend logic is introduced.

**Objectives:**

- Build all primary screens with static/mock data so the full app can be clicked through end-to-end.
- Establish every reusable widget the rest of the app will depend on.
- Confirm the Minimal Fashion visual language (Section 6) is applied consistently.

**Why This Phase Exists:** Building UI before backend integration means design problems are caught and fixed while they're cheap — before real data, loading states, and error handling add complexity on top.

**Tasks:**

1. Finish Home screen (hero banner/carousel, category rail, featured products grid).
2. Finish Product Listing / Category screen with grid layout and sort control.
3. Finish Product Details screen (image gallery, size/variant selector, description, add-to-cart).
4. Finish Search screen shell (input, recent searches, empty state).
5. Finish Wishlist screen shell.
6. Finish Cart screen shell.
7. Finish Profile screen shell.
8. Build the shared component library (buttons, cards, inputs, section headers) referenced in Section 5.4.

**Checklist:**

- ☐ All core screens exist and are reachable via navigation.
- ☐ Every screen uses AppColors and AppTextStyles — zero hardcoded styling.
- ☐ Every screen is wrapped/scaled with ScreenUtil correctly.
- ☐ Shared widgets are extracted, not duplicated per screen.

**Deliverables:** A clickable, mock-data-driven prototype covering the entire customer journey.

**Definition of Done:**

- ☐ `flutter analyze` passes clean.
- ☐ Every core screen reviewed against the Section 6 design guidelines.
- ☐ No TODO placeholders left in shipped screens.

> **Note:** This is the current focus phase (Section 2.2). Prioritize correctness of layout over pixel-perfect polish; polish is Phase 2.

---

### Phase 2 — UI Polish

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| Medium | 1–2 weeks | Phase 1 (UI Completion). |

**Purpose:** Elevate the completed UI from functional to premium — the difference between 'it works' and 'it feels expensive.'

**Objectives:**

- Apply consistent spacing, shadows, and corner radii across every screen.
- Add the motion and micro-interactions defined in Section 6.4 and 6.10.
- Finalize loading, empty, and error states for every screen (Section 6.7–6.9).

**Why This Phase Exists:** First impressions in a fashion app are almost entirely visual. This phase is what makes the app look like a real product rather than a wireframe.

**Tasks:**

9. Pass over every screen for spacing/alignment consistency against the 4/8/12/16/24/32/48 scale.
10. Add skeleton loaders to all data-driven screens.
11. Design and implement empty states for wishlist, cart, search, and orders.
12. Add hero animations between product grid and product detail.
13. Add wishlist heart micro-interaction and cart badge animation.
14. Verify color contrast and tap target sizes against Section 6.6 accessibility rules.

**Checklist:**

- ☐ Skeleton loading states implemented on Home, Listing, Search, Orders.
- ☐ Empty states implemented on Wishlist, Cart, Search, Orders.
- ☐ Hero/shared-element transitions working between grid and detail views.
- ☐ Accessibility pass complete (contrast + tap targets).

**Deliverables:** A polished UI ready to be wired to real data without further visual rework.

**Definition of Done:**

- ☐ Design guidelines in Section 6 fully satisfied.
- ☐ No screen shows a raw spinner-only loading state.
- ☐ `flutter analyze` clean.

> **Note:** Resist adding new screens in this phase — scope is refinement only.

---

### Phase 3 — Navigation & User Experience

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| Medium–High | 1–2 weeks | Phase 1 and Phase 2 (screens must exist and be polished first). |

**Purpose:** Replace ad-hoc navigation with a cohesive, persistent navigation shell built around a custom bottom navigation bar.

**Objectives:**

- Implement a five-tab custom Bottom Navigation Bar: Home, Search, Wishlist, Cart, Profile.
- Preserve each tab's navigation stack independently.
- Layer in the motion and feedback details that make navigation feel premium.

**Why This Phase Exists:** Navigation is the skeleton the rest of the app hangs on. Getting it right once, with IndexedStack-based state preservation, avoids painful rework once feature screens are wired to real data.

**Tasks:**

15. Build custom Bottom Navigation Bar UI matching the black & white design language.
16. Implement Home, Search, Wishlist, Cart, Profile tabs.
17. Implement a live Cart Badge (item count) and Wishlist Badge.
18. Build an Animated Indicator for the active tab.
19. Implement IndexedStack so each tab keeps its own navigation state when switching.
20. Add smooth, consistent transition animations between screens.
21. Extend Hero Animations across the full navigation flow, not just product detail.
22. Add Haptic Feedback on tab switches and key actions.
23. Implement Navigation Persistence (return to the same tab/scroll position after backgrounding the app).

**Checklist:**

- ☐ Bottom nav bar built and styled to spec.
- ☐ Cart and wishlist badges update live from state.
- ☐ Active tab indicator animates smoothly.
- ☐ IndexedStack preserves per-tab navigation stacks.
- ☐ Haptic feedback wired on supported devices.
- ☐ App resumes to the correct tab/state after backgrounding.

**Deliverables:** A production-grade navigation shell used by every subsequent feature phase.

**Definition of Done:**

- ☐ Switching tabs never loses scroll position or navigation stack.
- ☐ Badges reflect state changes within one frame of the underlying data changing.
- ☐ `flutter analyze` clean.

> **Note:** This phase intentionally lands before Architecture Cleanup so navigation patterns are proven before the codebase is restructured around them.

---

### Phase 4 — Architecture Cleanup

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| High | 1–2 weeks | Phases 1–3. |

**Purpose:** Refactor the UI-first codebase into the Clean Architecture structure defined in Section 4, before backend logic is introduced.

**Objectives:**

- Reorganize the project into the feature-first folder structure from Section 4.5.
- Introduce the Domain and Data layer scaffolding for every feature (even if Data is still mocked).
- Confirm and lock in the state management approach referenced in Section 5.8.

**Why This Phase Exists:** Refactoring before Supabase integration is far cheaper than after — once real data flows are wired to a messy structure, untangling it risks breaking working features.

**Tasks:**

24. Create `core/` and `features/` folders per Section 4.5.
25. Move each screen into its feature folder's `presentation/` layer.
26. Define domain entities and repository interfaces per feature.
27. Stub Data layer repositories returning mock data through the same interfaces the UI will eventually use for real.
28. Select and integrate the state management package (finalize the Section 5.8 placeholder).
29. Re-run `flutter analyze` and fix all import/path issues from the move.

**Checklist:**

- ☐ Folder structure matches Section 4.5 exactly.
- ☐ No feature imports another feature's internals directly.
- ☐ No Presentation-layer file imports Supabase packages.
- ☐ State management package installed and one reference feature migrated to prove the pattern.

**Deliverables:** A Clean-Architecture-compliant codebase ready for real backend wiring.

**Definition of Done:**

- ☐ All features follow the three-layer pattern.
- ☐ `flutter analyze` clean.
- ☐ App still runs end-to-end on mock data after the refactor.

> **Note:** Commit this phase in small, feature-by-feature PRs rather than one giant refactor commit — easier to review and revert if needed.

---

### Phase 5 — Supabase Setup

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| Low–Medium | 2–4 days | Phase 4 (Architecture Cleanup) should be in place so Supabase calls land in the Data layer correctly from the start. |

**Purpose:** Stand up the Supabase backend project and connect it to the Flutter app, broken into small, verifiable steps.

**Objectives:**

- Create and configure the Supabase project.
- Establish secure environment variable handling for API keys.
- Prove connectivity from Flutter before building any real feature on top of it.

**Why This Phase Exists:** Supabase is the foundation every remaining phase depends on. Small, individually testable steps here prevent a single misconfiguration from silently breaking every later phase.

**Tasks:**

30. **Create Project:** create a new Supabase project, choose region, note project URL and anon key.
31. **Authentication:** enable email/password auth provider in Supabase Auth settings.
32. **Database:** create the initial empty schema/namespace for MaxFashion tables (built out fully in Phase 7).
33. **Storage:** create a storage bucket for product and profile images with sensible public/private rules.
34. **Environment Variables:** store the Supabase URL and anon key using a `.env` approach (`flutter_dotenv` or `--dart-define`) — never hardcoded in source.
35. **Flutter Integration:** add `supabase_flutter`, initialize the client in `main.dart` before `runApp()`.
36. **Connection Testing:** write a simple smoke test (e.g. fetch the current session or a trivial query) to confirm the app can reach Supabase.

**Checklist:**

- ☐ Supabase project created and reachable.
- ☐ Anon key and URL stored outside source control (.env in .gitignore).
- ☐ `supabase_flutter` initialized once at app startup.
- ☐ A test call to Supabase succeeds from a real device/emulator.

**Deliverables:** A working, securely configured connection between the Flutter app and Supabase.

**Definition of Done:**

- ☐ Connection test passes on both Android emulator and a physical device (or two emulators).
- ☐ No secrets committed to Git history.

> **Note:** Double-check .env / secrets are excluded via .gitignore before the first commit that includes them.

---

### Phase 6 — Authentication

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| Medium | 1 week | Phase 5 (Supabase Setup). |

**Purpose:** Replace the mock Authentication UI (built in Phase 1) with real, secure Supabase-backed authentication.

**Objectives:**

- Implement the full account lifecycle: signup, login, logout, and password recovery.
- Create a profile record automatically on signup.
- Handle session persistence so users stay logged in across app restarts.

**Why This Phase Exists:** Authentication gates almost every other feature (wishlist, cart, orders, profile), so it needs to be correct and secure before those features are built on top of it.

**Tasks:**

37. **Signup:** implement Supabase email/password signup wired to the existing Signup UI.
38. **Login:** implement Supabase sign-in wired to the existing Login UI.
39. **Logout:** implement sign-out and clear any locally cached user state.
40. **Forgot Password:** implement Supabase password-reset email flow.
41. **Email Verification:** enable and handle Supabase email verification, with a pending-verification UI state.
42. **Session Handling:** persist and restore session on app launch using `supabase_flutter`'s session listener.
43. **Profile Creation:** auto-create a row in the `profiles` table on successful signup (via trigger or client-side call).
44. **Role Management:** add a `role` column on `profiles` for future admin/staff distinction, even if unused in v1.0.

**Checklist:**

- ☐ Signup, login, and logout all function against real Supabase auth.
- ☐ Forgot-password email flow tested end-to-end.
- ☐ Session persists across app restarts without requiring re-login.
- ☐ A `profiles` row is created automatically for every new user.

**Deliverables:** A fully functional authentication system backing every account-gated feature.

**Definition of Done:**

- ☐ All auth flows tested on a real Supabase project (not local mocks).
- ☐ Errors (wrong password, duplicate email, weak password) show clear, friendly UI messages.
- ☐ `flutter analyze` clean.

> **Note:** Consider Row Level Security policies on profiles now (see Phase 7.3) so a user can only read/update their own profile.

---

### Phase 7 — Database Design

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| High | 1–2 weeks | Phase 5 (Supabase Setup), Phase 6 (Authentication, for the profiles foreign key). |

**Purpose:** Design and implement the complete relational schema that powers the entire shopping experience.

**Objectives:**

- Define every table, its columns, and its relationships.
- Apply Row Level Security so users can only access data they're entitled to.
- Add indexes for the queries the app will run most often.

**Why This Phase Exists:** Every downstream feature phase (8–13) depends directly on this schema. Getting relationships and RLS right here avoids painful migrations later.

**Tasks:**

45. Model and create all core tables (see Section 7.7 table list).
46. Define foreign key relationships between tables.
47. Write Row Level Security policies per table (Section 7.7).
48. Add indexes on frequently filtered/joined columns.
49. Seed the database with realistic sample data for development.

**Checklist:**

- ☐ All tables from the schema exist with correct types and constraints.
- ☐ Foreign keys enforce referential integrity.
- ☐ RLS is enabled and tested on every user-data table.
- ☐ Sample/seed data loaded for local development and demos.

**Deliverables:** A production-grade Postgres schema, documented and version-controlled as SQL migration files.

**Definition of Done:**

- ☐ Schema reviewed against every feature phase's data needs (8–13).
- ☐ RLS verified by attempting cross-user access and confirming it's denied.
- ☐ Migration files committed to the repo.

> **Note:** Treat schema changes after this phase as migrations, not manual dashboard edits, so the schema stays reproducible.

---

#### 7.7 Suggested Tables

| Table | Purpose |
|---|---|
| `profiles` | One row per user; extends Supabase `auth.users` with name, avatar, role, contact info. |
| `categories` | Product categories (e.g. Outerwear, Footwear, Accessories); supports nested categories via a `parent_id`. |
| `brands` | Brand records shown on brand pages and product cards. |
| `products` | Core catalog item: name, description, price, `brand_id`, `category_id`, status. |
| `product_images` | One-to-many product photos, ordered for gallery display. |
| `favorites` | Join table linking a user to wishlisted products. |
| `carts` | One active cart per user. |
| `cart_items` | Line items within a cart: product, variant, quantity. |
| `orders` | A placed order: user, status, totals, timestamps. |
| `order_items` | Line items within an order, snapshotting price/variant at purchase time. |
| `addresses` | Saved shipping/billing addresses per user. |
| `reviews` | User reviews and ratings per product. |
| `coupons` | Discount codes and their rules (future-facing, see Section 9). |
| `notifications` | In-app notification records per user (future-facing, see Section 9). |

#### 7.8 Relationships

- `profiles.id` references `auth.users.id` (1:1) — Supabase-managed identity extended with app-specific fields.
- `products.category_id` references `categories.id`, `products.brand_id` references `brands.id` (many:1 each).
- `product_images.product_id` references `products.id` (many:1).
- `favorites` links `profiles.id` and `products.id` (many:many via a join table).
- `carts.user_id` references `profiles.id` (1:1 active cart); `cart_items.cart_id` references `carts.id` and `cart_items.product_id` references `products.id`.
- `orders.user_id` references `profiles.id` (many:1); `order_items.order_id` references `orders.id` and `order_items.product_id` references `products.id`.
- `addresses.user_id` references `profiles.id` (many:1) — a user may have multiple saved addresses.
- `reviews` links `profiles.id` and `products.id`, with a rating and comment (many:many via a join-style table).

#### 7.9 Row Level Security Strategy

| Table | RLS Policy Summary |
|---|---|
| `profiles` | A user may SELECT/UPDATE only the row where `id = auth.uid()`. |
| `categories / brands / products / product_images` | Public SELECT for all (even anonymous); INSERT/UPDATE/DELETE restricted to a service or admin role. |
| `favorites / carts / cart_items / addresses` | A user may SELECT/INSERT/UPDATE/DELETE only rows where `user_id` (or the parent cart's `user_id`) = `auth.uid()`. |
| `orders / order_items` | A user may SELECT only their own orders; INSERT happens via a controlled checkout flow; UPDATE restricted to admin/service role for status changes. |
| `reviews` | Public SELECT; INSERT/UPDATE/DELETE restricted to the review's own author (`user_id = auth.uid()`). |

> **Security Principle:** Enable RLS on every table by default the moment it's created — an unprotected table for even a few minutes in a public project is a real exposure risk.

#### 7.10 Indexes

- Index `products.category_id` and `products.brand_id` — the most common filter columns.
- Index `cart_items.cart_id` and `order_items.order_id` for fast line-item lookups.
- Index `favorites` on `(user_id, product_id)` as a composite — both the lookup and the uniqueness constraint.
- Add a text-search index (e.g. Postgres GIN/tsvector) on `products.name` and `products.description` to support Phase 9 search.

---

### Phase 8 — Home, Categories & Products

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| Medium–High | 1–2 weeks | Phase 7 (Database Design). |

**Purpose:** Wire the Home, Categories, and Product Listing/Detail screens to real Supabase data.

**Objectives:**

- Replace all mock product/category data with live Supabase queries.
- Implement product image loading with caching.
- Handle pagination for product lists.

**Why This Phase Exists:** This is the core browsing experience — the first real feature most users interact with, and the foundation search/filters (Phase 9) builds on.

**Tasks:**

50. Implement `GetCategories` and `GetFeaturedProducts` use cases.
51. Wire Home screen carousel/rails to live data.
52. Implement `GetProductsByCategory` with pagination.
53. Wire Product Details screen to a `GetProductById` use case, including images and variants.
54. Integrate `cached_network_image` for all product photography.

**Checklist:**

- ☐ Home screen renders real categories and featured products.
- ☐ Category listing paginates correctly without duplicate/missing items.
- ☐ Product detail screen shows real images, price, and variant data.
- ☐ Images are cached and don't re-download on every screen visit.

**Deliverables:** A fully live browsing experience from Home through to Product Detail.

**Definition of Done:**

- ☐ No mock data remains in these screens.
- ☐ Empty/error states from Section 6.8–6.9 trigger correctly on real failures.
- ☐ `flutter analyze` clean.

> **Note:** Use this phase to validate that the RLS policies on products/categories (public read) work as intended.

---

### Phase 9 — Search & Filters

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| Medium | 1 week | Phase 7, Phase 8. |

**Purpose:** Implement real-time product search with category, price, size, and brand filtering.

**Objectives:**

- Implement a fast text search against the product catalog.
- Add filter and sort controls.
- Persist recent searches locally.

**Why This Phase Exists:** In a catalog that will grow over time, search and filtering are how users actually find what they want instead of endlessly scrolling.

**Tasks:**

55. Implement `SearchProducts` use case against Supabase (ILIKE or full-text search).
56. Build filter UI: category, brand, price range, size.
57. Implement sort options (price asc/desc, newest).
58. Persist recent searches in local storage.
59. Wire the Search screen's empty/loading/error states to real data.

**Checklist:**

- ☐ Search returns relevant results within an acceptable delay.
- ☐ Filters combine correctly (e.g. category + price range together).
- ☐ Recent searches persist across app restarts.

**Deliverables:** A fully functional search and filter experience.

**Definition of Done:**

- ☐ Search and each filter individually tested against real seeded data.
- ☐ Combined filter + search tested for correctness.
- ☐ `flutter analyze` clean.

> **Note:** If catalog size grows significantly post-launch, revisit Postgres full-text search or a dedicated search index.

---

### Phase 10 — Wishlist

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| Low–Medium | 3–5 days | Phase 6 (Authentication), Phase 7, Phase 8. |

**Purpose:** Let signed-in users save and manage products they're interested in.

**Objectives:**

- Implement add/remove-to-wishlist backed by the `favorites` table.
- Sync the wishlist badge in the bottom nav with live state.
- Support moving a wishlist item directly into the cart.

**Why This Phase Exists:** Wishlist is a light-touch feature but a strong retention driver — it's often the difference between a one-time browse and a return visit.

**Tasks:**

60. Implement `ToggleWishlist` and `GetWishlist` use cases against the `favorites` table.
61. Wire the wishlist heart icon (Section 6.10) to real state across Home, Listing, and Detail screens.
62. Wire the Wishlist screen to live data with the empty state from Phase 2.
63. Add a 'Move to Cart' action from the wishlist.

**Checklist:**

- ☐ Wishlist state stays in sync across every screen showing the heart icon.
- ☐ Wishlist badge count updates immediately on toggle.
- ☐ Wishlist persists correctly per user (RLS-verified).

**Deliverables:** A fully functional, persistent wishlist feature.

**Definition of Done:**

- ☐ Toggling wishlist from any screen reflects instantly everywhere else.
- ☐ RLS confirmed — a user cannot see another user's wishlist.
- ☐ `flutter analyze` clean.

> **Note:** Reuse the `ProductCard` component from Section 5.4 rather than building a separate wishlist card.

---

### Phase 11 — Cart & Checkout

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| High | 2–3 weeks | Phase 6, Phase 7, Phase 8. |

**Purpose:** Implement the full cart management and checkout flow — the most business-critical feature in the app.

**Objectives:**

- Implement add/update/remove cart items backed by `carts` and `cart_items`.
- Build a clear, trustworthy checkout flow including address and payment step.
- Create an order from a completed checkout.

**Why This Phase Exists:** This is the revenue-generating core of the app. Every other feature exists to bring a user to this flow successfully.

**Tasks:**

64. Implement `AddToCart`, `UpdateCartItemQuantity`, `RemoveFromCart` use cases.
65. Wire the Cart screen and cart badge to live data.
66. Build address selection/entry backed by the `addresses` table.
67. Integrate a payment step (provider selection deferred to Section 9/Decision Log if not finalized).
68. Implement `PlaceOrder`, converting cart contents into `orders` and `order_items` and clearing the cart.
69. Handle out-of-stock/edge cases gracefully at checkout time.

**Checklist:**

- ☐ Cart totals (subtotal, any shipping/tax placeholder) calculate correctly.
- ☐ Checkout flow handles a first-time user (no saved address) and a returning user (saved address) correctly.
- ☐ Placing an order correctly creates `order` + `order_items` records and empties the cart.
- ☐ Stock/edge-case handling tested (e.g. item removed from catalog after being added to cart).

**Deliverables:** A complete, tested purchase flow from cart to confirmed order.

**Definition of Done:**

- ☐ End-to-end purchase tested multiple times without data inconsistency.
- ☐ All monetary calculations verified against seed data.
- ☐ `flutter analyze` clean.

> **Note:** This phase carries the highest business risk in the roadmap — budget extra testing time and consider it the priority phase if the schedule slips.

---

### Phase 12 — Orders

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| Low–Medium | 3–5 days | Phase 11 (Cart & Checkout). |

**Purpose:** Let users view their order history and track individual order status.

**Objectives:**

- Implement order history list and order detail views.
- Reflect order status changes clearly in the UI.

**Why This Phase Exists:** Post-purchase experience is what builds trust for a repeat customer — users need to be able to check on what they bought.

**Tasks:**

70. Implement `GetOrderHistory` and `GetOrderById` use cases.
71. Build Order History screen (list of past orders with status and total).
72. Build Order Detail screen (items, addresses, status, totals).
73. Wire empty state for users with no orders yet.

**Checklist:**

- ☐ Order history correctly lists only the current user's orders (RLS-verified).
- ☐ Order detail matches what was actually placed at checkout.
- ☐ Status displays clearly (e.g. Processing, Shipped, Delivered).

**Deliverables:** A complete order history and tracking experience.

**Definition of Done:**

- ☐ Order data displayed matches database records exactly.
- ☐ RLS confirmed for cross-user isolation.
- ☐ `flutter analyze` clean.

> **Note:** Live shipment tracking integration is deferred — see Section 9, Order Tracking.

---

### Phase 13 — Profile

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| Medium | 1 week | Phase 6, Phase 7, Phase 11 (addresses feed checkout). |

**Purpose:** Let users manage their account details, saved addresses, and app preferences.

**Objectives:**

- Build profile view/edit.
- Manage saved addresses.
- Provide account actions (logout, password change).

**Why This Phase Exists:** Profile ties the whole account experience together and is where users manage the information that powers checkout and orders.

**Tasks:**

74. Implement `GetProfile` and `UpdateProfile` use cases.
75. Build Profile screen with editable name, avatar (via Supabase Storage), and contact info.
76. Build Manage Addresses screen (add/edit/delete, backed by `addresses` table).
77. Add account actions: change password, logout, (optionally) delete account.

**Checklist:**

- ☐ Profile edits persist correctly to Supabase.
- ☐ Avatar upload/replace works against the Storage bucket from Phase 5.
- ☐ Address CRUD works and reflects immediately at checkout.

**Deliverables:** A complete account management experience.

**Definition of Done:**

- ☐ Profile and address changes verified end-to-end.
- ☐ RLS confirmed on `profiles` and `addresses`.
- ☐ `flutter analyze` clean.

> **Note:** Keep the avatar image pipeline consistent with the product image caching approach from Phase 8.

---

### Phase 14 — Performance Optimization

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| Medium | 1 week | Phases 8–13 (all core features implemented). |

**Purpose:** Systematically profile and optimize the app before entering the testing phase.

**Objectives:**

- Eliminate unnecessary rebuilds and jank in scrolling lists.
- Reduce cold start time.
- Optimize image loading and network usage.

**Why This Phase Exists:** A fashion app lives and dies by how good scrolling through product photography feels — performance work here directly protects the premium feel defined in Section 6.

**Tasks:**

78. Profile widget rebuilds with Flutter DevTools and eliminate unnecessary ones (const constructors, granular state).
79. Audit and optimize product grid/list scrolling performance.
80. Reduce cold start time (defer non-critical initialization, optimize splash-to-home path).
81. Audit Supabase query patterns for N+1-style over-fetching; add pagination where missing.
82. Compress/resize images appropriately and confirm caching is effective.

**Checklist:**

- ☐ DevTools shows no obvious excessive-rebuild widgets on core screens.
- ☐ Product list scrolling holds close to 60fps on a mid-range test device.
- ☐ Cold start measured and meets the Section 1.8 success criterion.

**Deliverables:** A measurably faster, smoother app ready for structured testing.

**Definition of Done:**

- ☐ Performance benchmarks recorded before/after for comparison.
- ☐ No known jank on the core purchase flow.

> **Note:** Record before/after metrics in Section 13 (Development Notes) for the portfolio case study in Phase 16.

---

### Phase 15 — Testing

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| Medium–High | 1–2 weeks | Phases 8–14. |

**Purpose:** Systematically verify correctness across unit, widget, and manual end-to-end testing before release.

**Objectives:**

- Cover critical business logic with unit tests.
- Cover key widgets with widget tests.
- Manually test the full purchase journey on real devices.

**Why This Phase Exists:** Cart and checkout logic (Phase 11) is the highest-risk area in the app — automated tests protect it from regressions as later phases and fixes are added.

**Tasks:**

83. Write unit tests for use cases (especially cart total calculation, checkout, and auth flows).
84. Write widget tests for critical shared components (`ProductCard`, cart item row, forms).
85. Manually test the full journey: signup → browse → search → wishlist → cart → checkout → order → profile.
86. Test on at least one small-screen and one large-screen device/emulator.
87. Fix all bugs found and re-test affected areas.

**Checklist:**

- ☐ Unit tests exist and pass for all cart/checkout/auth use cases.
- ☐ Widget tests exist and pass for core shared components.
- ☐ Full manual E2E pass completed with no blocking bugs.

**Deliverables:** A test-covered, manually verified app ready for deployment.

**Definition of Done:**

- ☐ All planned tests pass in CI or locally.
- ☐ No known critical or high-severity bugs remain open.

> **Note:** Log every bug found and its resolution in Section 13 (Development Notes) or a linked issue tracker.

---

### Phase 16 — Deployment

| Complexity | Estimated Time | Dependencies |
|---|---|---|
| Medium | 1 week | Phase 15 (Testing) must be complete. |

**Purpose:** Package, document, and release MaxFashion as a portfolio-ready and/or store-ready product.

**Objectives:**

- Produce signed release builds.
- Finalize public-facing documentation.
- Prepare Play Store listing materials.

**Why This Phase Exists:** This phase turns a finished codebase into something the world (a portfolio visitor, a recruiter, or real users) can actually see and use.

**Tasks:**

88. **Release APK:** generate a signed release APK for direct-install testing.
89. **Release AAB:** generate a signed Android App Bundle for Play Store submission.
90. **GitHub:** finalize the public repository — clean commit history, sensible structure, LICENSE if applicable.
91. **README:** write a polished README (overview, screenshots, tech stack, architecture summary, setup instructions).
92. **Portfolio:** prepare a portfolio entry summarizing the project, role, and outcomes.
93. **Case Study:** write a short case study covering the problem, approach, architecture decisions, and results (using Section 13/14 notes as source material).
94. **Play Store Preparation:** prepare listing assets — screenshots, feature graphic, short/long description, privacy policy link.

**Checklist:**

- ☐ Signed APK and AAB both build successfully and install/run correctly.
- ☐ README reviewed for clarity by someone unfamiliar with the project.
- ☐ Case study and portfolio entry drafted.
- ☐ Play Store assets prepared (even if submission is deferred).

**Deliverables:** A signed release build, a polished public repository, and complete portfolio/case-study materials.

**Definition of Done:**

- ☐ Fresh install of the release build tested on a clean device.
- ☐ README and case study proofread and published.
- ☐ Repository is public-portfolio-ready.

> **Note:** Keep API keys and Supabase service-role keys out of the public repository — double-check .gitignore before making the repo public.

---

## 8. Supabase Planning

### 8.1 Authentication Flow

Users sign up with email and password. On successful signup, a database trigger (or client-side call immediately after signup) creates a matching row in `profiles`. Sessions persist locally via `supabase_flutter`'s storage adapter and are restored automatically on app launch. Password recovery uses Supabase's built-in reset-password email flow.

### 8.2 Storage Strategy

- Two buckets: `product-images` (public read, admin write) and `avatars` (public read, owner write).
- Product images are uploaded via the admin workflow (Supabase Studio initially) rather than in-app.
- Avatar uploads go through a signed, size-limited upload path tied to the authenticated user.

### 8.3 Realtime Usage

Realtime is not required for v1.0 core flows but is a natural fit for future phases: live cart sync across devices, live order-status updates (Section 9, Order Tracking), and live notifications. Table replication for `orders` is the most likely first candidate if Realtime is adopted.

### 8.4 Database Policies

All access control is enforced at the database layer via Row Level Security (Section 7.9), not just in client code — the Flutter app is never the last line of defense. Any future admin tooling authenticates with a distinct role rather than reusing customer credentials.

### 8.5 Security

- RLS enabled on every table from the moment it is created.
- Anon key is safe to ship in the client only because RLS constrains what it can do; the service-role key is never bundled in the app.
- Secrets are managed via environment variables (Section 5's dependency on Phase 5.5) and excluded from version control.

### 8.6 Future Scalability

The current schema and RLS approach scale comfortably to a single-brand or small curated-multi-brand catalog. If MaxFashion grows toward a larger marketplace, the likely next steps are: dedicated search infrastructure, a caching layer in front of high-read tables (categories, featured products), and splitting admin operations into a separate authenticated surface.

---

## 9. Future Enhancements

Ideas explicitly deferred past version 1.0 (see Section 1.7, Out of Scope). Capturing them here keeps the roadmap focused now without losing the ideas for later.

| Enhancement | Value |
|---|---|
| Dark Mode | Broader accessibility and a modern expectation; theme is already centralized (Section 5.5) to make this feasible. |
| Push Notifications | Order status updates, wishlist price drops, and re-engagement. |
| AI Recommendations | Personalized 'you may also like' surfaces to increase discovery and basket size. |
| Voice Search | Faster, hands-free product discovery on mobile. |
| Order Tracking | Live shipment status, potentially via Realtime (Section 8.3) and a carrier integration. |
| Multi-language | Expands addressable market beyond a single-language audience. |
| Coupons | Promotional codes to drive conversion; `coupons` table already reserved in Section 7.7. |
| Loyalty System | Repeat-purchase incentives to improve retention. |
| Reviews | Social proof on product pages; `reviews` table already reserved in Section 7.7. |
| Chat Support | Direct customer support channel for order or sizing questions. |
| Recently Viewed | Lightweight personalization that helps users pick up where they left off. |

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

## 11. Milestones

| Milestone | Phases Covered | Definition |
|---|---|---|
| **M1 — UI Foundation Complete** | Phases 1–2 | Every core screen exists, is polished, and is reviewable as a clickable prototype. |
| **M2 — Navigation & Architecture Locked** | Phases 3–4 | Navigation shell finalized and codebase refactored to Clean Architecture. |
| **M3 — Backend Online** | Phases 5–7 | Supabase connected, authentication live, full schema and RLS in place. |
| **M4 — Core Shopping Experience Live** | Phases 8–11 | Browse, search, wishlist, and a working cart/checkout are all functional against real data. |
| **M5 — Full Feature Set Complete** | Phases 12–13 | Orders and Profile complete the customer-facing feature set. |
| **M6 — Release Ready** | Phases 14–16 | Performance-optimized, tested, and packaged for release with full documentation. |

---

## 12. Progress Tracker

Update this table as each phase progresses. Status suggestions: Not Started / In Progress / Blocked / Complete.

> **Note:** The roadmap phases 1–16 below use the original roadmap numbering. The Supabase migration phases (3.1–3.6) described in the architecture document map to phases 5–13 below. The current implementation status is reflected in the Completed/In Progress columns.

| # | Phase | Status | Progress % | Start Date | End Date | Notes |
|---|---|---|---|---|---|---|
| 1 | UI Completion | Complete | 100% | | | All core screens built |
| 2 | UI Polish | Complete | 90% | | | Skeletons, empty states, animations done |
| 3 | Navigation & User Experience | Complete | 85% | | | Bottom nav working, some screens lack named routes |
| 4 | Architecture Cleanup | Complete | 85% | | | Feature-first structure, repository pattern established |
| 5 | Supabase Setup | Complete | 100% | | | Project created, `.env` configured, initialized |
| 6 | Authentication | Complete | 95% | | | Full Supabase Auth, profiles CRUD, avatar upload |
| 7 | Database Design | In Progress | 40% | | | Product tables migrated, cart/wishlist/orders tables not created |
| 8 | Home, Categories & Products | In Progress | 60% | | | SupabaseProductRepository wired, categoriesProvider still local |
| 9 | Search & Filters | In Progress | 50% | | | SupabaseSearchRepository exists, uses in-memory filter on cached data |
| 10 | Wishlist | Not Started | 0% | | | Still uses SharedPreferences |
| 11 | Cart & Checkout | Not Started | 0% | | | Still uses SharedPreferences |
| 12 | Orders | Not Started | 0% | | | Still uses SharedPreferences |
| 13 | Profile | Complete | 90% | | | Connected to Supabase profiles table |
| 14 | Performance Optimization | Not Started | 0% | | | |
| 15 | Testing | Not Started | 0% | | | |
| 16 | Deployment | Not Started | 0% | | | |

---

## 13. Development Notes

Freeform space for day-to-day notes, blockers, ideas, and reminders that don't belong in the formal roadmap. Add a dated entry each time you sit down to work on MaxFashion.

**Entry — Date:** ___________

**Notes:**



**Entry — Date:** ___________

**Notes:**



**Entry — Date:** ___________

**Notes:**



**Entry — Date:** ___________

**Notes:**



---

## 14. AI Prompt Log

Track meaningful AI-assisted prompts used during development — useful both as a personal reference and as material for the Phase 16 case study.

| Date | Tool | Purpose / Prompt Summary | Outcome |
|---|---|---|---|
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |

---

## 15. Decision Log

A running record of significant technical and product decisions — what was decided, why, and what alternatives were considered. This is what turns hindsight into a defensible architecture story for the Phase 16 case study.

| Date | Decision | Alternatives Considered | Reasoning |
|---|---|---|---|
| | e.g. State management: Riverpod | Bloc, Provider, GetX | |
| | e.g. Payment provider selection | | |
| | | | |
| | | | |

---

## 16. Appendix

### 16.1 Folder Structure

See Section 4.5 for the full annotated project folder structure.

### 16.2 Database Notes

See Section 7.7–7.10 for the complete table list, relationships, Row Level Security strategy, and indexing plan. Use this space to record schema changes made after initial implementation:

### 16.3 Useful Links

- Flutter documentation — [flutter.dev/docs](https://flutter.dev/docs)
- Supabase documentation — [supabase.com/docs](https://supabase.com/docs)
- supabase_flutter package — [pub.dev/packages/supabase_flutter](https://pub.dev/packages/supabase_flutter)
- flutter_screenutil package — [pub.dev/packages/flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
- Dart style guide — [dart.dev/effective-dart](https://dart.dev/effective-dart)

### 16.4 References

Design and architecture direction referenced throughout this document: Clean Architecture (Robert C. Martin), Material Design and Human Interface Guidelines for accessibility baselines, and general flagship fashion-retail app conventions as UX benchmarks.

### 16.5 Resources

- Project GitHub repository (link here once created — see Phase 16).
- Supabase project dashboard (internal link).
- Figma / design file (link here if used).

---

*End of Document — MaxFashion Software Development Roadmap v1.0*
