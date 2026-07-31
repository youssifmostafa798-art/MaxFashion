import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/features/search/presentation/widgets/highlighted_text.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({
    super.key,
    required this.products,
    required this.query,
    required this.onProductSelected,
  });

  final List<ProductModel> products;
  final String query;
  final ValueChanged<ProductModel> onProductSelected;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return _EmptyState(query: query);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _SearchResultCard(
          product: product, 
          query: query,
          onTap: () => onProductSelected(product),
        );
      },
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    required this.product, 
    required this.query,
    required this.onTap,
  });
  final ProductModel product;
  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                product.image,
                width: 80.w,
                height: 100.h,
                fit: BoxFit.cover,
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
                    color: AppColors.primary,
                    weight: FontWeight.w600,
                  ),
                  Gap(4.h),
                  CustemText(
                    text: product.category,
                    size: 12,
                    color: AppColors.grey500,
                  ),
                  Gap(4.h),
                  CustemText(
                    text: '\$${product.price.toStringAsFixed(2)}',
                    size: 15,
                    weight: FontWeight.w600,
                    color: const Color(0xffDD8560),
                  ),
                ],
              ),
            ),
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
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: const BoxDecoration(
                color: AppColors.grey100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 48.w,
                color: AppColors.grey400,
              ),
            ),
            Gap(24.h),
            CustemText(
              text: 'No Results Found',
              size: 18,
              color: AppColors.primary,
              weight: FontWeight.w600,
              spacing: 2,
            ),
            Gap(8.h),
            CustemText(
              text: 'Try another keyword',
              size: 14,
              color: AppColors.grey500,
            ),
          ],
        ),
      ),
    );
  }
}
