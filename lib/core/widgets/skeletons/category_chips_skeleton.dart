import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:max/core/widgets/category_chip_card.dart';
import 'package:max/data/models/category_model.dart';

class CategoryChipsSkeleton extends StatelessWidget {
  const CategoryChipsSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  static final List<CategoryModel> _skeletonCategories = List.generate(
    5,
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
      child: SizedBox(
        height: 90.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: itemCount,
          separatorBuilder: (_, _) => SizedBox(width: 16.w),
          itemBuilder: (context, index) {
            return CategoryChipCard(
              category: _skeletonCategories[index],
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}
