import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/features/home/presentation/pages/home.dart';
import 'package:max/features/menu/presentation/pages/categories_page.dart';
import 'package:max/features/cart/presentation/pages/cart_page.dart';
import 'package:max/features/profile/presentation/pages/profile_page.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/data/providers/wishlist_provider.dart';
import 'package:max/core/widgets/badge_widget.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late int _currentIndex = widget.initialTab;
  final List<Widget?> _pagesCache = List.filled(4, null);

  Widget _buildPage(int index) {
    if (_pagesCache[index] != null) return _pagesCache[index]!;

    Widget page;
    switch (index) {
      case 0:
        page = const _LazyHome();
        break;
      case 1:
        page = const _LazyCategories();
        break;
      case 2:
        page = const _LazyCart();
        break;
      case 3:
        page = const _LazyProfile();
        break;
      default:
        page = const _LazyHome();
    }
    _pagesCache[index] = page;
    return page;
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartItemsProvider.select((items) => items.length));
    final wishlistCount = ref.watch(wishlistCountProvider);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          for (int i = 0; i < 4; i++) _buildPage(i),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_outlined),
            activeIcon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: BadgeWidget(
              count: cartCount,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            activeIcon: BadgeWidget(
              count: cartCount,
              child: const Icon(Icons.shopping_bag),
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: BadgeWidget(
              count: wishlistCount,
              child: const Icon(Icons.person_outline),
            ),
            activeIcon: BadgeWidget(
              count: wishlistCount,
              child: const Icon(Icons.person),
            ),
            label: 'You',
          ),
        ],
      ),
    );
  }
}

class _LazyHome extends StatelessWidget {
  const _LazyHome();
  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}

class _LazyCategories extends StatelessWidget {
  const _LazyCategories();
  @override
  Widget build(BuildContext context) {
    return const CategoriesPage();
  }
}

class _LazyCart extends StatelessWidget {
  const _LazyCart();
  @override
  Widget build(BuildContext context) {
    return const CartPage();
  }
}

class _LazyProfile extends StatelessWidget {
  const _LazyProfile();
  @override
  Widget build(BuildContext context) {
    return const ProfilePage();
  }
}
