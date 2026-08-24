import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/features/checkout/presentation/widgets/favorite_button.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/features/search/presentation/widgets/highlighted_text.dart';
import 'package:max/core/l10n/app_localizations.dart';

class SearchResultsList extends ConsumerWidget {
  const SearchResultsList({
    super.key,
    required this.products,
    required this.query,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.onProductSelected,
  });

  final List<ProductModel> products;
  final String query;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final ValueChanged<ProductModel> onProductSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (products.isEmpty) {
      return _EmptyState(query: query);
    }

    final categories = ref.watch(categoriesProvider);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: products.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == products.length) {
          return _LoadMoreIndicator(
            isLoading: isLoadingMore,
            onLoadMore: onLoadMore,
          );
        }

        final product = products[index];
        return _SearchResultCard(
          product: product,
          query: query,
          categoryName: categoryNameById(categories, product.categoryId),
          onTap: () => onProductSelected(product),
        );
      },
    );
  }
}

class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator({required this.isLoading, required this.onLoadMore});

  final bool isLoading;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Center(
        child: TextButton(
          onPressed: onLoadMore,
          child: Text(l10n.loadMoreResults),
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    required this.product,
    required this.query,
    required this.categoryName,
    required this.onTap,
  });
  final ProductModel product;
  final String query;
  final String categoryName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Row(
          children: [
            Hero(
              tag: 'product-image-${product.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  product.image,
                  width: 80.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80.w,
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
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HighlightedText(
                    text: product.name.replaceAll('\n', ' '),
                    query: query,
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                  Gap(4.h),
                  CustomText(
                    text: categoryName,
                    size: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  Gap(4.h),
                  CustomText(
                    text: l10n.priceValue(product.price.toStringAsFixed(2)),
                    size: 15,
                    weight: FontWeight.w600,
                    color: const Color(0xffDD8560),
                  ),
                ],
              ),
            ),
            FavoriteButton(product: product, size: 22),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                Icons.search_off_rounded,
                size: 48.w,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Gap(24.h),
            CustomText(
              text: l10n.noResultsFound,
              size: 18,
              color: colorScheme.onSurface,
              weight: FontWeight.w600,
              spacing: 2,
            ),
            Gap(8.h),
            CustomText(
              text: l10n.tryAnotherKeyword,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
