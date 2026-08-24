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

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _codeSent = false;
  bool _sendCodeRequested = false;

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
    _emailController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSendCode() {
    HapticUtils.light();
    if (!_formKey.currentState!.validate()) return;

    _sendCodeRequested = true;
    final l10n = AppLocalizations.of(context)!;
    ref.read(authStateProvider.notifier).setLocalizations(l10n);
    ref.read(authStateProvider.notifier).sendResetCode(
          email: _emailController.text.trim(),
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
          !_codeSent &&
          _sendCodeRequested) {
        if (mounted) {
          setState(() {
            _codeSent = true;
          });
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
                    l10n.forgotPasswordTitle,
                    style: TextStyle(
                      fontSize: AppTextStyles.fontSize32,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    l10n.enterEmailForCode,
                    style: TextStyle(
                      fontSize: AppTextStyles.fontSize14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 48.h),
                  if (_codeSent) ...[
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
                              l10n.verificationCodeSent,
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
                      text: l10n.enterCode,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.verifyResetCode,
                          arguments: _emailController.text.trim(),
                        );
                      },
                    ),
                  ] else ...[
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
                    SizedBox(height: 36.h),
                    CustomAuthButton(
                      text: l10n.sendVerificationCode,
                      isLoading: authState.isLoading,
                      onTap: _onSendCode,
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
