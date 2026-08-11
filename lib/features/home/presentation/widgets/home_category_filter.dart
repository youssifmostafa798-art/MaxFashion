import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/providers/product_provider.dart';

class HomeCategoryFilter extends StatelessWidget {
  const HomeCategoryFilter({super.key, required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length + 1,
        separatorBuilder: (_, _) => Gap(8.w),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const HomeCategoryChip(label: 'All', categoryId: null);
          }
          final category = categories[index - 1];
          return HomeCategoryChip(label: category.name, categoryId: category.id);
        },
      ),
    );
  }
}

class HomeCategoryChip extends ConsumerWidget {
  const HomeCategoryChip({super.key, required this.label, required this.categoryId});

  final String label;
  final int? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedId = ref.watch(selectedCategoryProvider);
    final isSelected = selectedId == categoryId;

    return GestureDetector(
      onTap: () {
        HapticUtils.light();
        ref.read(selectedCategoryProvider.notifier).state = categoryId;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.onSurface
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.center,
        child: CustomText(
          text: label.toUpperCase(),
          size: 12,
          color: isSelected ? colorScheme.surface : colorScheme.onSurface,
          weight: isSelected ? FontWeight.bold : FontWeight.normal,
          spacing: 2,
        ),
      ),
    );
  }
}
