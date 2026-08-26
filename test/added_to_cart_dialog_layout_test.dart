import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/features/checkout/presentation/widgets/added_to_cart_dialog.dart';

Future<void> _loadRealFonts() async {
  final families = <String, String>{
    'Tenor_Sans': 'assets/fonts/Tenor_Sans/TenorSans-Regular.ttf',
    'Noto_Sans_Arabic':
        'assets/fonts/Noto_Sans_Arabic/NotoSansArabic-Regular.ttf',
  };
  for (final entry in families.entries) {
    final ByteData byteData = await rootBundle.load(entry.value);
    final FontLoader loader = FontLoader(entry.key)..addFont(Future.value(byteData));
    await loader.load();
  }
}

void _applySurface(WidgetTester tester, Size logical) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = logical;
  addTearDown(tester.view.reset);
}

Future<void> _pumpDialogHost(
  WidgetTester tester, {
  required Locale locale,
}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (BuildContext buttonContext) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showAddedToCartDialog(buttonContext),
                child: const Text('open-dialog'),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();

  await tester.tap(find.text('open-dialog'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 450));
}

double _centerDyOfLabel(WidgetTester tester, String label) {
  final Rect rect = tester.getRect(find.text(label));
  return rect.center.dy;
}

void expectNoException(WidgetTester tester) {
  expect(tester.takeException(), isNull);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadRealFonts();
  });

  group('AddedToCartDialog action buttons', () {
    testWidgets(
      'EN/LTR on normal width: side-by-side, readable, zero overflow',
      (tester) async {
        _applySurface(tester, const Size(412, 915));

        await _pumpDialogHost(tester, locale: const Locale('en'));

        expect(find.text('VIEW CART'), findsOneWidget);
        expect(find.text('SHOP MORE'), findsOneWidget);

        final double viewDy = _centerDyOfLabel(tester, 'VIEW CART');
        final double shopDy = _centerDyOfLabel(tester, 'SHOP MORE');
        expect((viewDy - shopDy).abs(), lessThan(5),
            reason: 'buttons must sit side-by-side on normal width');

        expectNoException(tester);
      },
    );

    testWidgets(
      'AR/RTL on normal width: side-by-side, readable, zero overflow',
      (tester) async {
        _applySurface(tester, const Size(412, 915));

        await _pumpDialogHost(tester, locale: const Locale('ar'));

        expect(find.text('عرض السلة'), findsOneWidget);
        expect(find.text('تسوق المزيد'), findsOneWidget);

        final Directionality directionality = tester.firstWidget<Directionality>(
          find.ancestor(
            of: find.text('عرض السلة'),
            matching: find.byType(Directionality),
          ).last,
        );
        expect(directionality.textDirection, TextDirection.rtl);

        final double viewDy = _centerDyOfLabel(tester, 'عرض السلة');
        final double shopDy = _centerDyOfLabel(tester, 'تسوق المزيد');
        expect((viewDy - shopDy).abs(), lessThan(5),
            reason: 'buttons must sit side-by-side on normal width');

        expectNoException(tester);
      },
    );

    testWidgets(
      'EN/LTR on narrow width: stacks vertically instead of clipping',
      (tester) async {
        _applySurface(tester, const Size(320, 640));

        await _pumpDialogHost(tester, locale: const Locale('en'));

        expect(find.text('VIEW CART'), findsOneWidget);
        expect(find.text('SHOP MORE'), findsOneWidget);

        final double viewDy = _centerDyOfLabel(tester, 'VIEW CART');
        final double shopDy = _centerDyOfLabel(tester, 'SHOP MORE');
        expect(viewDy, lessThan(shopDy));
        expect(shopDy - viewDy, greaterThan(40),
            reason: 'labels must stack vertically on narrow width');

        expectNoException(tester);
      },
    );

    testWidgets(
      'AR/RTL on narrow width: stacks vertically instead of clipping',
      (tester) async {
        _applySurface(tester, const Size(320, 640));

        await _pumpDialogHost(tester, locale: const Locale('ar'));

        expect(find.text('عرض السلة'), findsOneWidget);
        expect(find.text('تسوق المزيد'), findsOneWidget);

        final double viewDy = _centerDyOfLabel(tester, 'عرض السلة');
        final double shopDy = _centerDyOfLabel(tester, 'تسوق المزيد');
        expect(viewDy, lessThan(shopDy));
        expect(shopDy - viewDy, greaterThan(40),
            reason: 'labels must stack vertically on narrow width');

        expectNoException(tester);
      },
    );
  });
}
