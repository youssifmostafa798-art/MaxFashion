import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class ProductListingSkeleton extends StatelessWidget {
  const ProductListingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: SkeletonBox(width: 60.w, height: 12.h),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 15.w,
                childAspectRatio: 0.50,
              ),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 0.70,
                      child: SkeletonBox(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    Gap(8.h),
                    SkeletonBox(
                      width: double.infinity,
                      height: 14.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    SizedBox(height: 4.h),
                    SkeletonBox(
                      width: 80.w,
                      height: 12.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    Gap(8.h),
                    SkeletonBox(
                      width: 60.w,
                      height: 16.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
