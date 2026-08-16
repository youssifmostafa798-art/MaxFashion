import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:max/core/router/app_router.dart';
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
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

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
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
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

  String get _enteredCode =>
      _controllers.map((c) => c.text).join();

  void _onVerify() {
    HapticUtils.light();
    final code = _enteredCode;
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 6-digit code')),
      );
      return;
    }

    ref.read(authStateProvider.notifier).verifyResetCode(
          email: widget.email,
          code: code,
        );
  }

  void _onResend() {
    HapticUtils.light();
    ref.read(authStateProvider.notifier).sendResetCode(
          email: widget.email,
        );
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20.w,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                'Verify\nCode',
                style: TextStyle(
                  fontSize: AppTextStyles.fontSize32,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Enter the 6-digit code sent to ${widget.email}',
                style: TextStyle(
                  fontSize: AppTextStyles.fontSize14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 48.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48.w,
                    height: 56.h,
                    child: KeyboardListener(
                      focusNode: FocusNode(),
                      onKeyEvent: (event) {
                        if (event is KeyDownEvent &&
                            event.logicalKey ==
                                LogicalKeyboardKey.backspace &&
                            _controllers[index].text.isEmpty &&
                            index > 0) {
                          _controllers[index - 1].clear();
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: AppTextStyles.fontSize18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceContainerHighest,
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                              width: 1.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onSurface,
                              width: 1.2.w,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 36.h),
              CustomAuthButton(
                text: 'Verify Code',
                isLoading: authState.isLoading,
                onTap: _onVerify,
              ),
              SizedBox(height: 24.h),
              Center(
                child: _canResend
                    ? GestureDetector(
                        onTap: _onResend,
                        child: Text(
                          'Resend Code',
                          style: TextStyle(
                            fontSize: AppTextStyles.fontSize14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      )
                    : Text(
                        'Resend code in ${_resendSeconds}s',
                        style: TextStyle(
                          fontSize: AppTextStyles.fontSize14,
                          fontWeight: FontWeight.w400,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
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
