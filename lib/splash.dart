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
  late final AnimationController _logoController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  late final AnimationController _loaderController;
  late final Animation<double> _loaderFadeAnimation;

  bool _navigated = false;
  bool _minDelayComplete = false;
  bool _safetyTimeoutHasFired = false;
  Timer? _safetyTimeout;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _loaderFadeAnimation = CurvedAnimation(
      parent: _loaderController,
      curve: Curves.easeOut,
    );

    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _loaderController.forward();
      }
    });

    _logoController.forward();

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
    _logoController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authStateProvider, (prev, next) {
      if (!next.isLoading && _minDelayComplete && !_navigated) {
        _performNavigation(next);
      }
    });

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/logo/spalsh_logo.png',
                  width: 120.w,
                  height: 120.w,
                  cacheWidth: 120,
                ),
                SizedBox(height: 28.h),
                FadeTransition(
                  opacity: _loaderFadeAnimation,
                  child: _PulseLoader(color: colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PulseLoader extends StatefulWidget {
  const _PulseLoader({required this.color});

  final Color color;

  @override
  State<_PulseLoader> createState() => _PulseLoaderState();
}

class _PulseLoaderState extends State<_PulseLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.15;
            final value = (_controller.value - delay).clamp(0.0, 1.0);
            final opacity = value < 0.5
                ? (value / 0.5)
                : (1.0 - (value - 0.5) / 0.5);

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Opacity(
                opacity: opacity.clamp(0.2, 1.0),
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
