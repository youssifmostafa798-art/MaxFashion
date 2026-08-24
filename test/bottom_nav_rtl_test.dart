import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/data/models/cart_item_model.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/collection_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/data/providers/collection_provider.dart';
import 'package:max/data/providers/home_content_provider.dart';
import 'package:max/data/providers/orders_provider.dart';
import 'package:max/data/providers/payment_card_provider.dart';
import 'package:max/data/providers/address_provider.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/data/providers/wishlist_provider.dart';
import 'package:max/data/repositories/wishlist/wishlist_repository.dart';
import 'package:max/data/repositories/cart/cart_repository.dart';
import 'package:max/data/repositories/collection/collection_repository.dart';
import 'package:max/data/repositories/product/product_repository.dart';
import 'package:max/features/main/presentation/pages/main_screen.dart';

class _FakeAuthNotifier extends StateNotifier<AuthState>
    implements AuthNotifier {
  _FakeAuthNotifier() : super(const AuthState());

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
  void setUser(dynamic user) {}

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

class _FakeProductRepository implements ProductRepository {
  @override
  List<CategoryModel> get categories => const [];

  @override
  Future<void> loadAll() async {}

  @override
  List<ProductModel> getAllProducts() => const [];
}

class _FakeCartRepository implements CartRepository {
  @override
  Future<List<CartItemModel>> loadCart() async => const [];

  @override
  Future<CartItemModel> addItem(CartItemModel item) async => item;

  @override
  Future<CartItemModel> updateQuantity(String cartItemId, int quantity) async {
    throw UnimplementedError('not exercised by navigation tests');
  }

  @override
  Future<void> removeItem(String cartItemId) async {}

  @override
  Future<void> clearCart() async {}
}

class _FakeCollectionRepository implements CollectionRepository {
  @override
  Future<List<CollectionModel>> getActiveCollections() async => const [];
}

class _FakeWishlistRepository implements WishlistRepository {
  @override
  Future<List<ProductModel>> loadWishlist() async => const [];

  @override
  Future<void> addToWishlist(int productId) async {}

  @override
  Future<void> removeFromWishlist(int productId) async {}

  @override
  Future<bool> isProductWishlisted(int productId) async => false;
}

Widget _buildApp(Locale locale) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => _FakeAuthNotifier()),
      productRepositoryProvider.overrideWith((ref) => _FakeProductRepository()),
      cartRepositoryProvider.overrideWith((ref) => _FakeCartRepository()),
      collectionRepositoryProvider
          .overrideWith((ref) => _FakeCollectionRepository()),
      wishlistRepositoryProvider.overrideWith((ref) => _FakeWishlistRepository()),
      homeContentProvider.overrideWith((ref) async => null),
      ordersCountProvider.overrideWith((ref) => 0),
      wishlistCountProvider.overrideWith((ref) => 0),
      addressCountProvider.overrideWith((ref) => 0),
      paymentCardCountProvider.overrideWith((ref) => 0),
    ],
    child: ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: const MainScreen(),
      ),
    ),
  );
}

Future<void> _pumpMain(WidgetTester tester, Locale locale) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_buildApp(locale));
  await tester.pump();
}

int _displayedTabIndex(WidgetTester tester) =>
    tester.widget<IndexedStack>(find.byType(IndexedStack)).index!;

double _indicatorStart(WidgetTester tester) => tester
    .widget<AnimatedPositionedDirectional>(
      find.byType(AnimatedPositionedDirectional),
    )
    .start!;

/// Mirrors MainScreen's indicator math: distance from the directionality
/// start edge to the leading edge of the active slot's highlight.
double _expectedIndicatorStart(double screenW, int index) {
  final pad = 16.w;
  final itemW = (screenW - pad * 2) / 4;
  return itemW * index + itemW / 2 - 64.w / 2;
}

void main() {
  testWidgets('EN/LTR — every visible item opens its own destination',
      (tester) async {
    await _pumpMain(tester, const Locale('en'));
    await tester.pumpAndSettle();

    expect(_displayedTabIndex(tester), 0);
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('You'), findsOneWidget);

    // LTR visual order: Home ... You (left → right).
    final homeX = tester.getTopLeft(find.text('Home').first).dx;
    final youX = tester.getTopLeft(find.text('You')).dx;
    expect(homeX, lessThan(youX));

    // Indicator starts under slot 0.
    expect(_indicatorStart(tester), closeTo(_expectedIndicatorStart(390, 0), 1));

    await tester.tap(find.text('You'));
    await tester.pumpAndSettle();
    expect(_displayedTabIndex(tester), 3);

    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    expect(_displayedTabIndex(tester), 1);

    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();
    expect(_displayedTabIndex(tester), 2);

    await tester.tap(find.text('Home').first);
    await tester.pumpAndSettle();
    expect(_displayedTabIndex(tester), 0);
  });

  testWidgets('AR/RTL — visible order mirrors and every tap opens ITS OWN destination',
      (tester) async {
    await _pumpMain(tester, const Locale('ar'));
    await tester.pumpAndSettle();

    expect(_displayedTabIndex(tester), 0);
    expect(find.text('الرئيسية'), findsWidgets);
    expect(find.text('القائمة'), findsOneWidget);
    expect(find.text('السلة'), findsOneWidget);
    expect(find.text('أنت'), findsOneWidget);

    // RTL mirroring: Home renders RIGHTMOST.
    final homeX = tester.getCenter(find.text('الرئيسية').first).dx;
    final youX = tester.getCenter(find.text('أنت')).dx;
    expect(homeX, greaterThan(youX),
        reason: 'Under RTL the first destination (Home) must be visually rightmost');

    // Visible Home (rightmost) → opens Home.
    await tester.tap(find.text('الرئيسية').first);
    await tester.pumpAndSettle();
    expect(_displayedTabIndex(tester), 0,
        reason: 'Tapping the visible Home item must open Home in RTL');
    expect(_indicatorStart(tester),
        closeTo(_expectedIndicatorStart(390, 0), 1),
        reason: 'Active indicator must sit under the visible Home slot in RTL');

    // Visible You (leftmost) → opens Profile.
    await tester.tap(find.text('أنت'));
    await tester.pumpAndSettle();
    expect(_displayedTabIndex(tester), 3,
        reason: 'Tapping the visible You item must open You/Profile in RTL');

    await tester.tap(find.text('القائمة'));
    await tester.pumpAndSettle();
    expect(_displayedTabIndex(tester), 1);

    await tester.tap(find.text('السلة'));
    await tester.pumpAndSettle();
    expect(_displayedTabIndex(tester), 2);
  });

  testWidgets('AR/RTL — indicator tracks the real destination, not the mirror',
      (tester) async {
    await _pumpMain(tester, const Locale('ar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('أنت'));
    await tester.pumpAndSettle();

    expect(_indicatorStart(tester),
        closeTo(_expectedIndicatorStart(390, 3), 1),
        reason: 'Indicator offset must follow the active destination slot '
            'measured from the START edge in both directions');
  });

  testWidgets('Live language switch on a tab keeps the logical destination',
      (tester) async {
    await _pumpMain(tester, const Locale('en'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('You'));
    await tester.pumpAndSettle();
    expect(_displayedTabIndex(tester), 3);

    // Rebuild with Arabic (simulates live EN → AR switch).
    await tester.pumpWidget(_buildApp(const Locale('ar')));
    await tester.pumpAndSettle();

    expect(_displayedTabIndex(tester), 3,
        reason: 'Language switching must not change the selected destination');
    // 'أنت' appears both as the nav label and (now-visible) profile title.
    expect(find.text('أنت'), findsWidgets);
  });
}
