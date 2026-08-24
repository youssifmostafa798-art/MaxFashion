import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/models/user_model.dart';
import 'package:max/features/home/presentation/widgets/home_empty_products.dart';
import 'package:max/features/home/presentation/widgets/home_category_filter.dart';
import 'package:max/features/menu/presentation/widgets/see_more_category_card.dart';
import 'package:max/features/cart/presentation/pages/cart_page.dart';
import 'package:max/features/wishlist/presentation/pages/wishlist_page.dart';
import 'package:max/features/main/presentation/pages/main_screen.dart';

class _FakeAuthNotifier extends StateNotifier<AuthState>
    implements AuthNotifier {
  _FakeAuthNotifier({AuthState initialState = const AuthState()})
      : super(initialState);

  @override
  void setLocalizations(AppLocalizations l10n) {}

  @override
  Future<void> signUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    String? profileImage,
  }) async {}

  @override
  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<bool> updateProfile({
    required String fullName,
    required String phoneNumber,
    String? profileImage,
    DateTime? dateOfBirth,
    String? gender,
    String? country,
    String? bio,
  }) async =>
      false;

  @override
  void setUser(UserModel user) {}

  @override
  void clearError() {}

  @override
  void enterGuestMode() {}

  @override
  void clearResetCodeVerified() {}

  @override
  Future<void> sendResetCode({required String email}) async {}

  @override
  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {}

  @override
  Future<void> resetPasswordWithCode({
    required String email,
    required String code,
    required String newPassword,
  }) async {}
}

Widget _buildTestApp({
  required Locale locale,
  required Widget child,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => _FakeAuthNotifier()),
      ...overrides,
    ],
    child: ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: child),
        );
      },
    ),
  );
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('HomeEmptyProducts', () {
    testWidgets('English - shows empty products text', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const HomeEmptyProducts(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('No products found'), findsOneWidget);
    });

    testWidgets('Arabic - shows empty products text', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const HomeEmptyProducts(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('لم يتم العثور على منتجات'), findsOneWidget);
    });
  });

  group('HomeCategoryFilter', () {
    testWidgets('English - shows All chip', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const HomeCategoryFilter(categories: []),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ALL'), findsOneWidget);
    });

    testWidgets('Arabic - shows All chip', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const HomeCategoryFilter(categories: []),
      ));
      await tester.pumpAndSettle();

      expect(find.text('الكل'), findsOneWidget);
    });
  });

  group('SeeMoreCategoryCard', () {
    testWidgets('English - shows See More', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: SeeMoreCategoryCard(onTap: () {}),
      ));
      await tester.pumpAndSettle();

      expect(find.text('See More'), findsOneWidget);
    });

    testWidgets('Arabic - shows See More', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: SeeMoreCategoryCard(onTap: () {}),
      ));
      await tester.pumpAndSettle();

      expect(find.text('عرض المزيد'), findsOneWidget);
    });
  });

  group('CartPage', () {
    testWidgets('English - guest view shows sign in prompt', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const CartPage(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('MY BAG'), findsOneWidget);
      expect(find.text('Sign in to view your bag'), findsOneWidget);
      expect(find.text('Save items and checkout across devices.'), findsOneWidget);
    }, skip: true);

    testWidgets('Arabic - guest view shows sign in prompt', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const CartPage(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('حقيبتي'), findsOneWidget);
      expect(find.text('سجّل الدخول لعرض حقيبتك'), findsOneWidget);
      expect(find.text('احفظ المنتجات وأتمم الشراء عبر الأجهزة.'), findsOneWidget);
    }, skip: true);
  });

  group('WishlistPage', () {
    testWidgets('English - guest view shows sign in prompt', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const WishlistPage(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('WISHLIST'), findsOneWidget);
      expect(find.text('Sign in to view your wishlist'), findsOneWidget);
    }, skip: true);

    testWidgets('Arabic - guest view shows sign in prompt', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const WishlistPage(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('قائمة الأمنيات'), findsOneWidget);
      expect(find.text('سجّل الدخول لعرض قائمة أمنياتك'), findsOneWidget);
    }, skip: true);
  });

  group('MainScreen', () {
    testWidgets('English - bottom nav shows localized labels', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const MainScreen(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Menu'), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('You'), findsOneWidget);
    }, skip: true);

    testWidgets('Arabic - bottom nav shows localized labels', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const MainScreen(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('القائمة'), findsOneWidget);
      expect(find.text('السلة'), findsOneWidget);
      expect(find.text('أنت'), findsOneWidget);
    }, skip: true);
  });

  group('ARB key coverage', () {
    testWidgets('English - all Phase 5 keys are accessible', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const SizedBox();
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(l10n.exploreCollections, 'Explore Collections');
      expect(l10n.allCategory, 'All');
      expect(l10n.noProductsFound, 'No products found');
      expect(l10n.menu, 'Menu');
      expect(l10n.categories, 'Categories');
      expect(l10n.shopBy, 'Shop By');
      expect(l10n.allCategories, 'All Categories');
      expect(l10n.noCategoriesFound, 'No Categories Found');
      expect(l10n.categoriesCount('5'), '5 categories');
      expect(l10n.newArrivals, 'New Arrivals');
      expect(l10n.trendingNow, 'Trending Now');
      expect(l10n.bestSellers, 'Best Sellers');
      expect(l10n.onlineExclusive, 'Online Exclusive');
      expect(l10n.seeMore, 'See More');
      expect(l10n.searchCategoriesHint, 'Search categories...');
      expect(l10n.size, 'SIZE');
      expect(l10n.sizeLabel('M'), 'Size: M');
      expect(l10n.estimatedTotal, 'Est. Total');
      expect(l10n.addToCart, 'Add to cart');
      expect(l10n.signInToAddToBag, 'Sign in to add items to your bag.');
      expect(l10n.itemsCount('12'), '12 items');
      expect(l10n.noItemsInCategory('Shoes'), 'No items in Shoes yet');
      expect(l10n.priceValue('29.99'), '\$29.99');
      expect(l10n.searchOnHomeHint, 'Search products on home...');
      expect(l10n.searchInCategoryHint, 'Search in this category...');
      expect(l10n.searchInBagHint, 'Search in your bag...');
      expect(l10n.searchInWishlistHint, 'Search in wishlist...');
      expect(l10n.searchInOrdersHint, 'Search in orders...');
      expect(l10n.recentSearches, 'Recent Searches');
      expect(l10n.clearAll, 'Clear all');
      expect(l10n.suggestedForYou, 'Suggested for You');
      expect(l10n.popularCategories, 'Popular Categories');
      expect(l10n.loadMoreResults, 'Load more results');
      expect(l10n.noResultsFound, 'No Results Found');
      expect(l10n.tryAnotherKeyword, 'Try another keyword');
      expect(l10n.myBag, 'MY BAG');
      expect(l10n.loadingBag, 'Loading your bag...');
      expect(l10n.subtotal, 'Subtotal');
      expect(l10n.delivery, 'Delivery');
      expect(l10n.free, 'Free');
      expect(l10n.checkout, 'Checkout');
      expect(l10n.yourBagIsEmpty, 'Your bag is empty');
      expect(l10n.addItemsToGetStarted, 'Add items to get started');
      expect(l10n.startShopping, 'START SHOPPING');
      expect(l10n.signInToViewBag, 'Sign in to view your bag');
      expect(l10n.saveItemsAcrossDevices, 'Save items and checkout across devices.');
      expect(l10n.wishlist, 'Wishlist');
      expect(l10n.productAddedToCart('Jacket'), 'Jacket added to cart');
      expect(l10n.wishlistEmpty, 'Your wishlist is empty');
      expect(l10n.saveFavoritesHere, 'Save your favorite products here.');
      expect(l10n.continueShopping, 'CONTINUE SHOPPING');
      expect(l10n.signInToViewWishlist, 'Sign in to view your wishlist');
      expect(l10n.moveToCart, 'MOVE TO CART');
      expect(l10n.allCollections, 'ALL COLLECTIONS');
      expect(l10n.collectionFailed, 'Failed to load collections');
      expect(l10n.noCollectionsFound, 'No Collections Found');
      expect(l10n.collectionsCount('8'), '8 collections');
      expect(l10n.noItemsInCollection('Summer Sale'), 'No items in Summer Sale yet');
      expect(l10n.homeNav, 'Home');
      expect(l10n.cartNav, 'Cart');
      expect(l10n.profileNav, 'You');
    });

    testWidgets('Arabic - all Phase 5 keys are accessible', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const SizedBox();
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(l10n.exploreCollections, 'استكشف المجموعات');
      expect(l10n.allCategory, 'الكل');
      expect(l10n.noProductsFound, 'لم يتم العثور على منتجات');
      expect(l10n.menu, 'القائمة');
      expect(l10n.categories, 'الأقسام');
      expect(l10n.shopBy, 'تسوق حسب');
      expect(l10n.allCategories, 'جميع الأقسام');
      expect(l10n.noCategoriesFound, 'لم يتم العثور على أقسام');
      expect(l10n.categoriesCount('5'), '5 أقسام');
      expect(l10n.newArrivals, 'وصل حديثاً');
      expect(l10n.trendingNow, 'الرائج الآن');
      expect(l10n.bestSellers, 'الأكثر مبيعاً');
      expect(l10n.onlineExclusive, 'حصري عبر الإنترنت');
      expect(l10n.seeMore, 'عرض المزيد');
      expect(l10n.searchCategoriesHint, 'بحث في الأقسام...');
      expect(l10n.size, 'المقاس');
      expect(l10n.sizeLabel('M'), 'المقاس: M');
      expect(l10n.estimatedTotal, 'الإجمالي التقديري');
      expect(l10n.addToCart, 'أضف إلى السلة');
      expect(l10n.signInToAddToBag, 'سجّل الدخول لإضافة منتجات إلى حقيبتك.');
      expect(l10n.itemsCount('12'), '12 منتجات');
      expect(l10n.noItemsInCategory('أحذية'), 'لا توجد منتجات في أحذية بعد');
      expect(l10n.priceValue('29.99'), '\$29.99');
      expect(l10n.searchOnHomeHint, 'ابحث عن منتجات...');
      expect(l10n.searchInCategoryHint, 'بحث في هذا القسم...');
      expect(l10n.searchInBagHint, 'بحث في حقيبتك...');
      expect(l10n.searchInWishlistHint, 'بحث في قائمة الأمنيات...');
      expect(l10n.searchInOrdersHint, 'بحث في الطلبات...');
      expect(l10n.recentSearches, 'عمليات البحث الأخيرة');
      expect(l10n.clearAll, 'مسح الكل');
      expect(l10n.suggestedForYou, 'مقترحات لك');
      expect(l10n.popularCategories, 'الأقسام الشائعة');
      expect(l10n.loadMoreResults, 'تحميل المزيد من النتائج');
      expect(l10n.noResultsFound, 'لم يتم العثور على نتائج');
      expect(l10n.tryAnotherKeyword, 'جرّب كلمة بحث أخرى');
      expect(l10n.myBag, 'حقيبتي');
      expect(l10n.loadingBag, 'جاري تحميل حقيبتك...');
      expect(l10n.subtotal, 'المجموع الفرعي');
      expect(l10n.delivery, 'التوصيل');
      expect(l10n.free, 'مجاني');
      expect(l10n.checkout, 'إتمام الشراء');
      expect(l10n.yourBagIsEmpty, 'حقيبتك فارغة');
      expect(l10n.addItemsToGetStarted, 'أضف منتجات للبدء');
      expect(l10n.startShopping, 'ابدأ التسوق');
      expect(l10n.signInToViewBag, 'سجّل الدخول لعرض حقيبتك');
      expect(l10n.saveItemsAcrossDevices, 'احفظ المنتجات وأتمم الشراء عبر الأجهزة.');
      expect(l10n.wishlist, 'قائمة الأمنيات');
      expect(l10n.productAddedToCart('جاكيت'), 'تمت إضافة جاكيت إلى السلة');
      expect(l10n.wishlistEmpty, 'قائمة أمنياتك فارغة');
      expect(l10n.saveFavoritesHere, 'احفظ منتجاتك المفضلة هنا.');
      expect(l10n.continueShopping, 'متابعة التسوق');
      expect(l10n.signInToViewWishlist, 'سجّل الدخول لعرض قائمة أمنياتك');
      expect(l10n.moveToCart, 'نقل إلى السلة');
      expect(l10n.allCollections, 'جميع المجموعات');
      expect(l10n.collectionFailed, 'فشل تحميل المجموعات');
      expect(l10n.noCollectionsFound, 'لم يتم العثور على مجموعات');
      expect(l10n.collectionsCount('8'), '8 مجموعات');
      expect(l10n.noItemsInCollection('تخفيضات الصيف'), 'لا توجد منتجات في تخفيضات الصيف بعد');
      expect(l10n.homeNav, 'الرئيسية');
      expect(l10n.cartNav, 'السلة');
      expect(l10n.profileNav, 'أنت');
    });
  });
}
