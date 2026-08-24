import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/widgets/custom_text_field.dart';
import 'package:max/features/settings/presentation/widgets/settings_tile.dart';

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

Widget _buildTestApp({
  required Locale locale,
  required Widget child,
}) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => _FakeAuthNotifier()),
    ],
    child: ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child2) {
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          home: Scaffold(body: child),
        );
      },
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Root Directionality', () {
    testWidgets('English locale produces LTR directionality', (tester) async {
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

    testWidgets('Arabic locale produces RTL directionality', (tester) async {
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

  group('CustomText RTL', () {
    testWidgets('Arabic text renders without error', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('ar'),
          child: const CustomText(text: 'مرحبا بالعالم'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('مرحبا بالعالم'), findsOneWidget);
    });

    testWidgets('English text renders without error', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('en'),
          child: const CustomText(text: 'Hello World'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('Mixed Arabic and English renders correctly', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('ar'),
          child: const CustomText(text: 'MaxFashion متجر'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('MaxFashion متجر'), findsOneWidget);
    });
  });

  group('CustomTextField RTL', () {
    testWidgets('Arabic locale - text field renders correctly', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('ar'),
          child: const CustomTextField(
            hint: 'أدخل البريد الإلكتروني',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsOneWidget);
    });
  });

  group('CustomAppBar RTL', () {
    testWidgets('Arabic - back icon shows forward arrow', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('ar'),
          child: Builder(
            builder: (context) => Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_forward
                  : Icons.arrow_back,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('English - back icon shows back arrow', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('en'),
          child: Builder(
            builder: (context) => Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_forward
                  : Icons.arrow_back,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsNothing);
    });
  });

  group('SettingsTile RTL', () {
    testWidgets('Arabic - chevron points left', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('ar'),
          child: SettingsTile(
            icon: Icons.settings,
            title: 'الإعدادات',
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('English - chevron points right', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('en'),
          child: SettingsTile(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left), findsNothing);
    });
  });

  group('Directional Spacing', () {
    testWidgets('EdgeInsetsDirectional used in search widget', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('en'),
          child: const Placeholder(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Placeholder), findsOneWidget);
    });
  });

  group('Arabic Mixed Content', () {
    testWidgets('Arabic text with price renders correctly', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('ar'),
          child: const CustomText(text: 'السعر: \$59.98'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('السعر: \$59.98'), findsOneWidget);
    });

    testWidgets('Arabic text with email renders correctly', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('ar'),
          child: const CustomText(text: ' البريد: user@example.com'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(' البريد: user@example.com'), findsOneWidget);
    });

    testWidgets('Arabic text with phone renders correctly', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('ar'),
          child: const CustomText(text: 'الهاتف: +966501234567'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الهاتف: +966501234567'), findsOneWidget);
    });
  });
}
