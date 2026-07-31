import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/features/search/presentation/pages/search_screen.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/search_provider.dart';

class SearchTapWidget extends StatelessWidget {
  const SearchTapWidget({
    super.key,
    this.backgroundColor,
    this.hintText,
    this.source,
    this.searchContext,
    this.borderRadius,
  });

  final Color? backgroundColor;
  final String? hintText;
  final List<ProductModel>? source;
  final SearchContextType? searchContext;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchScreen(
              initialSource: source,
              searchContext: searchContext,
            ),
          ),
        );
      },
      child: Container(
        height: 48.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.grey100,
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 14.w),
              child: Icon(Icons.search, color: AppColors.grey500, size: 20.w),
            ),
            SizedBox(width: 10.w),
            Text(
              hintText ?? 'Search....',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey400,
                fontFamily: 'Tenor_Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
