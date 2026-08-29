import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class CategoryChipsSkeleton extends StatelessWidget {
  const CategoryChipsSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SizedBox(
        height: 90.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: itemCount,
          separatorBuilder: (_, _) => SizedBox(width: 16.w),
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonBox(
                  width: 56.w,
                  height: 56.w,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                SizedBox(height: 6.h),
                SkeletonBox(
                  width: 40.w,
                  height: 10.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
