import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/utils/form_validators.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/theme/app_text_styles.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:max/features/auth/presentation/widgets/custom_auth_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getBool('auth_remember_me');
      if (mounted && saved != null) {
        setState(() {
          _rememberMe = saved;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onLogin() {
    HapticUtils.light();
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    ref.read(authStateProvider.notifier).setLocalizations(l10n);
    ref.read(authStateProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.read(authStateProvider.notifier).setLocalizations(l10n);

    ref.listen<AuthState>(authStateProvider, (prev, next) {
      if (next.user != null && !next.isLoading) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.main,
            (route) => false,
          );
        }
        return;
      }
      if (next.error != null && next.error!.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!)),
          );
        }
        ref.read(authStateProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_back_ios_new,
                      size: 20.w,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    l10n.welcomeBack,
                    style: TextStyle(
                      fontSize: AppTextStyles.fontSize32,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    l10n.signInToContinue,
                    style: TextStyle(
                      fontSize: AppTextStyles.fontSize14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 48.h),
                  CustomAuthTextField(
                    controller: _emailController,
                    hint: l10n.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => FormValidators.validateEmail(
                      value,
                      emptyError: l10n.emailRequired,
                      invalidError: l10n.emailInvalid,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomAuthTextField(
                    controller: _passwordController,
                    hint: l10n.password,
                    isPassword: true,
                    validator: (value) => FormValidators.validatePassword(
                      value,
                      emptyError: l10n.passwordRequired,
                      tooShortError: l10n.passwordTooShort,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRouter.forgotPassword);
                      },
                      child: Text(
                        l10n.forgotPassword,
                        style: TextStyle(
                          fontSize: AppTextStyles.fontSize13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 36.h),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          HapticUtils.selection();
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(
                        l10n.rememberMe,
                        style: TextStyle(
                          fontSize: AppTextStyles.fontSize13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  CustomAuthButton(
                    text: l10n.signIn,
                    isLoading: authState.isLoading,
                    onTap: _onLogin,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          l10n.or,
                          style: TextStyle(
                            fontSize: AppTextStyles.fontSize12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  CustomAuthButton(
                    text: l10n.signUp,
                    isOutlined: true,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRouter.signup);
                    },
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
