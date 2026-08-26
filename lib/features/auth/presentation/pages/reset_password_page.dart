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

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.code,
  });

  final String email;
  final String code;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordUpdated = false;
  bool _updatePasswordRequested = false;

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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onUpdatePassword() {
    HapticUtils.light();
    if (!_formKey.currentState!.validate()) return;

    _updatePasswordRequested = true;
    final l10n = AppLocalizations.of(context)!;
    ref.read(authStateProvider.notifier).setLocalizations(l10n);
    ref.read(authStateProvider.notifier).resetPasswordWithCode(
          email: widget.email,
          code: widget.code,
          newPassword: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.read(authStateProvider.notifier).setLocalizations(l10n);

    ref.listen<AuthState>(authStateProvider, (prev, next) {
      if (!next.isLoading &&
          prev?.isLoading == true &&
          next.error == null &&
          _passwordUpdated == false &&
          _updatePasswordRequested) {
        if (mounted) {
          setState(() {
            _passwordUpdated = true;
            _updatePasswordRequested = false;
          });
        }
        return;
      }

      if (next.error != null && next.error!.isNotEmpty) {
        if (mounted) {
          setState(() {
            _updatePasswordRequested = false;
          });
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
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Directionality.of(context) == TextDirection.rtl
                            ? Icons.arrow_forward
                            : Icons.arrow_back,
                        size: 24.w,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    l10n.newPasswordTitle,
                    style: TextStyle(
                      fontSize: AppTextStyles.fontSize32,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    l10n.createNewPasswordSubtitle,
                    style: TextStyle(
                      fontSize: AppTextStyles.fontSize14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 48.h),
                  if (_passwordUpdated) ...[
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
                          Icon(Icons.check_circle_outline,
                              color: AppColors.successGreen700, size: 24.w),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              l10n.passwordUpdatedSuccess,
                              style: TextStyle(
                                fontSize: AppTextStyles.fontSize13,
                                color: AppColors.successGreen800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    CustomAuthButton(
                      text: l10n.goToLogin,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, AppRouter.login);
                      },
                    ),
                  ] else ...[
                    CustomAuthTextField(
                      controller: _passwordController,
                      hint: l10n.newPassword,
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
                    CustomAuthButton(
                      text: l10n.updatePassword,
                      isLoading: authState.isLoading,
                      onTap: _onUpdatePassword,
                    ),
                  ],
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
