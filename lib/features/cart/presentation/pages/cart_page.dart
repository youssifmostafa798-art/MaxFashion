import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/core/widgets/skeletons/cart_skeleton.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/errors/app_error_messages.dart';
import 'package:max/features/cart/presentation/widgets/cart_content.dart';
import 'package:max/features/cart/presentation/widgets/empty_cart.dart';
import 'package:max/features/cart/presentation/widgets/guest_cart_view.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  String? _lastShownError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cartState = ref.watch(cartProvider);
    final authState = ref.watch(authStateProvider);
    final isGuest = authState.isGuest;
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<CartState>(cartProvider, (previous, next) {
      if (next.error != null && next.error != _lastShownError) {
        _lastShownError = next.error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(
              text: AppErrorMessages.resolve(l10n, next.error),
              size: 14,
              color: colorScheme.surface,
            ),
            backgroundColor: colorScheme.error,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      }
      if (next.error == null) {
        _lastShownError = null;
      }
    });

    if (isGuest) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: CustomText(
            text: l10n.myBag.toUpperCase(),
            size: 18,
            color: colorScheme.onSurface,
            spacing: 4,
            weight: FontWeight.bold,
          ),
        ),
        body: const GuestCartView(),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: l10n.myBag.toUpperCase(),
          size: 18,
          color: colorScheme.onSurface,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: cartState.isLoading
          ? const CartSkeleton()
          : cartState.items.isEmpty
              ? const EmptyCart()
              : CartContent(cartState: cartState),
    );
  }
}
