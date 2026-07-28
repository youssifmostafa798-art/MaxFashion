# Max Fashion

A Flutter-based e-commerce fashion application featuring a product catalog, checkout flow, payment integration, and order placement with a sleek black-and-white UI aesthetic.

## Purpose

Max Fashion is a mobile fashion retail app showcasing a curated collection of fashion items (boots, earrings, rings, dresses). It provides a complete browsing-to-purchase flow: users can explore products, add items to cart, enter shipping addresses, add payment cards, and place orders.

## Target Users

- Fashion-conscious mobile shoppers
- Users browsing curated fashion collections

## Main Features

- Product catalog with grid display and horizontal "You may also like" recommendations
- Product detail/checkout with quantity selector
- Shipping address entry and editing
- Credit card payment form (Mastercard/Visa)
- Order placement with success confirmation dialog
- Rating system (emoji-based) on order completion
- Custom branded AppBar with menu, search, and cart icons

---

## Tech Stack

| Category | Technology |
|---|---|
| **Framework** | Flutter (^3.10.1) |
| **Language** | Dart |
| **State Management** | `setState()` (no external state management) |
| **Routing** | Direct `MaterialPageRoute` navigation |
| **SVG Rendering** | `flutter_svg` ^2.2.3 |
| **Credit Card Forms** | `flutter_credit_card` ^4.1.0 |
| **Icons** | `ionicons` ^0.2.2 (social media icons) |
| **Spacing** | `gap` ^3.0.1 + `flutter_gap` ^1.2.0 |
| **Custom Font** | Tenor Sans (bundled) |
| **Launcher Icons** | `flutter_launcher_icons` ^0.14.4 |
| **Linting** | `flutter_lints` ^6.0.0 |

---

## Project Structure

```
lib/
├── main.dart                    # App entry point, MaterialApp setup
├── Pages/                       # Screen-level widgets
│   ├── home.dart                # Main home screen with product grid
│   ├── checkout.dart            # Product checkout with quantity/pricing
│   ├── place_order.dart         # Order placement (address, card, shipping)
│   ├── add_card.dart            # Credit card input form
│   ├── add_address.dart         # Shipping address form
│   ├── splash.dart              # Placeholder (unused)
│   └── categories_screen.dart   # Placeholder (unused)
├── Compenents/                  # Reusable UI components [sic]
│   ├── custem_appbar.dart       # Custom AppBar (menu/logo/search/cart)
│   ├── custem_text.dart         # Styled Text widget (Tenor Sans font)
│   ├── custem_bottom.dart       # Reusable Button widget
│   ├── custem_text_field.dart   # Reusable TextFormField
│   └── card_widget.dart         # Product card with optional qty controls
├── Models/
│   ├── product_model.dart       # ProductModel with 6 hardcoded products
│   └── cover_model.dart         # CoverModel with 3 hardcoded covers
└── core/
    ├── colors.dart              # AppColors (primary = Colors.black)
    └── header.dart              # Reusable Header widget with divider
```

**Assets:**

```
assets/
├── cover/          # 3 cover/banner PNG images
├── product/        # 6 product PNG images
├── logo/           # App logo SVG and PNG
├── svgs/           # UI icons (menu, search, cart, visa, mastercard, etc.)
├── texts/          # Decorative SVG text overlays ("10", "October", "Collection")
├── pop/            # Success dialog assets (done.svg, emoji SVGs)
└── fonts/Tenor_Sans/  # Custom font files + OFL license
```

---

## Architecture

This project follows a **simple layered architecture** without formal patterns like Clean Architecture or BLoC.

### Layers

| Layer | Location | Responsibility |
|---|---|---|
| **Presentation** | `Pages/`, `Compenents/` | UI rendering, user interaction |
| **Models** | `Models/` | Data structures with static hardcoded data |
| **Core** | `core/` | Theme colors, shared layout widgets |

### Data Flow

```
User Interaction → StatefulWidget setState() → Widget Rebuild
                                              ↓
Navigator.push() → Screen receives data via constructor
Navigator.pop()  → Screen returns data via Navigator.pop(context, data)
```

### State Management

- **No external state management library** (no Provider, Bloc, Riverpod, etc.)
- All state is local `setState()` within `StatefulWidget`s
- Data is passed between screens via constructor parameters and `Navigator.pop` return values
- Data is typed as `dynamic` when passed between screens (no type-safe routing)

### Dependency Relationships

```
main.dart → Home → Checkout → PlaceOrder → AddAddress
                                         → AddCard

All screens → CustemAppbar (shared AppBar)
All screens → CustemText (shared typography)
All screens → Button (shared CTA)
All screens → Header (shared page header)
```

---

## Important Packages

| Package | Version | Purpose |
|---|---|---|
| `flutter_svg` | ^2.2.3 | Renders SVG assets (logos, icons, text overlays) |
| `flutter_credit_card` | ^4.1.0 | Provides CreditCardWidget and CreditCardForm for payment input |
| `ionicons` | ^0.2.2 | Social media icons (Twitter, Instagram, Facebook) in footer |
| `gap` | ^3.0.1 | Adds vertical/horizontal spacing between widgets |
| `flutter_gap` | ^1.2.0 | Alternative spacing package (used alongside `gap`) |
| `cupertino_icons` | ^1.0.8 | iOS-style icons (used for close icon in dialog) |
| `flutter_launcher_icons` | ^0.14.4 | Generates custom launcher icon from `assets/logo/mylogo.png` |

**Note:** Both `gap` and `flutter_gap` are installed and used interchangeably. These serve the same purpose.

---

## Main Screens

### Home (`lib/Pages/home.dart`)

- **Purpose:** Landing screen displaying the full product catalog
- **Components:**
  - Custom AppBar (black theme) with menu, logo, search, cart
  - Stacked SVG text overlays ("10", "October", "Collection")
  - Cover banner image
  - 2-column product grid (6 items)
  - "You may also like" horizontal scrollable list (3 covers)
  - Footer with social icons, contact info, and copyright
- **Navigation:** Tapping a product navigates to `Checkout`
- **State:** Stateless — reads from `ProductModel.products` and `CoverModel.covers`

### Checkout (`lib/Pages/checkout.dart`)

- **Purpose:** Product detail screen with quantity selection and pricing
- **Components:**
  - `Header` ("Checkout")
  - `CardWidget` with quantity +/- controls
  - Promo code section (non-functional display)
  - Delivery info (FREE)
  - Estimated total display
  - "Checkout" button
- **Navigation:** "Checkout" button navigates to `PlaceOrder`
- **State:** `selectedQty` (int) — manages quantity via `setState`

### Place Order (`lib/Pages/place_order.dart`)

- **Purpose:** Final order screen — address, payment, shipping, and order confirmation
- **Components:**
  - Shipping address section (add/edit/display)
  - Shipping method (Pickup at store — hardcoded)
  - Payment method (card selection/display)
  - Product summary card
  - Total price display
  - "Place order" button → success dialog with rating emojis
- **Navigation:** Opens `AddAddress` and `AddCard` via `Navigator.push`
- **State:** `_savedAddress` (dynamic), `savedCard` (dynamic) — populated from child screens
- **Note:** This is the largest file (396 lines). The success dialog is built inline.

### Add Card (`lib/Pages/add_card.dart`)

- **Purpose:** Credit card input form
- **Components:**
  - `CreditCardWidget` (visual card preview)
  - `CreditCardForm` (input fields for number, expiry, name, CVV)
  - "Add Card" button
- **Navigation:** Returns card data map via `Navigator.pop(context, data)`
- **State:** Card fields managed by `onCreditCardModelChange` callback

### Add Address (`lib/Pages/add_address.dart`)

- **Purpose:** Shipping address entry form
- **Components:**
  - 7 input fields: First Name, Last Name, Address, City, State, ZIP Code, Phone
  - Supports edit mode via `editData` parameter (pre-fills fields)
  - "Add now" button
- **Navigation:** Returns address data map via `Navigator.pop(context, data)`
- **State:** 7 `TextEditingController`s, form key for validation

### Splash (`lib/Pages/splash.dart`)

- **Status:** Empty placeholder — just returns `Scaffold()`
- **Not wired into navigation**

### Categories Screen (`lib/Pages/categories_screen.dart`)

- **Status:** Returns `Placeholder()` widget
- **Not wired into navigation**

---

## Features

### Implemented

- Product catalog display (grid layout)
- Product detail view with quantity controls
- Checkout flow with pricing calculation
- Shipping address form with validation
- Credit card input (card number, expiry, name, CVV)
- Credit card visual preview
- Address edit mode (pre-fills existing data)
- Order placement with success dialog
- Emoji-based rating system (visual only — no data capture)
- Custom branded AppBar with dynamic theming (black/white)
- Footer with social media icons and contact info
- Custom font (Tenor Sans) throughout the app
- SVG asset rendering for UI elements

### Not Implemented

- Shopping cart / bag functionality (cart icon has no action)
- Search functionality (search icon has no action)
- Menu/drawer (menu icon has no action)
- Promo code application
- User authentication
- API integration / backend
- Database / local storage
- Order history
- Product categories / filtering
- Responsive design (mobile-only layout)

---

## Navigation Flow

```
main.dart
  └── MaterialApp (home: Home)
        └── Home (product catalog)
              ├── [product tap] → Checkout
              │                     ├── [add address] → AddAddress → pop(data)
              │                     ├── [edit address] → AddAddress(editData) → pop(data)
              │                     ├── [add card] → AddCard → pop(data)
              │                     └── [checkout] → PlaceOrder
              │                                       └── [place order] → Success Dialog
              │                                             └── [submit] → pop 3x → Home
              │                                             └── [cancel] → pop dialog
              └── (footer links are non-functional)
```

**Unreachable screens:** `Splash`, `CategoriesScreen` exist but are not connected to any navigation.

---

## Important Components

### `CustemText` (`lib/Compenents/custem_text.dart`)

Reusable text widget using the Tenor Sans font family. Configurable size, weight, color, height, and letter spacing. Used on every screen.

### `CustemAppbar` (`lib/Compenents/custem_appbar.dart`)

Custom AppBar implementing `PreferredSizeWidget`. Accepts `isBlackk` boolean to switch between black-on-white and white-on-black themes. Contains menu, logo, search, and cart icons — only logo is visually distinct; menu/search/cart have empty `onTap` handlers.

### `Button` (`lib/Compenents/custem_bottom.dart`)

Full-width rounded black button with optional shopping bag SVG icon. Accepts title and `onTap` callback.

### `CustemTextField` (`lib/Compenents/custem_text_field.dart`)

Text form field with underline decoration. Accepts hint text and controller. **Has a validation bug** — always returns error string.

### `CardWidget` (`lib/Compenents/card_widget.dart`)

Product display card with image, name, description, price, and optional quantity +/- controls. Used in both Checkout and PlaceOrder screens.

### `Header` (`lib/core/header.dart`)

Page header with centered uppercase title and decorative line divider image below it.

### `AppColors` (`lib/core/colors.dart`)

Theme color definitions. Currently only defines `primary` as `Colors.black`.

---

## Services

This project has **no backend services, APIs, local storage, or authentication layer.** All data is hardcoded in model classes.

---

## Models

### `ProductModel` (`lib/Models/product_model.dart`)

| Field | Type | Description |
|---|---|---|
| `image` | `String` | Asset path to product image |
| `name` | `String` | Product display name |
| `price` | `double` | Product price in USD |
| `descrp` | `String` | Product description |

Contains 6 hardcoded products: Boots ($50), Earrings ($100), Steel Ring ($40), Gold-Plated Ring ($100, $80), Dress ($120).

### `CoverModel` (`lib/Models/cover_model.dart`)

| Field | Type | Description |
|---|---|---|
| `image` | `String` | Asset path to cover image |
| `name` | `String` | Cover display name |

Contains 3 hardcoded covers: Black Collection, HAE BY HAEKIM, White Collection.

---

## Current Project Status

### Completed

- Home screen with product grid and cover carousel
- Checkout screen with quantity controls and pricing
- PlaceOrder screen with address/card management
- AddCard screen with credit card form
- AddAddress screen with 7-field form + edit mode
- Custom AppBar with dynamic theming
- Custom text widget with branded font
- Button and TextField reusable components
- SVG and PNG asset integration
- App launcher icon configuration
- Success dialog with emoji rating

### Partially Completed / Stub

- `Splash` screen — exists as empty `Scaffold()`, not wired in
- `CategoriesScreen` — exists as `Placeholder()`, not wired in
- Promo code section — UI only, no functionality
- Delivery method — hardcoded to "Pickup at store"
- Rating system — emojis displayed but no data captured

### Known Bugs

1. **Validation logic inversion in `add_address.dart:136`** — `if (_formkey.currentState!.validate()) { return; }` returns early when validation *succeeds*, meaning address data is only saved when validation *fails*. The `else` block contains the save logic.
2. **Validator always fails in `custem_text_field.dart:13`** — `validator: (v) => "Please Fill The Field"` always returns the error string regardless of input content. Should return `null` for valid input.
3. **Stale test file** — `test/widget_test.dart` tests a counter increment that doesn't exist in the actual app.

### Technical Debt

- Folder naming: `Compenents` should be `Components`
- Duplicate spacing packages: both `gap` and `flutter_gap` installed
- No type safety for data passed between screens (uses `dynamic`)
- Inline success dialog in `place_order.dart` (396 lines total)
- Hardcoded data — no API or database integration
- No state management solution
- No named routes or router

---

## Current Progress Summary

The project is in **early/mid development**. The core checkout flow (browse → select → checkout → add address/card → place order → success) is functional. However, the app lacks a backend, user authentication, cart persistence, search, categories, and many standard e-commerce features. Two screens (Splash, Categories) are stubbed but not connected. The validator bug in the text field and the inverted validation logic in the address form are active bugs that affect the user experience.

---

## Known Issues

| Issue | Severity | Location | Description |
|---|---|---|---|
| Address validation inverted | High | `add_address.dart:136` | Data saves only when validation fails |
| TextField validator broken | High | `custem_text_field.dart:13` | Always returns error, never validates |
| Stale widget test | Low | `test/widget_test.dart` | Tests counter app, not the actual app |
| Folder typo | Low | `Compenents/` | Should be `Components` |
| Duplicate spacing packages | Low | `pubspec.yaml` | Both `gap` and `flutter_gap` installed |
| No type safety | Medium | All screens | `dynamic` used for passed data |
| Cart icon non-functional | Medium | `custem_appbar.dart:80` | Empty `onTap` handler |
| Search icon non-functional | Medium | `custem_appbar.dart:59` | Empty `onTap` handler |
| Menu icon non-functional | Medium | `custem_appbar.dart:29` | Empty `onTap` handler |
| Hardcoded payment ID | Low | `place_order.dart:300` | "Payment ID 15263541" is static text |
| No responsive design | Medium | All screens | Mobile-only layout |

---

## Future Improvements

### High Priority

1. Fix address validation logic inversion
2. Fix TextField validator to return `null` for valid input
3. Add a proper state management solution (Provider, Riverpod, or Bloc)
4. Implement named routes or a router package (go_router)
5. Add type-safe data models for inter-screen communication

### Medium Priority

6. Implement shopping cart with persistence (local storage or API)
7. Add user authentication (Firebase Auth or custom backend)
8. Connect Splash screen to navigation flow
9. Implement CategoriesScreen with product filtering
10. Add search functionality
11. Build a backend API or connect to an existing one
12. Add responsive design support

### Low Priority

13. Rename `Compenents` folder to `Components`
14. Remove duplicate `gap`/`flutter_gap` packages (pick one)
15. Extract inline dialog from `place_order.dart` into its own widget
16. Write meaningful tests
17. Add error handling and loading states
18. Add order history screen
19. Implement promo code functionality

---

## How to Continue Development

### Recommended Next Steps

1. **Fix the two critical bugs first** — validation logic inversion and TextField validator
2. **Pick a state management approach** — Given the current complexity, `Provider` or `Riverpod` is recommended
3. **Implement a proper routing solution** — `go_router` with named routes
4. **Add a data layer** — Either local SQLite/Hive or a REST/GraphQL API

### Files Likely Needing Modification

- `lib/Compenents/custem_text_field.dart` — Fix validator
- `lib/Pages/add_address.dart` — Fix validation logic inversion
- `lib/Pages/place_order.dart` — Extract dialog, add state management
- `lib/main.dart` — Add router, theme configuration, dependency injection
- `lib/Pages/home.dart` — Add navigation to categories, search
- `lib/Models/` — Add more models, potentially make data fetchable

### Existing Abstractions to Reuse

- `CustemText` — Use everywhere for consistent typography
- `CustemAppbar` — Already supports black/white theming
- `Button` — Reusable CTA component
- `Header` — Page header pattern
- `CardWidget` — Product display with quantity controls
- `AppColors` — Centralize theme colors

### Important Patterns to Preserve

- The `isBlackk` AppBar theming pattern (black vs white contexts)
- The `Navigator.push/pop` data passing pattern (though it should be typed)
- The component-based UI structure (reusable widgets in `Compenents/`)

---

## Coding Conventions

| Convention | Details |
|---|---|
| **Naming** | Files use snake_case. Classes use PascalCase. Variables use camelCase. |
| **Folder structure** | Screens in `Pages/`, reusable widgets in `Compenents/`, data in `Models/`, theme in `core/` |
| **Widget structure** | StatelessWidget for display-only, StatefulWidget for interactive screens |
| **State management** | Local `setState()` only — no global state |
| **Typography** | All text uses `CustemText` widget with Tenor Sans font |
| **Spacing** | Uses `Gap()` widget from `gap`/`flutter_gap` packages |
| **Colors** | Defined in `AppColors` class (`core/colors.dart`) |
| **Assets** | SVG for icons/logos/text overlays, PNG for product/cover images |
| **Navigation** | Direct `MaterialPageRoute` with data passed via constructor |
| **Form handling** | `GlobalKey<FormState>` with `TextEditingController`s |
| **Comments** | Minimal inline comments, some in Arabic |

---

## Build & Run

### Prerequisites

- Flutter SDK ^3.10.1
- Dart SDK (bundled with Flutter)
- Android Studio / VS Code with Flutter plugin
- Android SDK (minSdk 21) or Xcode for iOS

### Setup

```bash
# Get dependencies
flutter pub get

# Generate launcher icons (if not already generated)
dart run flutter_launcher_icons

# Run the app
flutter run
```

### Build Commands

```bash
# Android APK
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

---

## AI Handoff Notes

### Architecture Decisions

- **No state management library** — The app uses raw `setState()`. Any new feature should either continue this pattern for small features or introduce Provider/Bloc for larger features.
- **No routing package** — All navigation uses direct `MaterialPageRoute`. Introducing `go_router` would be beneficial for the growing navigation tree.
- **Component-based UI** — Reusable widgets live in `Compenents/`. New reusable widgets should follow this pattern.
- **Static data models** — Products and covers are hardcoded lists. The data layer needs to be built from scratch.

### Existing Patterns That Must Be Preserved

- `CustemText` for all text rendering (Tenor Sans font consistency)
- `CustemAppbar` with `isBlackk` theming for all screens
- `Button` component for all CTAs
- `Header` component for all page titles
- `AppColors.primary` for theme color (currently `Colors.black`)
- `Gap()` for all spacing

### Things That Should NOT Be Changed

- The `CustemText` widget — it's used on every screen
- The `CustemAppbar` `isBlackk` theming pattern
- The `AppColors.primary` color system
- The `Header` page header pattern
- The `CardWidget` product display format
- Asset folder structure and naming

### Important Reusable Components

| Component | File | Use |
|---|---|---|
| `CustemText` | `Compenents/custem_text.dart` | All text |
| `CustemAppbar` | `Compenents/custem_appbar.dart` | All AppBars |
| `Button` | `Compenents/custem_bottom.dart` | All buttons |
| `CustemTextField` | `Compenents/custem_text_field.dart` | All form inputs |
| `CardWidget` | `Compenents/card_widget.dart` | Product display |
| `Header` | `core/header.dart` | All page headers |
| `AppColors` | `core/colors.dart` | Theme colors |

### Current Unfinished Work

1. `Splash` screen needs implementation
2. `CategoriesScreen` needs implementation
3. Menu drawer needs implementation
4. Search functionality needs implementation
5. Cart/bag functionality needs implementation
6. Promo code feature needs implementation

### Files Central to the Project

- `lib/main.dart` — Entry point, MaterialApp configuration
- `lib/Pages/home.dart` — Main screen, product catalog
- `lib/Pages/place_order.dart` — Largest file, most complex logic
- `lib/Pages/add_address.dart` — Contains validation bug to fix
- `lib/Compenents/custem_text.dart` — Used everywhere
- `lib/Compenents/custem_appbar.dart` — Used everywhere
- `lib/Models/product_model.dart` — Core data model

### Potential Risks

- The validation bugs in `custem_text_field.dart` and `add_address.dart` will cause incorrect behavior if not fixed before adding more forms
- The `dynamic` typing for inter-screen data can cause runtime errors
- The 396-line `place_order.dart` file will become difficult to maintain as features are added — consider extracting the dialog
- No error handling exists — any null data or failed navigation will crash the app
