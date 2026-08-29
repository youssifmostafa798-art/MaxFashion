import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class CartSkeleton extends StatelessWidget {
  const CartSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
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
                          Expanded(
                            child: SkeletonBox(
                              width: 120.w,
                              height: 12.h,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          SkeletonCircle(size: 18.w),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      SkeletonBox(
                        width: 60.w,
                        height: 14.h,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          SkeletonCircle(size: 30.w),
                          SizedBox(width: 14.w),
                          SkeletonBox(
                            width: 16.w,
                            height: 14.h,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          SizedBox(width: 14.w),
                          SkeletonCircle(size: 30.w),
                        ],
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
