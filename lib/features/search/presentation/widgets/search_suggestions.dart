import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/features/checkout/presentation/widgets/favorite_button.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/data/providers/search_provider.dart';
import 'package:max/features/product/presentation/pages/product_detail_page.dart';
import 'package:max/features/product/presentation/pages/product_listing_page.dart';

class RecentSearchesSection extends ConsumerWidget {
  const RecentSearchesSection({super.key, required this.onTap});

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentSearches = ref.watch(searchProvider.select((s) => s.recentSearches));
    final colorScheme = Theme.of(context).colorScheme;

    if (recentSearches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'RECENT SEARCHES',
                size: 12,
                color: colorScheme.onSurfaceVariant,
                spacing: 3,
              ),
              GestureDetector(
                onTap: () => ref.read(searchProvider.notifier).clearRecentSearches(),
                child: CustomText(
                  text: 'Clear all',
                  size: 12,
                  color: colorScheme.onSurfaceVariant,
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
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history, size: 14.w, color: colorScheme.onSurfaceVariant),
                      SizedBox(width: 6.w),
                      CustomText(
                        text: query,
                        size: 12,
                        color: colorScheme.onSurface,
                      ),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: () => ref.read(searchProvider.notifier).removeRecentSearch(query),
                        child: Icon(Icons.close, size: 12.w, color: colorScheme.onSurfaceVariant),
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

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomText(
            text: 'SUGGESTED FOR YOU',
            size: 12,
            color: colorScheme.onSurfaceVariant,
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
                      builder: (c) => ProductDetailPage(product: product),
                    ),
                  );
                },
              child: SizedBox(
                width: 100.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Hero(
                          tag: 'product-image-${product.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.asset(
                              product.image,
                              width: 100.w,
                              height: 100.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                          Positioned(
                            top: 4.w,
                            right: 4.w,
                            child: FavoriteButton(product: product, size: 18),
                          ),
                        ],
                      ),
                      Gap(6.h),
                      CustomText(
                        text: product.name.replaceAll('\n', ' '),
                        size: 11,
                        color: colorScheme.onSurface,
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

class PopularCategoriesSection extends ConsumerWidget {
  const PopularCategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final categories = ref.watch(categoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomText(
            text: 'POPULAR CATEGORIES',
            size: 12,
            color: colorScheme.onSurfaceVariant,
            spacing: 3,
          ),
        ),
        Gap(12.h),
        SizedBox(
          height: 90.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: categories.length,
            separatorBuilder: (_, _) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductListingPage(category: cat.name),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        cat.icon,
                        color: colorScheme.onSurface,
                        size: 24.w,
                      ),
                    ),
                    Gap(6.h),
                    CustomText(
                      text: cat.name,
                      size: 11,
                      color: colorScheme.onSurface,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
