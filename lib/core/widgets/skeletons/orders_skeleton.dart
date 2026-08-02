import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class OrdersSkeleton extends StatelessWidget {
  const OrdersSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ShimmerEffect(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonBox(width: 100.w, height: 14.h),
                          SizedBox(height: 4.h),
                          SkeletonBox(width: 80.w, height: 10.h),
                        ],
                      ),
                    ),
                    SkeletonBox(
                      width: 70.w,
                      height: 24.h,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                SkeletonBox(width: double.infinity, height: 1),
                SizedBox(height: 14.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: 50.w, height: 12.h),
                        SizedBox(height: 2.h),
                        SkeletonBox(width: 60.w, height: 16.h),
                      ],
                    ),
                    SkeletonBox(
                      width: 100.w,
                      height: 32.h,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
