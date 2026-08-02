import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class ProductDetailSkeleton extends StatelessWidget {
  const ProductDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SkeletonBox(
                    width: 28.w,
                    height: 28.w,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(
                    width: 120.w,
                    height: 150.h,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(8.h),
                        SkeletonBox(width: 150.w, height: 14.h),
                        Gap(10.h),
                        SkeletonBox(width: 200.w, height: 12.h),
                        Gap(15.h),
                        SkeletonBox(width: 80.w, height: 16.h),
                        Gap(20.h),
                        Row(
                          children: [
                            SkeletonBox(
                              width: 28.w,
                              height: 28.w,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            Gap(15.w),
                            SkeletonBox(width: 20.w, height: 14.h),
                            Gap(15.w),
                            SkeletonBox(
                              width: 28.w,
                              height: 28.w,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(20.h),
              SkeletonBox(
                width: double.infinity,
                height: 1,
              ),
              Gap(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonBox(width: 80.w, height: 14.h),
                  SkeletonBox(width: 60.w, height: 16.h),
                ],
              ),
              Gap(15.h),
              SkeletonBox(
                width: double.infinity,
                height: 50.h,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
