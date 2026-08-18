import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/providers/wishlist_provider.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/widgets/guest_prompt_dialog.dart';

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({
    super.key,
    required this.product,
    this.size = 24,
  });

  final ProductModel product;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWishlisted = ref.watch(
      wishlistProvider.select((state) => state.items.any((p) => p.id == product.id)),
    );
    final isGuest = ref.watch(authStateProvider.select((s) => s.isGuest));

    return GestureDetector(
      onTap: () {
        HapticUtils.selection();
        if (isGuest) {
          showGuestPromptDialog(
            context: context,
            message: 'Sign in to save your favorite products.',
          );
          return;
        }
        ref.read(wishlistProvider.notifier).toggle(product);
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: Icon(
          isWishlisted ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isWishlisted),
          size: size.w,
          color: isWishlisted
              ? const Color(0xffDD8560)
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
