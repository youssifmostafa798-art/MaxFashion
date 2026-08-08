import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/features/checkout/presentation/widgets/favorite_button.dart';
import 'package:max/data/models/product_model.dart';

class ProductGridCard extends StatefulWidget {
  const ProductGridCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductModel product;
  final VoidCallback onTap;

  @override
  State<ProductGridCard> createState() => _ProductGridCardState();
}

class _ProductGridCardState extends State<ProductGridCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticUtils.light();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'product-image-${widget.product.id}',
                  child: ClipRect(
                    child: AspectRatio(
                      aspectRatio: 0.70,
                      child: Image.asset(
                        widget.product.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8.w,
                  right: 8.w,
                  child: FavoriteButton(product: widget.product),
                ),
              ],
            ),
            Gap(10.h),
            CustomText(text: widget.product.name, maxLines: 1),
            CustomText(
              text: widget.product.description,
              color: colorScheme.onSurfaceVariant,
              maxLines: 2,
            ),
            Gap(9.h),
            CustomText(
              text: "\$ ${widget.product.price.toString()}",
              color: const Color(0xffDD8560),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
