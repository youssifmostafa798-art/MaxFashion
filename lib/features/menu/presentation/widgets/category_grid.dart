import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/features/menu/presentation/widgets/category_item.dart';
import 'package:max/features/menu/presentation/widgets/see_more_category_card.dart';

class CategoryGrid extends ConsumerWidget {
  const CategoryGrid({super.key, this.showPreview = true, this.onSeeMoreTap});

  final bool showPreview;
  final VoidCallback? onSeeMoreTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (showPreview) {
      final previewCategories = ref.watch(previewCategoriesProvider);
      final allCategories = ref.watch(categoriesProvider);
      final hasMore = allCategories.length > previewCategories.length;
      final itemCount = previewCategories.length + (hasMore ? 1 : 0);

      return _buildGrid(
        categories: previewCategories,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (hasMore && index == previewCategories.length) {
            return SeeMoreCategoryCard(onTap: onSeeMoreTap ?? () {});
          }
          return CategoryItem(category: previewCategories[index], index: index);
        },
      );
    }

    final allCategories = ref.watch(categoriesProvider);
    return _buildGrid(
      categories: allCategories,
      itemCount: allCategories.length,
      itemBuilder: (context, index) {
        return CategoryItem(category: allCategories[index], index: index);
      },
    );
  }

  Widget _buildGrid({
    required List<CategoryModel> categories,
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.85,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
