import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/theme/app_text_styles.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/features/auth/presentation/widgets/custom_auth_button.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  Image.asset(
                    'assets/logo/logo.png',
                    width: 120.w,
                    height: 120.w,
                    cacheWidth: 120,
                  ),
                  const Spacer(flex: 3),
                  CustomAuthButton(
                    text: l10n.createAccount,
                    isOutlined: true,
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.signup);
                    },
                  ),
                  SizedBox(height: 16.h),
                  CustomAuthButton(
                    text: l10n.alreadyHaveAccount,
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.login);
                    },
                  ),
                  SizedBox(height: 32.h),
                  GestureDetector(
                    onTap: () {
                      HapticUtils.light();
                      ref.read(authStateProvider.notifier).enterGuestMode();
                      Navigator.pushReplacementNamed(context, AppRouter.main);
                    },
                    child: Text(
                      l10n.continueAsGuest,
                      style: TextStyle(
                        fontSize: AppTextStyles.fontSize13,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
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
