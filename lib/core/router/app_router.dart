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
