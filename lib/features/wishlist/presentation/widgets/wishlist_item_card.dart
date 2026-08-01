import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/data/models/product_model.dart';

class WishlistItemCard extends StatelessWidget {
  const WishlistItemCard({
    super.key,
    required this.product,
    required this.onRemove,
    required this.onMoveToCart,
    required this.onTap,
  });

  final ProductModel product;
  final VoidCallback onRemove;
  final VoidCallback onMoveToCart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                product.image,
                width: 90.w,
                height: 110.h,
                fit: BoxFit.cover,
                cacheWidth: 90,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustemText(
                          text: product.name.toUpperCase(),
                          size: 13,
                          color: colorScheme.onSurface,
                          spacing: 2,
                        ),
                      ),
                      GestureDetector(
                        onTap: onRemove,
                        child: Icon(
                          Icons.close,
                          size: 18.w,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Gap(6.h),
                  CustemText(
                    text: product.descrp,
                    size: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  Gap(8.h),
                  CustemText(
                    text: '\$${product.price.toStringAsFixed(2)}',
                    size: 15,
                    weight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  Gap(10.h),
                  GestureDetector(
                    onTap: onMoveToCart,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: CustemText(
                        text: 'MOVE TO CART',
                        size: 11,
                        color: colorScheme.surface,
                        spacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
