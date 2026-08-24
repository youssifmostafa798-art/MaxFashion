import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/models/user_model.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/data/models/order_item_model.dart';
import 'package:max/data/models/payment_card_model.dart';
import 'package:max/data/models/address_model.dart';
import 'package:max/features/orders/presentation/widgets/empty_orders_widget.dart';
import 'package:max/features/orders/presentation/widgets/order_status_chip.dart';
import 'package:max/features/checkout/presentation/widgets/order_rating_widget.dart';
import 'package:max/features/checkout/presentation/widgets/promo_section.dart';
import 'package:max/features/checkout/presentation/widgets/checkout_container.dart';
import 'package:max/features/profile/presentation/widgets/empty_addresses.dart';
import 'package:max/features/profile/presentation/widgets/payment_card_tile.dart';
import 'package:max/features/profile/presentation/widgets/address_card.dart';
import 'package:max/features/orders/presentation/widgets/order_card.dart';

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

  group('EmptyOrdersWidget', () {
    testWidgets('English - shows empty orders text', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const EmptyOrdersWidget(),
      ));
      await tester.pumpAndSettle();

      expect(find.text("You haven't placed any orders yet"), findsOneWidget);
      expect(find.text('Your completed purchases will appear here.'), findsOneWidget);
      expect(find.text('CONTINUE SHOPPING'), findsOneWidget);
    });

    testWidgets('Arabic - shows empty orders text', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const EmptyOrdersWidget(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('لم تقم بأي طلبات بعد'), findsOneWidget);
      expect(find.text('ستظهر مشترياتك المكتملة هنا.'), findsOneWidget);
      expect(find.text('متابعة التسوق'), findsOneWidget);
    });
  });

  group('OrderStatusChip', () {
    testWidgets('English - shows Processing', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const OrderStatusChip(status: OrderStatus.processing),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Processing'), findsOneWidget);
    });

    testWidgets('English - shows Shipped', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const OrderStatusChip(status: OrderStatus.shipped),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Shipped'), findsOneWidget);
    });

    testWidgets('English - shows Delivered', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const OrderStatusChip(status: OrderStatus.delivered),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Delivered'), findsOneWidget);
    });

    testWidgets('English - shows Cancelled', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const OrderStatusChip(status: OrderStatus.cancelled),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Cancelled'), findsOneWidget);
    });

    testWidgets('Arabic - shows قيد المعالجة', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const OrderStatusChip(status: OrderStatus.processing),
      ));
      await tester.pumpAndSettle();

      expect(find.text('قيد المعالجة'), findsOneWidget);
    });

    testWidgets('Arabic - shows تم الشحن', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const OrderStatusChip(status: OrderStatus.shipped),
      ));
      await tester.pumpAndSettle();

      expect(find.text('تم الشحن'), findsOneWidget);
    });

    testWidgets('Arabic - shows تم التوصيل', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const OrderStatusChip(status: OrderStatus.delivered),
      ));
      await tester.pumpAndSettle();

      expect(find.text('تم التوصيل'), findsOneWidget);
    });

    testWidgets('Arabic - shows ملغي', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const OrderStatusChip(status: OrderStatus.cancelled),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ملغي'), findsOneWidget);
    });
  });

  group('OrderRatingWidget', () {
    testWidgets('English - shows default rating text', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const OrderRatingWidget(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Rate your experience'), findsOneWidget);
    });

    testWidgets('Arabic - shows default rating text', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const OrderRatingWidget(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('قيّم تجربتك'), findsOneWidget);
    });
  });

  group('PromoSection', () {
    testWidgets('English - shows promo and delivery labels', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const PromoSection(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ADD Promo Code'), findsOneWidget);
      expect(find.text('Delivery'), findsOneWidget);
      expect(find.text('FREE'), findsOneWidget);
    });

    testWidgets('Arabic - shows promo and delivery labels', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const PromoSection(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('إضافة كود خصم'), findsOneWidget);
      expect(find.text('التوصيل'), findsOneWidget);
      expect(find.text('مجاني'), findsOneWidget);
    });
  });

  group('CheckoutContainer', () {
    testWidgets('English - shows FREE when isFree', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const CheckoutContainer(
          text: 'Test',
          iconData: Icons.add,
          isFree: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('FREE'), findsOneWidget);
    });

    testWidgets('Arabic - shows FREE when isFree', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const CheckoutContainer(
          text: 'Test',
          iconData: Icons.add,
          isFree: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('مجاني'), findsOneWidget);
    });
  });

  group('EmptyAddresses', () {
    testWidgets('English - shows empty addresses text', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: EmptyAddresses(onAdd: () {}),
      ));
      await tester.pumpAndSettle();

      expect(find.text('No saved addresses.'), findsOneWidget);
      expect(find.text('Add your first delivery address.'), findsOneWidget);
      expect(find.text('ADD ADDRESS'), findsOneWidget);
    });

    testWidgets('Arabic - shows empty addresses text', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: EmptyAddresses(onAdd: () {}),
      ));
      await tester.pumpAndSettle();

      expect(find.text('لا توجد عناوين محفوظة.'), findsOneWidget);
      expect(find.text('أضف عنوان التوصيل الأول.'), findsOneWidget);
      expect(find.text('إضافة عنوان'.toUpperCase()), findsOneWidget);
    });
  });

  group('PaymentCardTile', () {
    final testCard = PaymentCardModel(
      id: 'test-1',
      cardHolderName: 'John Doe',
      last4Digits: '1234',
      expiryMonth: '12',
      expiryYear: '28',
      cardBrand: 'visa',
      isDefault: true,
      createdAt: DateTime(2024),
    );

    testWidgets('English - shows DEFAULT badge', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: PaymentCardTile(
          card: testCard,
          onDelete: () {},
          onSetDefault: () {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('DEFAULT'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('12/28'), findsOneWidget);
    });

    testWidgets('Arabic - shows DEFAULT badge', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: PaymentCardTile(
          card: testCard,
          onDelete: () {},
          onSetDefault: () {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('الافتراضي'), findsOneWidget);
      expect(find.text('حذف'), findsOneWidget);
      expect(find.text('12/28'), findsOneWidget);
    });
  });

  group('AddressCard', () {
    final testAddress = AddressModel(
      id: 'test-addr-1',
      street: '123 Main St',
      city: 'Cairo',
      state: 'Cairo',
      country: 'Egypt',
      zip: '12345',
      label: 'Home',
      isDefault: true,
    );

    testWidgets('English - shows DEFAULT badge and actions', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: AddressCard(
          address: testAddress,
          onEdit: () {},
          onDelete: () {},
          onSetDefault: () {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('DEFAULT'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Set Default'), findsNothing);
    });

    testWidgets('Arabic - shows DEFAULT badge and actions', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: AddressCard(
          address: testAddress,
          onEdit: () {},
          onDelete: () {},
          onSetDefault: () {},
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('الافتراضي'), findsOneWidget);
      expect(find.text('تعديل'), findsOneWidget);
      expect(find.text('حذف'), findsOneWidget);
      expect(find.text('تعيين كافتراضي'), findsNothing);
    });
  });

  group('OrderCard', () {
    final testOrder = OrderModel(
      orderId: 'ORD-TEST-001',
      orderDate: DateTime(2024, 6, 15),
      items: [
        const OrderItemModel(
          productId: 'p1',
          productName: 'Test Product',
          productImage: 'https://example.com/img.jpg',
          selectedSize: 'M',
          selectedColor: null,
          unitPrice: 29.99,
          quantity: 2,
        ),
      ],
      totalPrice: 59.98,
      paymentMethod: 'Visa ending 1234',
      deliveryAddress: '123 Main St, Cairo',
      status: OrderStatus.delivered,
    );

    testWidgets('English - shows order details', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: OrderCard(order: testOrder, onTap: () {}),
      ));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.textContaining('items'), findsOneWidget);
      expect(find.text('VIEW DETAILS'), findsOneWidget);
    });

    testWidgets('Arabic - shows order details', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: OrderCard(order: testOrder, onTap: () {}),
      ));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.textContaining('منتجات'), findsOneWidget);
      expect(find.text('عرض التفاصيل'), findsOneWidget);
    });
  });
}
