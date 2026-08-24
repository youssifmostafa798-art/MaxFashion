import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/theme/app_text_styles.dart';
import 'package:max/core/utils/form_validators.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:max/features/auth/presentation/widgets/custom_auth_text_field.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSignup() {
    HapticUtils.light();
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    ref.read(authStateProvider.notifier).setLocalizations(l10n);
    ref.read(authStateProvider.notifier).signUp(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.read(authStateProvider.notifier).setLocalizations(l10n);

    ref.listen<AuthState>(authStateProvider, (prev, next) {
      if (next.user != null && !next.isLoading) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.main,
          (route) => false,
        );
        return;
      }

      if (next.emailConfirmationPending && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            duration: const Duration(seconds: 6),
            backgroundColor: AppColors.successGreen700,
          ),
        );
        ref.read(authStateProvider.notifier).clearError();
        return;
      }

      if (next.error != null &&
          next.error!.isNotEmpty &&
          !next.emailConfirmationPending) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
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
                    l10n.createAccountTitle,
                    style: TextStyle(
                      fontSize: AppTextStyles.fontSize32,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    l10n.signUpToGetStarted,
                    style: TextStyle(
                      fontSize: AppTextStyles.fontSize14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 48.h),
                  CustomAuthTextField(
                    controller: _nameController,
                    hint: l10n.fullName,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.pleaseEnterName;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
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
                    controller: _phoneController,
                    hint: l10n.phoneNumber,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.pleaseEnterPhone;
                      }
                      final trimmed = value.trim();
                      if (trimmed.length != 11) {
                        return l10n.phoneMustBe11Digits;
                      }
                      if (!RegExp(r'^01[0-2,5]\d{8}$').hasMatch(trimmed)) {
                        return l10n.enterValidEgyptianPhone;
                      }
                      return null;
                    },
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
                  SizedBox(height: 16.h),
                  CustomAuthTextField(
                    controller: _confirmPasswordController,
                    hint: l10n.confirmPassword,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseConfirmPassword;
                      }
                      if (value != _passwordController.text) {
                        return l10n.passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 36.h),
                  if (authState.emailConfirmationPending) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen50,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.successGreen200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.mark_email_read_outlined,
                              color: AppColors.successGreen700, size: 24.w),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              l10n.emailConfirmationSent,
                              style: TextStyle(
                                fontSize: AppTextStyles.fontSize13,
                                color: AppColors.successGreen800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                  CustomAuthButton(
                    text: l10n.signUp,
                    isLoading: authState.isLoading,
                    onTap: _onSignup,
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
                    text: l10n.signIn,
                    isOutlined: true,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRouter.login);
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
