import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/features/home/presentation/pages/home.dart';
import 'package:max/features/menu/presentation/pages/categories_page.dart';
import 'package:max/features/cart/presentation/pages/cart_page.dart';
import 'package:max/features/profile/presentation/pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.black,
        unselectedItemColor: AppColors.grey500,
        selectedLabelStyle: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Tenor_Sans',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          fontFamily: 'Tenor_Sans',
        ),
        elevation: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_outlined),
            activeIcon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
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
