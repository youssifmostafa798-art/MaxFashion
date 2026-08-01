import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/wishlist_provider.dart';

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
      wishlistProvider.select((items) => items.any((p) => p.id == product.id)),
    );

    return GestureDetector(
      onTap: () {
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
