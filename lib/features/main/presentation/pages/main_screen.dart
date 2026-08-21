import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/features/home/presentation/pages/home.dart';
import 'package:max/features/menu/presentation/pages/categories_page.dart';
import 'package:max/features/cart/presentation/pages/cart_page.dart';
import 'package:max/features/profile/presentation/pages/profile_page.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/data/providers/wishlist_provider.dart';
import 'package:max/core/widgets/badge_widget.dart';
import 'package:max/core/theme/app_colors.dart';

const int _tabCount = 4;
const double _circleSize = 50.0;
const double _barHeight = 58.0;
const double _circleProtrusion = 14.0;
const double _barTopRadius = 20.0;
const double _barBottomRadius = 24.0;
const double _horizontalPadding = 16.0;
const Duration _animDuration = Duration(milliseconds: 350);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late int _currentIndex = widget.initialTab;
  final List<Widget?> _pagesCache = List.filled(_tabCount, null);

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

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
    final cartCount = ref.watch(
      cartItemsProvider.select((items) => items.length),
    );
    final wishlistCount = ref.watch(wishlistCountProvider);

    final navItems = [
      _NavItemData(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Home',
      ),
      _NavItemData(
        icon: Icons.menu_outlined,
        activeIcon: Icons.menu,
        label: 'Menu',
      ),
      _NavItemData(
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag,
        label: 'Cart',
        badgeCount: cartCount,
      ),
      _NavItemData(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'You',
        badgeCount: wishlistCount,
      ),
    ];

    final bottomInset = MediaQuery.of(context).padding.bottom;
    final navBarTotalHeight =
        bottomInset + 8.w + (_barHeight + _circleProtrusion).h;

    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.only(bottom: navBarTotalHeight),
        child: IndexedStack(
          index: _currentIndex,
          children: [for (int i = 0; i < _tabCount; i++) _buildPage(i)],
        ),
      ),
      bottomNavigationBar: _CustomBottomNavBar(
        currentIndex: _currentIndex,
        items: navItems,
        onTap: _onTabTapped,
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int badgeCount;
}

class _CustomBottomNavBar extends StatelessWidget {
  const _CustomBottomNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  final int currentIndex;
  final List<_NavItemData> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final totalItemWidth = screenWidth - _horizontalPadding.w * 2;
    final itemWidth = totalItemWidth / items.length;
    final indicatorCenterX = itemWidth * currentIndex + itemWidth / 2;

    final barColor = (isDark ? AppColors.black : AppColors.white)
        .withValues(alpha: 0.82);
    final circleColor = isDark ? AppColors.white : AppColors.black;
    final activeIconColor = isDark ? AppColors.black : AppColors.white;
    final activeLabelColor = isDark ? AppColors.white : AppColors.black;
    final inactiveColor = AppColors.grey500;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          _horizontalPadding.w,
          0,
          _horizontalPadding.w,
          8.w,
        ),
        child: SizedBox(
          height: (_barHeight + _circleProtrusion).h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: _circleProtrusion.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_barTopRadius.r),
                      topRight: Radius.circular(_barTopRadius.r),
                      bottomLeft: Radius.circular(_barBottomRadius.r),
                      bottomRight: Radius.circular(_barBottomRadius.r),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: _circleProtrusion.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final bool isActive = index == currentIndex;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(index),
                      child: SizedBox(
                        width: itemWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: !isActive && item.badgeCount > 0
                                  ? BadgeWidget(
                                      count: item.badgeCount,
                                      child: Icon(
                                        item.icon,
                                        size: 24.w,
                                        color: inactiveColor,
                                      ),
                                    )
                                  : isActive
                                  ? null
                                  : Icon(
                                      item.icon,
                                      size: 24.w,
                                      color: inactiveColor,
                                    ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isActive
                                    ? activeLabelColor
                                    : inactiveColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              AnimatedPositioned(
                duration: _animDuration,
                curve: Curves.easeInOut,
                left: indicatorCenterX - _circleSize.w / 2,
                top: 0,
                width: _circleSize.w,
                height: _circleSize.w,
                child: Container(
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: items[currentIndex].badgeCount > 0
                        ? BadgeWidget(
                            count: items[currentIndex].badgeCount,
                            child: Icon(
                              items[currentIndex].activeIcon,
                              size: 24.w,
                              color: activeIconColor,
                            ),
                          )
                        : Icon(
                            items[currentIndex].activeIcon,
                            size: 24.w,
                            color: activeIconColor,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
