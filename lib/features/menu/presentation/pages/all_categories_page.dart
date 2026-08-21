import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/features/menu/presentation/widgets/category_item.dart';

class AllCategoriesPage extends ConsumerWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'ALL CATEGORIES',
          size: 18,
          color: colorScheme.onSurface,
          spacing: 4,
          weight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            HapticUtils.light();
            Navigator.pop(context);
          },
        ),
      ),
      body: categories.isEmpty
          ? _buildEmpty(context)
          : _AllCategoriesGrid(categories: categories),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.category_outlined,
                size: 48.w,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h),
            CustomText(
              text: 'No Categories Found',
              size: 18,
              color: colorScheme.onSurface,
              weight: FontWeight.w600,
              spacing: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _AllCategoriesGrid extends StatelessWidget {
  const _AllCategoriesGrid({required this.categories});
  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: CustomText(
            text:
                '${categories.length} ${categories.length == 1 ? 'category' : 'categories'}',
            size: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              return CategoryItem(category: categories[index], index: index);
            },
          ),
        ),
      ],
    );
  }
}
