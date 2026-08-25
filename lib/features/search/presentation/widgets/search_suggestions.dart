import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:max/core/widgets/category_chip_card.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/widgets/skeletons/category_chips_skeleton.dart';
import 'package:max/features/checkout/presentation/widgets/favorite_button.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/data/providers/search_provider.dart';
import 'package:max/features/product/presentation/pages/product_detail_page.dart';
import 'package:max/features/product/presentation/pages/product_listing_page.dart';
import 'package:max/core/l10n/app_localizations.dart';

class RecentSearchesSection extends ConsumerWidget {
  const RecentSearchesSection({super.key, required this.onTap});

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
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
                text: l10n.recentSearches.toUpperCase(),
                size: 12,
                color: colorScheme.onSurfaceVariant,
                spacing: 3,
              ),
              GestureDetector(
                onTap: () => ref.read(searchProvider.notifier).clearRecentSearches(),
                child: CustomText(
                  text: l10n.clearAll,
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
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomText(
            text: l10n.suggestedForYou.toUpperCase(),
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
                            child: Image.network(
                              product.image,
                              width: 100.w,
                              height: 100.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 100.w,
                                height: 100.h,
                                color: colorScheme.surfaceContainerHighest,
                                child: Icon(
                                  Icons.image_outlined,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                          PositionedDirectional(
                            top: 4.w,
                            end: 4.w,
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
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final categories = ref.watch(categoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomText(
            text: l10n.popularCategories.toUpperCase(),
            size: 12,
            color: colorScheme.onSurfaceVariant,
            spacing: 3,
          ),
        ),
        Gap(12.h),
        if (categories.isEmpty)
          const CategoryChipsSkeleton()
        else
          SizedBox(
            height: 90.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: categories.length,
              separatorBuilder: (_, _) => SizedBox(width: 16.w),
              itemBuilder: (context, index) {
                final cat = categories[index];
                return CategoryChipCard(
                  category: cat,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductListingPage(category: cat.name),
                      ),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
