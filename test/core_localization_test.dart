import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/utils/date_formatter.dart';
import 'package:max/core/utils/form_validators.dart';
import 'package:max/core/widgets/custom_text.dart';

Widget _buildTestApp({
  required Locale locale,
  required Widget child,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, _) => Center(child: child),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  group('DateFormatter', () {
    final testDate = DateTime(2026, 1, 15, 14, 30);

    group('English locale', () {
      test('formatDate produces English output', () {
        final result = DateFormatter.formatDate(testDate, locale: 'en');
        expect(result, contains('Jan'));
        expect(result, contains('15'));
        expect(result, contains('2026'));
      });

      test('formatDateTime produces English output with time', () {
        final result = DateFormatter.formatDateTime(testDate, locale: 'en');
        expect(result, contains('Jan'));
        expect(result, contains('2026'));
        expect(result, contains('2:30'));
        expect(result, contains('PM'));
      });

      test('formatMonthYear produces English month and year', () {
        final result = DateFormatter.formatMonthYear(testDate, locale: 'en');
        expect(result, contains('January'));
        expect(result, contains('2026'));
      });

      test('formatDateNumeric produces numeric format', () {
        final result =
            DateFormatter.formatDateNumeric(testDate, locale: 'en');
        expect(result, contains('1/15/2026'));
      });

      test('morning time uses AM', () {
        final morningDate = DateTime(2026, 3, 10, 9, 5);
        final result =
            DateFormatter.formatDateTime(morningDate, locale: 'en');
        expect(result, contains('AM'));
      });
    });

    group('Arabic locale', () {
      test('formatDate produces Arabic output', () {
        final result = DateFormatter.formatDate(testDate, locale: 'ar');
        expect(result, isNot(contains('Jan')));
        expect(result, isNot(contains('January')));
      });

      test('formatDateTime produces Arabic output without English AM/PM',
          () {
        final result = DateFormatter.formatDateTime(testDate, locale: 'ar');
        expect(result, isNot(contains('PM')));
        expect(result, isNot(contains('AM')));
      });

      test('formatMonthYear produces Arabic month', () {
        final result = DateFormatter.formatMonthYear(testDate, locale: 'ar');
        expect(result, isNot(contains('January')));
      });
    });
  });

  group('FormValidators', () {
    group('validateEmail', () {
      test('returns emptyError when value is null', () {
        expect(
          FormValidators.validateEmail(null, emptyError: 'Email is required'),
          'Email is required',
        );
      });

      test('returns emptyError when value is empty', () {
        expect(
          FormValidators.validateEmail('', emptyError: 'Email is required'),
          'Email is required',
        );
      });

      test('returns emptyError when value is whitespace', () {
        expect(
          FormValidators.validateEmail('  ', emptyError: 'Email is required'),
          'Email is required',
        );
      });

      test('returns invalidError for invalid email', () {
        expect(
          FormValidators.validateEmail('notanemail',
              invalidError: 'Bad email'),
          'Bad email',
        );
      });

      test('returns null for valid email', () {
        expect(FormValidators.validateEmail('test@example.com'), isNull);
      });

      test('uses default English error when no custom errors provided', () {
        expect(
          FormValidators.validateEmail(null),
          'Please enter your email',
        );
      });
    });

    group('validatePassword', () {
      test('returns emptyError when value is null', () {
        expect(
          FormValidators.validatePassword(null,
              emptyError: 'Password needed'),
          'Password needed',
        );
      });

      test('returns emptyError when value is empty', () {
        expect(
          FormValidators.validatePassword('',
              emptyError: 'Password needed'),
          'Password needed',
        );
      });

      test('returns tooShortError when password is too short', () {
        expect(
          FormValidators.validatePassword('123', tooShortError: 'Too short'),
          'Too short',
        );
      });

      test('returns null for valid password', () {
        expect(FormValidators.validatePassword('123456'), isNull);
      });

      test('uses default English error when no custom errors provided', () {
        expect(
          FormValidators.validatePassword(null),
          'Please enter your password',
        );
      });
    });
  });

  group('CustomText font family', () {
    testWidgets('uses Tenor_Sans for English locale', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const CustomText(text: 'Hello'),
      ));
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(find.text('Hello'));
      expect(textWidget.style?.fontFamily, 'Tenor_Sans');
    });

    testWidgets('uses Noto_Sans_Arabic for Arabic locale', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const CustomText(text: 'مرحبا'),
      ));
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(find.text('مرحبا'));
      expect(textWidget.style?.fontFamily, 'Noto_Sans_Arabic');
    });

    testWidgets('renders English text without crashing', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const CustomText(text: 'Fashion Store'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Fashion Store'), findsOneWidget);
    });

    testWidgets('renders Arabic text without crashing', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const CustomText(text: 'متجر الأزياء'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('متجر الأزياء'), findsOneWidget);
    });

    testWidgets('renders mixed Arabic and numbers', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const CustomText(text: 'السعر: ١٢٣ ر.س'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('السعر: ١٢٣ ر.س'), findsOneWidget);
    });

    testWidgets('switching locale updates font family', (tester) async {
      final localeNotifier = ValueNotifier<Locale>(const Locale('en'));

      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (context, locale, _) {
            return MaterialApp(
              locale: locale,
              localizationsDelegates:
                  AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: ScreenUtilInit(
                  designSize: const Size(375, 812),
                  builder: (context, _) => Column(
                    children: [
                      const CustomText(text: 'Test'),
                      ElevatedButton(
                        onPressed: () {
                          localeNotifier.value = const Locale('ar');
                        },
                        child: const Text('Switch'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      var textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style?.fontFamily, 'Tenor_Sans');

      await tester.tap(find.text('Switch'));
      await tester.pumpAndSettle();

      textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style?.fontFamily, 'Noto_Sans_Arabic');
    });
  });

  group('AppLocalizations core keys', () {
    testWidgets('English locale returns correct core strings',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: Builder(builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return Column(children: [
            Text(l10n.appName),
            Text(l10n.signInRequired),
            Text(l10n.signIn),
            Text(l10n.createAccount),
            Text(l10n.cancel),
            Text(l10n.confirm),
            Text(l10n.gotIt),
            Text(l10n.emailRequired),
            Text(l10n.emailInvalid),
            Text(l10n.passwordRequired),
            Text(l10n.passwordTooShort),
            Text(l10n.fieldRequired),
            Text(l10n.searchHint),
            Text(l10n.genericError),
            Text(l10n.memberSince('Jan 2024')),
            Text(l10n.cardBrand),
          ]);
        }),
      ));
      await tester.pumpAndSettle();

      expect(find.text('MaxFashion'), findsOneWidget);
      expect(find.text('Sign in required'), findsOneWidget);
      expect(find.text('SIGN IN'), findsOneWidget);
      expect(find.text('CREATE ACCOUNT'), findsOneWidget);
      expect(find.text('CANCEL'), findsOneWidget);
      expect(find.text('CONFIRM'), findsOneWidget);
      expect(find.text('GOT IT'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Invalid email address'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
      expect(find.text('Please fill the field'), findsOneWidget);
      expect(find.text('Search....'), findsOneWidget);
      expect(
          find.text('Something went wrong. Please try again.'),
          findsOneWidget);
      expect(find.text('Member since Jan 2024'), findsOneWidget);
      expect(find.text('Card'), findsOneWidget);
    });

    testWidgets('Arabic locale returns correct core strings',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: Builder(builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return Column(children: [
            Text(l10n.appName),
            Text(l10n.signInRequired),
            Text(l10n.signIn),
            Text(l10n.createAccount),
            Text(l10n.cancel),
            Text(l10n.confirm),
            Text(l10n.gotIt),
            Text(l10n.emailRequired),
            Text(l10n.emailInvalid),
            Text(l10n.passwordRequired),
            Text(l10n.passwordTooShort),
            Text(l10n.fieldRequired),
            Text(l10n.searchHint),
            Text(l10n.genericError),
            Text(l10n.memberSince('يناير ٢٠٢٤')),
            Text(l10n.cardBrand),
          ]);
        }),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ماكس فاشن'), findsOneWidget);
      expect(find.text('تسجيل الدخول مطلوب'), findsOneWidget);
      expect(find.text('تسجيل الدخول'), findsOneWidget);
      expect(find.text('إنشاء حساب'), findsOneWidget);
      expect(find.text('إلغاء'), findsOneWidget);
      expect(find.text('تأكيد'), findsOneWidget);
      expect(find.text('حسناً'), findsOneWidget);
      expect(find.text('يرجى إدخال بريدك الإلكتروني'), findsOneWidget);
      expect(find.text('عنوان بريد إلكتروني غير صالح'), findsOneWidget);
      expect(find.text('يرجى إدخال كلمة المرور'), findsOneWidget);
      expect(find.text('يجب أن تكون كلمة المرور 6 أحرف على الأقل'),
          findsOneWidget);
      expect(find.text('يرجى ملء هذا الحقل'), findsOneWidget);
      expect(find.text('بحث....'), findsOneWidget);
      expect(find.text('حدث خطأ ما. يرجى المحاولة مرة أخرى.'),
          findsOneWidget);
      expect(find.text('عضو منذ يناير ٢٠٢٤'), findsOneWidget);
      expect(find.text('بطاقة'), findsOneWidget);
    });
  });
}
