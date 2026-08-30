import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass_bottom_navigation_bar/glass_bottom_navigation_bar.dart';
import 'package:max/features/home/presentation/pages/home.dart';
import 'package:max/features/menu/presentation/pages/categories_page.dart';
import 'package:max/features/cart/presentation/pages/cart_page.dart';
import 'package:max/features/profile/presentation/pages/profile_page.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/data/providers/wishlist_provider.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/features/main/presentation/widgets/nav_entry.dart';
import 'package:max/features/main/presentation/widgets/nav_icon_widget.dart';

const int _tabCount = 4;

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
        page = const Home();
        break;
      case 1:
        page = const CategoriesPage();
        break;
      case 2:
        page = const CartPage();
        break;
      case 3:
        page = const ProfilePage();
        break;
      default:
        page = const Home();
    }
    _pagesCache[index] = page;
    return page;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final cartCount = ref.watch(
      cartItemsProvider.select((items) => items.length),
    );
    final wishlistCount = ref.watch(wishlistCountProvider);

    final activeColor = isDark ? AppColors.white : AppColors.black;
    final inactiveColor = AppColors.grey500;

    final allItems = [
      NavEntry(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: l10n.homeNav,
      ),
      NavEntry(
        icon: Icons.menu_outlined,
        activeIcon: Icons.menu,
        label: l10n.menu,
      ),
      NavEntry(
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag,
        label: l10n.cartNav,
        badgeCount: cartCount,
      ),
      NavEntry(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: l10n.profileNav,
        badgeCount: wishlistCount,
      ),
    ];

    final displayItems = isRtl ? allItems.reversed.toList() : allItems;
    final displayIndex = isRtl ? _tabCount - 1 - _currentIndex : _currentIndex;

    final navItems = [
      for (int i = 0; i < displayItems.length; i++)
        BottomNavigationBarItemData(
          icon: NavIconWidget(
            icon: displayItems[i].icon,
            activeIcon: displayItems[i].activeIcon,
            isSelected: displayIndex == i,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            badgeCount: displayItems[i].badgeCount,
          ),
          label: displayItems[i].label,
        ),
    ];

    final navBarHeight = 70.0;
    final navBarMarginBottom = 12.0;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final contentBottomPadding = navBarHeight + navBarMarginBottom + bottomSafeArea;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? const SystemUiOverlayStyle(
              systemNavigationBarColor: Color(0xFF121212),
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            )
          : const SystemUiOverlayStyle(
              systemNavigationBarColor: AppColors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
      child: Scaffold(
        backgroundColor: isDark ? Colors.transparent : Theme.of(context).scaffoldBackgroundColor,
        extendBody: true,
        body: Padding(
          padding: EdgeInsets.only(bottom: contentBottomPadding),
          child: IndexedStack(
            index: _currentIndex,
            children: [for (int i = 0; i < _tabCount; i++) _buildPage(i)],
          ),
        ),
        bottomNavigationBar: Directionality(
          textDirection: TextDirection.ltr,
          child: GlassBottomNavigationBar(
            currentIndex: displayIndex,
            onTap: (packageIndex) {
              final logicalIndex =
                  isRtl ? _tabCount - 1 - packageIndex : packageIndex;
              _onTabTapped(logicalIndex);
            },
            items: navItems,
            selectedItemColor: activeColor,
            unselectedItemColor: inactiveColor,
            height: navBarHeight,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            innerPadding: 16,
          ),
        ),
      ),
    );
  }
}
