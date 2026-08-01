import 'package:flutter/material.dart';
import 'package:max/splash.dart';
import 'package:max/features/auth/presentation/pages/auth_page.dart';
import 'package:max/features/auth/presentation/pages/login_page.dart';
import 'package:max/features/auth/presentation/pages/signup_page.dart';
import 'package:max/features/main/presentation/pages/main_screen.dart';
import 'package:max/features/search/presentation/pages/search_screen.dart';
import 'package:max/features/wishlist/presentation/pages/wishlist_page.dart';
import 'package:max/features/product/presentation/pages/product_listing_page.dart';
import 'package:max/features/product/presentation/pages/product_detail_page.dart';
import 'package:max/data/models/product_model.dart';

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

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case main:
        final int tab = (settings.arguments as int?) ?? 0;
        return MaterialPageRoute(builder: (_) => MainScreen(initialTab: tab));
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case wishlist:
        return MaterialPageRoute(builder: (_) => const WishlistPage());
      case productListing:
        final String category = (settings.arguments as String?) ?? '';
        return MaterialPageRoute(
          builder: (_) => ProductListingPage(category: category),
        );
      case productDetail:
        final ProductModel product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailPage(product: product),
        );
      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }
}
