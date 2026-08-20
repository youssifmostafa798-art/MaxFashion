import 'package:flutter/material.dart';
import 'package:max/splash.dart';
import 'package:max/core/router/auth_guard.dart';
import 'package:max/features/auth/presentation/pages/auth_page.dart';
import 'package:max/features/auth/presentation/pages/login_page.dart';
import 'package:max/features/auth/presentation/pages/signup_page.dart';
import 'package:max/features/main/presentation/pages/main_screen.dart';
import 'package:max/features/search/presentation/pages/search_screen.dart';
import 'package:max/features/wishlist/presentation/pages/wishlist_page.dart';
import 'package:max/features/product/presentation/pages/product_listing_page.dart';
import 'package:max/features/product/presentation/pages/product_detail_page.dart';
import 'package:max/features/cart/presentation/pages/cart_page.dart';
import 'package:max/features/checkout/presentation/pages/place_order.dart';
import 'package:max/features/checkout/presentation/pages/add_address.dart';
import 'package:max/features/checkout/presentation/pages/add_card.dart';
import 'package:max/features/orders/presentation/pages/orders_page.dart';
import 'package:max/features/orders/presentation/pages/order_details_page.dart';
import 'package:max/features/profile/presentation/pages/profile_page.dart';
import 'package:max/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:max/features/profile/presentation/pages/addresses_page.dart';
import 'package:max/features/profile/presentation/pages/payment_methods_page.dart';
import 'package:max/features/settings/presentation/pages/settings_page.dart';
import 'package:max/features/menu/presentation/pages/categories_page.dart';
import 'package:max/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:max/features/auth/presentation/pages/verify_reset_code_page.dart';
import 'package:max/features/auth/presentation/pages/reset_password_page.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/models/cart_item_model.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/data/models/address_model.dart';
import 'package:max/data/models/collection_model.dart';
import 'package:max/features/collection/presentation/pages/collection_products_page.dart';
import 'package:max/features/collection/presentation/pages/all_collections_page.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String search = '/search';
  static const String wishlist = '/wishlist';
  static const String productListing = '/product-listing';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String placeOrder = '/place-order';
  static const String addAddress = '/add-address';
  static const String addCard = '/add-card';
  static const String orders = '/orders';
  static const String orderDetails = '/order-details';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String addresses = '/addresses';
  static const String paymentMethods = '/payment-methods';
  static const String settings = '/settings';
  static const String categories = '/categories';
  static const String forgotPassword = '/forgot-password';
  static const String verifyResetCode = '/verify-reset-code';
  static const String resetPassword = '/reset-password';
  static const String collectionProducts = '/collection-products';
  static const String allCollections = '/all-collections';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashPage(), settings);
      case auth:
        return _buildRoute(const AuthPage(), settings);
      case login:
        return _buildRoute(const LoginPage(), settings, direction: _SlideDirection.right);
      case signup:
        return _buildRoute(const SignupPage(), settings, direction: _SlideDirection.right);
      case main:
        final int tab = (settings.arguments as int?) ?? 0;
        return _buildRoute(MainScreen(initialTab: tab), settings);
      case search:
        return _buildRoute(const SearchScreen(), settings, direction: _SlideDirection.bottom);
      case wishlist:
        return _buildRoute(const WishlistPage(), settings, direction: _SlideDirection.right);
      case productListing:
        final String category = (settings.arguments as String?) ?? '';
        return _buildRoute(
          ProductListingPage(category: category),
          settings,
          direction: _SlideDirection.right,
        );
      case productDetail:
        final ProductModel product = settings.arguments as ProductModel;
        return _buildRoute(
          ProductDetailPage(product: product),
          settings,
          direction: _SlideDirection.right,
        );
      case cart:
        return _buildRoute(const CartPage(), settings, direction: _SlideDirection.right);
      case placeOrder:
        final args = settings.arguments as Map<String, dynamic>;
        final cartItems = args['cartItems'] as List<CartItemModel>;
        final total = args['total'] as double;
        return _buildRoute(
          AuthGuard(child: PlaceOrder(cartItems: cartItems, total: total)),
          settings,
          direction: _SlideDirection.right,
        );
      case addAddress:
        final AddressModel? editAddress = settings.arguments as AddressModel?;
        return _buildRoute(
          AuthGuard(child: AddAddress(editAddress: editAddress)),
          settings,
          direction: _SlideDirection.right,
        );
      case addCard:
        return _buildRoute(
          AuthGuard(child: const AddCard()),
          settings,
          direction: _SlideDirection.right,
        );
      case orders:
        return _buildRoute(const OrdersPage(), settings, direction: _SlideDirection.right);
      case orderDetails:
        final OrderModel order = settings.arguments as OrderModel;
        return _buildRoute(
          OrderDetailsPage(order: order),
          settings,
          direction: _SlideDirection.right,
        );
      case profile:
        return _buildRoute(const ProfilePage(), settings, direction: _SlideDirection.right);
      case editProfile:
        return _buildRoute(
          AuthGuard(child: const EditProfilePage()),
          settings,
          direction: _SlideDirection.right,
        );
      case addresses:
        return _buildRoute(
          AuthGuard(child: const AddressesPage()),
          settings,
          direction: _SlideDirection.right,
        );
      case paymentMethods:
        return _buildRoute(
          AuthGuard(child: const PaymentMethodsPage()),
          settings,
          direction: _SlideDirection.right,
        );
      case AppRouter.settings:
        return _buildRoute(const SettingsPage(), settings, direction: _SlideDirection.right);
      case categories:
        return _buildRoute(const CategoriesPage(), settings, direction: _SlideDirection.right);
      case forgotPassword:
        return _buildRoute(const ForgotPasswordPage(), settings, direction: _SlideDirection.right);
      case verifyResetCode:
        final String email = settings.arguments as String;
        return _buildRoute(
          VerifyResetCodePage(email: email),
          settings,
          direction: _SlideDirection.right,
        );
      case resetPassword:
        final args = settings.arguments as Map<String, String>;
        return _buildRoute(
          ResetPasswordPage(email: args['email']!, code: args['code']!),
          settings,
          direction: _SlideDirection.right,
        );
      case collectionProducts:
        final CollectionModel collection = settings.arguments as CollectionModel;
        return _buildRoute(
          CollectionProductsPage(collection: collection),
          settings,
          direction: _SlideDirection.right,
        );
      case allCollections:
        return _buildRoute(
          const AllCollectionsPage(),
          settings,
          direction: _SlideDirection.right,
        );
      default:
        return _buildRoute(const SplashPage(), settings);
    }
  }

  static Route<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings, {
    _SlideDirection direction = _SlideDirection.right,
  }) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        switch (direction) {
          case _SlideDirection.right:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.06, 0.0),
                end: Offset.zero,
              ).animate(curved),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
                child: child,
              ),
            );
          case _SlideDirection.bottom:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.03),
                end: Offset.zero,
              ).animate(curved),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
                child: child,
              ),
            );
        }
      },
    );
  }
}

enum _SlideDirection { right, bottom }
