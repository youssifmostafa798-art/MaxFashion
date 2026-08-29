import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/theme/app_text_styles.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/features/auth/presentation/widgets/custom_auth_button.dart';

class VerifyResetCodePage extends ConsumerStatefulWidget {
  const VerifyResetCodePage({super.key, required this.email});

  final String email;

  @override
  ConsumerState<VerifyResetCodePage> createState() =>
      _VerifyResetCodePageState();
}

class _VerifyResetCodePageState extends ConsumerState<VerifyResetCodePage> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  int _resendSeconds = 60;
  Timer? _resendTimer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _canResend = false;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _resendSeconds--;
          if (_resendSeconds <= 0) {
            _canResend = true;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  String get _enteredCode => _pinController.text;

  void _onVerify() {
    HapticUtils.light();
    final code = _enteredCode;
    if (code.length != 6) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterFullCode)),
      );
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    ref.read(authStateProvider.notifier).setLocalizations(l10n);
    ref.read(authStateProvider.notifier).verifyResetCode(
          email: widget.email,
          code: code,
        );
  }

  void _onResend() {
    HapticUtils.light();
    final l10n = AppLocalizations.of(context)!;
    ref.read(authStateProvider.notifier).setLocalizations(l10n);
    ref.read(authStateProvider.notifier).sendResetCode(
          email: widget.email,
        );
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    ref.read(authStateProvider.notifier).setLocalizations(l10n);

    ref.listen<AuthState>(authStateProvider, (prev, next) {
      if (!next.isLoading &&
          prev?.isLoading == true &&
          next.error == null &&
          next.resetCodeVerified) {
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            AppRouter.resetPassword,
            arguments: {
              'email': widget.email,
              'code': _enteredCode,
            },
          );
        }
        ref.read(authStateProvider.notifier).clearResetCodeVerified();
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

    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: AppTextStyles.fontSize18,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: colorScheme.outline,
          width: 1.w,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: colorScheme.onSurface,
        width: 1.2.w,
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: colorScheme.onSurface,
        width: 1.2.w,
      ),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: AppColors.errorRed400,
        width: 1.2.w,
      ),
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                l10n.verifyCodeTitle,
                style: TextStyle(
                  fontSize: AppTextStyles.fontSize32,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                l10n.enterCodeSentTo(widget.email),
                style: TextStyle(
                  fontSize: AppTextStyles.fontSize14,
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 48.h),
              Center(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    length: 6,
                    controller: _pinController,
                    focusNode: _pinFocusNode,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    errorPinTheme: errorPinTheme,
                    showCursor: true,
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (_) {
                      HapticUtils.light();
                    },
                  ),
                ),
              ),
              SizedBox(height: 36.h),
              CustomAuthButton(
                text: l10n.verifyCode,
                isLoading: authState.isLoading,
                onTap: _onVerify,
              ),
              SizedBox(height: 24.h),
              Center(
                child: _canResend
                    ? GestureDetector(
                        onTap: _onResend,
                        child: Text(
                          l10n.resendCode,
                          style: TextStyle(
                            fontSize: AppTextStyles.fontSize14,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      )
                    : Text(
                        l10n.resendCodeIn(_resendSeconds.toString()),
                        style: TextStyle(
                          fontSize: AppTextStyles.fontSize14,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
