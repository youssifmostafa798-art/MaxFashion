import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
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
  bool _minDelayComplete = false;
  bool _safetyTimeoutHasFired = false;
  Timer? _safetyTimeout;

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

    _startMinDelay();
    _safetyTimeout = Timer(const Duration(seconds: 10), _safetyTimeoutFired);
  }

  void _safetyTimeoutFired() {
    if (!mounted || _navigated) return;
    _safetyTimeoutHasFired = true;
    _minDelayComplete = true;
    _tryNavigate();
  }

  Future<void> _startMinDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted || _navigated) return;
    HapticFeedback.lightImpact();
    _minDelayComplete = true;
    _tryNavigate();
  }

  void _tryNavigate() {
    if (!_minDelayComplete || _navigated || !mounted) return;

    final authState = ref.read(authStateProvider);
    if (authState.isLoading) return;

    _performNavigation(authState);
  }

  void _performNavigation(AuthState authState) {
    if (!mounted || _navigated) return;

    if (authState.isAuthenticated || authState.isGuest) {
      _navigated = true;
      Navigator.pushReplacementNamed(context, AppRouter.main);
      return;
    }

    if (_safetyTimeoutHasFired) {
      _navigated = true;
      Navigator.pushReplacementNamed(context, AppRouter.auth);
      return;
    }

    final hasSession =
        supabase.Supabase.instance.client.auth.currentSession != null;
    if (hasSession) {
      return;
    }

    _navigated = true;
    Navigator.pushReplacementNamed(context, AppRouter.auth);
  }

  @override
  void dispose() {
    _safetyTimeout?.cancel();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authStateProvider, (prev, next) {
      if (!next.isLoading && _minDelayComplete && !_navigated) {
        _performNavigation(next);
      }
    });

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
