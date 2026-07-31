import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/providers/search_provider.dart';

class RecentSearchesSection extends ConsumerWidget {
  const RecentSearchesSection({super.key, required this.onTap});

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentSearches = ref.watch(searchProvider.select((s) => s.recentSearches));

    if (recentSearches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustemText(
                text: 'RECENT SEARCHES',
                size: 12,
                color: AppColors.grey600,
                spacing: 3,
              ),
              GestureDetector(
                onTap: () => ref.read(searchProvider.notifier).clearRecentSearches(),
                child: CustemText(
                  text: 'Clear all',
                  size: 12,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        ),
        Gap(12.h),
        SizedBox(
          height: 36.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: recentSearches.length,
            separatorBuilder: (_, _) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final query = recentSearches[index];
              return GestureDetector(
                onTap: () => onTap(query),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history, size: 14.w, color: AppColors.grey500),
                      SizedBox(width: 6.w),
                      CustemText(
                        text: query,
                        size: 12,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: () => ref.read(searchProvider.notifier).removeRecentSearch(query),
                        child: Icon(Icons.close, size: 12.w, color: AppColors.grey500),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SuggestedProductsSection extends StatelessWidget {
  const SuggestedProductsSection({super.key, required this.products});

  final List<dynamic> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustemText(
            text: 'SUGGESTED FOR YOU',
            size: 12,
            color: AppColors.grey600,
            spacing: 3,
          ),
        ),
        Gap(12.h),
        SizedBox(
          height: 140.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: products.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => Scaffold(),
                    ),
                  );
                },
                child: SizedBox(
                  width: 100.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          product.image,
                          width: 100.w,
                          height: 100.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Gap(6.h),
                      CustemText(
                        text: product.name.replaceAll('\n', ' '),
                        size: 11,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PopularCategoriesSection extends StatelessWidget {
  const PopularCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustemText(
            text: 'POPULAR CATEGORIES',
            size: 12,
            color: AppColors.grey600,
            spacing: 3,
          ),
        ),
        Gap(12.h),
        SizedBox(
          height: 90.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: CategoryModel.categories.length,
            separatorBuilder: (_, _) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              final cat = CategoryModel.categories[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      cat.icon,
                      color: AppColors.primary,
                      size: 24.w,
                    ),
                  ),
                  Gap(6.h),
                  CustemText(
                    text: cat.name,
                    size: 11,
                    color: AppColors.primary,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
