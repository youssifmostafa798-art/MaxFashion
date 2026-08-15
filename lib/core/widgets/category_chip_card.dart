import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/category_icon.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/category_model.dart';

class CategoryChipCard extends StatelessWidget {
  const CategoryChipCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final CategoryModel category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CategoryIcon(
            assetPath: category.iconAssetPath,
            size: 56,
            borderRadius: 14,
          ),
          Gap(6.h),
          CustomText(
            text: category.name,
            size: 11,
            color: colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}
