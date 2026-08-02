import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class ProductListingSkeleton extends StatelessWidget {
  const ProductListingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ShimmerEffect(
      child: Container(
        color: colorScheme.surface,
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
                      SkeletonBox(
                        width: double.infinity,
                        height: 200.h,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      SizedBox(height: 10.h),
                      SkeletonBox(width: 100.w, height: 12.h),
                      SizedBox(height: 6.h),
                      SkeletonBox(width: 80.w, height: 10.h),
                      SizedBox(height: 9.h),
                      SkeletonBox(width: 60.w, height: 14.h),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
