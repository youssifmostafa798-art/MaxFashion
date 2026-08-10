import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/features/product/presentation/widgets/product_grid_card.dart';

class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key});

  static final List<ProductModel> _skeletonProducts = List.generate(
    6,
    (index) => ProductModel(
      id: 'sk$index',
      categoryId: 0,
      name: 'Loading product',
      description: 'Loading description',
      price: 0,
      brand: 'MaxFashion',
      thumbnailUrl: '',
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: true,
      containersColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.12),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _skeletonProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 15.w,
          childAspectRatio: 0.50,
        ),
        itemBuilder: (context, index) {
          return ProductGridCard(
            product: _skeletonProducts[index],
            onTap: () {},
          );
        },
      ),
    );
  }
}
