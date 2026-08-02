import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class WishlistSkeleton extends StatelessWidget {
  const WishlistSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ShimmerEffect(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  width: 90.w,
                  height: 110.h,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SkeletonBox(width: 120.w, height: 12.h),
                          SkeletonBox(
                            width: 18.w,
                            height: 18.w,
                            borderRadius: BorderRadius.circular(9.r),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      SkeletonBox(width: 80.w, height: 10.h),
                      SizedBox(height: 8.h),
                      SkeletonBox(width: 60.w, height: 14.h),
                      SizedBox(height: 10.h),
                      SkeletonBox(
                        width: 100.w,
                        height: 30.h,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
