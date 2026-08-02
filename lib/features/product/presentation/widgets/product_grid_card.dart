import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/features/checkout/presentation/widgets/favorite_button.dart';
import 'package:max/data/models/product_model.dart';

class ProductGridCard extends StatelessWidget {
  const ProductGridCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(product.image),
              Positioned(
                top: 8.w,
                right: 8.w,
                child: FavoriteButton(product: product),
              ),
            ],
          ),
          Gap(10.h),
          CustemText(text: product.name),
          CustemText(
            text: product.descrp,
            color: colorScheme.onSurfaceVariant,
          ),
          Gap(9.h),
          CustemText(
            text: "\$ ${product.price.toString()}",
            color: const Color(0xffDD8560),
            size: 20,
          ),
        ],
      ),
    );
  }
}
