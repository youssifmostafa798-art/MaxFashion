import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/l10n/language_provider.dart';
import 'package:max/core/theme/theme_provider.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/features/settings/presentation/pages/settings_page.dart';

class _FakeAuthNotifier extends StateNotifier<AuthState>
    implements AuthNotifier {
  _FakeAuthNotifier({AuthState initialState = const AuthState()})
      : super(initialState);

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
  void setLocalizations(AppLocalizations l10n) {}

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

class _FakeThemeNotifier extends StateNotifier<ThemeMode>
    implements ThemeNotifier {
  _FakeThemeNotifier() : super(ThemeMode.system);

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
  }
}

Widget buildTestApp({String languageCode = 'en'}) {
  return ProviderScope(
    overrides: [
      themeProvider.overrideWith((ref) => _FakeThemeNotifier()),
      authStateProvider.overrideWith(
        (ref) => _FakeAuthNotifier(),
      ),
    ],
    child: ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(languageCode),
          home: const SettingsPage(),
        );
      },
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Settings Language Tile', () {
    testWidgets('displays "English" subtitle when locale is en', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('displays Arabic language name subtitle when locale is ar',
        (tester) async {
      SharedPreferences.setMockInitialValues({'language_code': 'ar'});
      await tester.pumpWidget(buildTestApp(languageCode: 'ar'));
      await tester.pumpAndSettle();

      final allTexts = find.byType(Text).evaluate().map((e) {
        final widget = e.widget as Text;
        return widget.data;
      }).whereType<String>().toList();

      expect(allTexts, contains('العربية'));
    });

    testWidgets('opens bottom sheet when language tile is tapped',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      expect(find.text('English'), findsWidgets);
    });

    testWidgets('shows checkmark next to English when en is selected',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      final englishTile = find.widgetWithText(ListTile, 'English');
      expect(
        find.descendant(of: englishTile, matching: find.byIcon(Icons.check)),
        findsOneWidget,
      );
    });

    testWidgets('shows checkmark next to Arabic when ar is selected',
        (tester) async {
      SharedPreferences.setMockInitialValues({'language_code': 'ar'});
      await tester.pumpWidget(buildTestApp(languageCode: 'ar'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('اللغة'));
      await tester.pumpAndSettle();

      final arabicTile = find.widgetWithText(ListTile, 'العربية');
      expect(
        find.descendant(of: arabicTile, matching: find.byIcon(Icons.check)),
        findsOneWidget,
      );
    });

    testWidgets('selecting Arabic updates locale provider', (tester) async {
      final container = ProviderContainer(
        overrides: [
          themeProvider.overrideWith((ref) => _FakeThemeNotifier()),
          authStateProvider.overrideWith(
            (ref) => _FakeAuthNotifier(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: const SettingsPage(),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final locale = ValueNotifier<Locale>(const Locale('en'));
      container.listen(localeProvider, (prev, next) {
        locale.value = next;
      });

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('العربية').last);
      await tester.pumpAndSettle();

      expect(locale.value.languageCode, 'ar');
    });

    testWidgets('selecting English updates locale provider', (tester) async {
      SharedPreferences.setMockInitialValues({'language_code': 'ar'});
      final container = ProviderContainer(
        overrides: [
          themeProvider.overrideWith((ref) => _FakeThemeNotifier()),
          authStateProvider.overrideWith(
            (ref) => _FakeAuthNotifier(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: const Locale('ar'),
                home: const SettingsPage(),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final locale = ValueNotifier<Locale>(const Locale('ar'));
      container.listen(localeProvider, (prev, next) {
        locale.value = next;
      });

      await tester.tap(find.text('اللغة'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();

      expect(locale.value.languageCode, 'en');
    });

    testWidgets('selecting Arabic persists the preference', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('العربية').last);
      await tester.pumpAndSettle();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('language_code'), 'ar');
    });

    testWidgets('selecting English persists the preference', (tester) async {
      SharedPreferences.setMockInitialValues({'language_code': 'ar'});
      await tester.pumpWidget(buildTestApp(languageCode: 'ar'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('اللغة'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('language_code'), 'en');
    });
  });

  group('Root Directionality', () {
    testWidgets('Locale("en") produces LTR directionality', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: const Placeholder(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final directionality =
          Directionality.of(tester.element(find.byType(Placeholder)));
      expect(directionality, TextDirection.ltr);
    });

    testWidgets('Locale("ar") produces RTL directionality', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ar'),
            home: const Placeholder(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final directionality =
          Directionality.of(tester.element(find.byType(Placeholder)));
      expect(directionality, TextDirection.rtl);
    });
  });
}
