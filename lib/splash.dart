import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/data/providers/auth_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _navigated = false;
  Timer? _authTimer;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    _scaleController.forward();

    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted || _navigated) return;

    HapticFeedback.lightImpact();

    final authState = ref.read(authStateProvider);

    if (authState.isLoading) {
      _waitForAuthAndNavigate();
      return;
    }

    _performNavigation(authState);
  }

  void _waitForAuthAndNavigate() {
    _authTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted || _navigated) {
        timer.cancel();
        return;
      }
      final authState = ref.read(authStateProvider);
      if (!authState.isLoading) {
        timer.cancel();
        _performNavigation(authState);
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_navigated) {
        _authTimer?.cancel();
        final authState = ref.read(authStateProvider);
        _performNavigation(authState);
      }
    });
  }

  void _performNavigation(AuthState authState) {
    if (!mounted || _navigated) return;
    _navigated = true;

    if (authState.isAuthenticated || authState.isGuest) {
      Navigator.pushReplacementNamed(context, AppRouter.main);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.auth);
    }
  }

  @override
  void dispose() {
    _authTimer?.cancel();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/logo.png',
                  width: 120.w,
                  height: 120.w,
                  cacheWidth: 120,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
