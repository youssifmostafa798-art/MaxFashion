import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class SearchSkeleton extends StatelessWidget {
  const SearchSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ShimmerEffect(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Row(
              children: [
                SkeletonBox(
                  width: 80.w,
                  height: 100.h,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 120.w, height: 14.h),
                      SizedBox(height: 4.h),
                      SkeletonBox(width: 60.w, height: 10.h),
                      SizedBox(height: 4.h),
                      SkeletonBox(width: 50.w, height: 14.h),
                    ],
                  ),
                ),
                SkeletonBox(
                  width: 22.w,
                  height: 22.w,
                  borderRadius: BorderRadius.circular(11.r),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
