import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:max/core/widgets/category_grid_card.dart';
import 'package:max/data/models/category_model.dart';

class CategoryGridSkeleton extends StatelessWidget {
  const CategoryGridSkeleton({super.key});

  static final List<CategoryModel> _skeletonCategories = List.generate(
    12,
    (index) => const CategoryModel(
      id: 0,
      name: 'Loading',
      slug: '',
      iconName: '',
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: true,
      containersColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _skeletonCategories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          return CategoryGridCard(
            category: _skeletonCategories[index],
            onTap: () {},
          );
        },
      ),
    );
  }
}
