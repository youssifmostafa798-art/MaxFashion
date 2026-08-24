import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/models/user_model.dart';
import 'package:max/features/auth/presentation/pages/auth_page.dart';
import 'package:max/features/auth/presentation/pages/login_page.dart';
import 'package:max/features/auth/presentation/pages/signup_page.dart';
import 'package:max/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:max/features/auth/presentation/pages/verify_reset_code_page.dart';
import 'package:max/features/auth/presentation/pages/reset_password_page.dart';

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
}) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => _FakeAuthNotifier()),
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

  group('AuthPage', () {
    testWidgets('English - renders all buttons', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const AuthPage(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('CREATE ACCOUNT'), findsOneWidget);
      expect(find.text('Already have account'), findsOneWidget);
      expect(find.text('Continue as Guest'), findsOneWidget);
    });

    testWidgets('Arabic - renders all buttons', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const AuthPage(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('إنشاء حساب'), findsOneWidget);
      expect(find.text('لديك حساب بالفعل'), findsOneWidget);
      expect(find.text('المتابعة كضيف'), findsOneWidget);
    });
  });

  group('LoginPage', () {
    testWidgets('English - renders all UI elements', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const LoginPage(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Welcome\nBack'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Remember Me'), findsOneWidget);
      expect(find.text('SIGN IN'), findsOneWidget);
      expect(find.text('OR'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('Arabic - renders all UI elements', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const LoginPage(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('مرحباً بعودتك'), findsOneWidget);
      expect(find.text('سجل الدخول للمتابعة'), findsOneWidget);
      expect(find.text('البريد الإلكتروني'), findsOneWidget);
      expect(find.text('كلمة المرور'), findsOneWidget);
      expect(find.text('نسيت كلمة المرور؟'), findsOneWidget);
      expect(find.text('تذكرني'), findsOneWidget);
      expect(find.text('تسجيل الدخول'), findsOneWidget);
      expect(find.text('أو'), findsOneWidget);
      expect(find.text('إنشاء حساب'), findsOneWidget);
    });
  });

  group('SignupPage', () {
    testWidgets('English - renders all UI elements', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const SignupPage(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Create\nAccount'), findsOneWidget);
      expect(find.text('Sign up to get started'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('Arabic - renders all UI elements', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const SignupPage(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('إنشاء\nحساب'), findsOneWidget);
      expect(find.text('أنشئ حسابك للبدء'), findsOneWidget);
      expect(find.text('الاسم الكامل'), findsOneWidget);
      expect(find.text('البريد الإلكتروني'), findsOneWidget);
      expect(find.text('رقم الهاتف'), findsOneWidget);
      expect(find.text('كلمة المرور'), findsOneWidget);
      expect(find.text('تأكيد كلمة المرور'), findsOneWidget);
    });

    testWidgets('English - validation shows localized messages',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const SignupPage(),
      ));
      await tester.pumpAndSettle();

      // Verify validation messages exist in the l10n
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(l10n.pleaseEnterName, 'Please enter your name');
      expect(l10n.emailRequired, 'Please enter your email');
      expect(l10n.passwordRequired, 'Please enter your password');
    });
  });

  group('ForgotPasswordPage', () {
    testWidgets('English - renders UI elements', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const ForgotPasswordPage(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Forgot\nPassword'), findsOneWidget);
      expect(find.text('Enter your email to receive a verification code'),
          findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Send Verification Code'), findsOneWidget);
    });

    testWidgets('Arabic - renders UI elements', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const ForgotPasswordPage(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('نسيت\nكلمة المرور'), findsOneWidget);
      expect(find.text('أدخل بريدك الإلكتروني لتستلم رمز التحقق'),
          findsOneWidget);
      expect(find.text('البريد الإلكتروني'), findsOneWidget);
      expect(find.text('إرسال رمز التحقق'), findsOneWidget);
    });
  });

  group('VerifyResetCodePage', () {
    testWidgets('English - renders UI elements', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const VerifyResetCodePage(email: 'test@example.com'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Verify\nCode'), findsOneWidget);
      expect(
          find.text('Enter the 6-digit code sent to test@example.com'),
          findsOneWidget);
      expect(find.text('Verify Code'), findsOneWidget);
    });

    testWidgets('Arabic - renders UI elements', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const VerifyResetCodePage(email: 'test@example.com'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('التحقق\nمن الرمز'), findsOneWidget);
      expect(
          find.text(
              'أدخل الرمز المكون من 6 أرقام المرسل إلى test@example.com'),
          findsOneWidget);
      expect(find.text('تحقق من الرمز'), findsOneWidget);
    });

    testWidgets('English - shows resend countdown', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const VerifyResetCodePage(email: 'test@example.com'),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Resend code in'), findsOneWidget);
    });

    testWidgets('Arabic - shows resend countdown', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const VerifyResetCodePage(email: 'test@example.com'),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('إعادة الإرسال خلال'), findsOneWidget);
    });
  });

  group('ResetPasswordPage', () {
    testWidgets('English - renders UI elements', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('en'),
        child: const ResetPasswordPage(
            email: 'test@example.com', code: '123456'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('New\nPassword'), findsOneWidget);
      expect(find.text('Create a new password for your account'),
          findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Update Password'), findsOneWidget);
    });

    testWidgets('Arabic - renders UI elements', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        locale: const Locale('ar'),
        child: const ResetPasswordPage(
            email: 'test@example.com', code: '123456'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('كلمة المرور\nالجديدة'), findsOneWidget);
      expect(find.text('أنشئ كلمة مرور جديدة لحسابك'), findsOneWidget);
      expect(find.text('كلمة المرور الجديدة'), findsOneWidget);
      expect(find.text('تأكيد كلمة المرور'), findsOneWidget);
      expect(find.text('تحديث كلمة المرور'), findsOneWidget);
    });
  });

  group('AppLocalizations auth keys', () {
    testWidgets('English locale has all auth keys', (tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      // Login page keys
      expect(l10n.welcomeBack, isNotEmpty);
      expect(l10n.signInToContinue, isNotEmpty);
      expect(l10n.email, isNotEmpty);
      expect(l10n.password, isNotEmpty);
      expect(l10n.forgotPassword, isNotEmpty);
      expect(l10n.rememberMe, isNotEmpty);
      expect(l10n.or, isNotEmpty);
      expect(l10n.signUp, isNotEmpty);

      // Signup page keys
      expect(l10n.createAccountTitle, isNotEmpty);
      expect(l10n.signUpToGetStarted, isNotEmpty);
      expect(l10n.fullName, isNotEmpty);
      expect(l10n.phoneNumber, isNotEmpty);
      expect(l10n.confirmPassword, isNotEmpty);
      expect(l10n.pleaseEnterName, isNotEmpty);
      expect(l10n.pleaseEnterPhone, isNotEmpty);
      expect(l10n.phoneMustBe11Digits, isNotEmpty);
      expect(l10n.enterValidEgyptianPhone, isNotEmpty);
      expect(l10n.pleaseConfirmPassword, isNotEmpty);
      expect(l10n.passwordsDoNotMatch, isNotEmpty);
      expect(l10n.emailConfirmationSent, isNotEmpty);

      // Auth page keys
      expect(l10n.alreadyHaveAccount, isNotEmpty);
      expect(l10n.continueAsGuest, isNotEmpty);

      // Forgot password keys
      expect(l10n.forgotPasswordTitle, isNotEmpty);
      expect(l10n.enterEmailForCode, isNotEmpty);
      expect(l10n.verificationCodeSent, isNotEmpty);
      expect(l10n.enterCode, isNotEmpty);
      expect(l10n.sendVerificationCode, isNotEmpty);

      // Verify code keys
      expect(l10n.verifyCodeTitle, isNotEmpty);
      expect(l10n.enterCodeSentTo('test@example.com'), isNotEmpty);
      expect(l10n.pleaseEnterFullCode, isNotEmpty);
      expect(l10n.verifyCode, isNotEmpty);
      expect(l10n.resendCode, isNotEmpty);
      expect(l10n.resendCodeIn('60'), isNotEmpty);

      // Reset password keys
      expect(l10n.newPasswordTitle, isNotEmpty);
      expect(l10n.createNewPasswordSubtitle, isNotEmpty);
      expect(l10n.passwordUpdatedSuccess, isNotEmpty);
      expect(l10n.goToLogin, isNotEmpty);
      expect(l10n.newPassword, isNotEmpty);
      expect(l10n.updatePassword, isNotEmpty);

      // Error mapping keys
      expect(l10n.accountAlreadyExists, isNotEmpty);
      expect(l10n.incorrectEmailOrPassword, isNotEmpty);
      expect(l10n.invalidOrExpiredCode, isNotEmpty);
      expect(l10n.noInternetConnection, isNotEmpty);
      expect(l10n.connectionTimedOut, isNotEmpty);
      expect(l10n.pleaseWaitBeforeResend, isNotEmpty);
      expect(l10n.couldNotLoadProfile, isNotEmpty);
    });

    testWidgets('Arabic locale has all auth keys', (tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('ar'));

      // Login page keys
      expect(l10n.welcomeBack, isNotEmpty);
      expect(l10n.signInToContinue, isNotEmpty);
      expect(l10n.email, isNotEmpty);
      expect(l10n.password, isNotEmpty);
      expect(l10n.forgotPassword, isNotEmpty);
      expect(l10n.rememberMe, isNotEmpty);
      expect(l10n.or, isNotEmpty);
      expect(l10n.signUp, isNotEmpty);

      // Signup page keys
      expect(l10n.createAccountTitle, isNotEmpty);
      expect(l10n.signUpToGetStarted, isNotEmpty);
      expect(l10n.fullName, isNotEmpty);
      expect(l10n.phoneNumber, isNotEmpty);
      expect(l10n.confirmPassword, isNotEmpty);
      expect(l10n.pleaseEnterName, isNotEmpty);
      expect(l10n.pleaseEnterPhone, isNotEmpty);
      expect(l10n.phoneMustBe11Digits, isNotEmpty);
      expect(l10n.enterValidEgyptianPhone, isNotEmpty);
      expect(l10n.pleaseConfirmPassword, isNotEmpty);
      expect(l10n.passwordsDoNotMatch, isNotEmpty);
      expect(l10n.emailConfirmationSent, isNotEmpty);

      // Auth page keys
      expect(l10n.alreadyHaveAccount, isNotEmpty);
      expect(l10n.continueAsGuest, isNotEmpty);

      // Forgot password keys
      expect(l10n.forgotPasswordTitle, isNotEmpty);
      expect(l10n.enterEmailForCode, isNotEmpty);
      expect(l10n.verificationCodeSent, isNotEmpty);
      expect(l10n.enterCode, isNotEmpty);
      expect(l10n.sendVerificationCode, isNotEmpty);

      // Verify code keys
      expect(l10n.verifyCodeTitle, isNotEmpty);
      expect(l10n.enterCodeSentTo('test@example.com'), isNotEmpty);
      expect(l10n.pleaseEnterFullCode, isNotEmpty);
      expect(l10n.verifyCode, isNotEmpty);
      expect(l10n.resendCode, isNotEmpty);
      expect(l10n.resendCodeIn('60'), isNotEmpty);

      // Reset password keys
      expect(l10n.newPasswordTitle, isNotEmpty);
      expect(l10n.createNewPasswordSubtitle, isNotEmpty);
      expect(l10n.passwordUpdatedSuccess, isNotEmpty);
      expect(l10n.goToLogin, isNotEmpty);
      expect(l10n.newPassword, isNotEmpty);
      expect(l10n.updatePassword, isNotEmpty);

      // Error mapping keys
      expect(l10n.accountAlreadyExists, isNotEmpty);
      expect(l10n.incorrectEmailOrPassword, isNotEmpty);
      expect(l10n.invalidOrExpiredCode, isNotEmpty);
      expect(l10n.noInternetConnection, isNotEmpty);
      expect(l10n.connectionTimedOut, isNotEmpty);
      expect(l10n.pleaseWaitBeforeResend, isNotEmpty);
      expect(l10n.couldNotLoadProfile, isNotEmpty);
    });
  });
}
