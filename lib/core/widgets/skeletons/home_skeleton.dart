import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ShimmerEffect(
      child: Container(
        color: colorScheme.surface,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                child: Column(
                  children: [
                    SkeletonBox(
                      width: double.infinity,
                      height: 200.h,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 40.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        separatorBuilder: (_, _) => Gap(8.w),
                        itemBuilder: (context, index) {
                          return SkeletonBox(
                            width: 70.w,
                            height: 40.h,
                            borderRadius: BorderRadius.circular(20.r),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildProductGridSkeleton(),
                    SizedBox(height: 5.h),
                    Center(
                      child: SkeletonBox(
                        width: 140.w,
                        height: 14.h,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Center(
                      child: SkeletonBox(
                        width: 190.w,
                        height: 2.h,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SkeletonBox(
                          width: 24.w,
                          height: 24.w,
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        SizedBox(width: 30.w),
                        SkeletonBox(
                          width: 24.w,
                          height: 24.w,
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        SizedBox(width: 30.w),
                        SkeletonBox(
                          width: 24.w,
                          height: 24.w,
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: SkeletonBox(
                        width: 190.w,
                        height: 2.h,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: SkeletonBox(
                        width: 200.w,
                        height: 14.h,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: SkeletonBox(
                        width: 190.w,
                        height: 2.h,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: SkeletonBox(
                        width: 220.w,
                        height: 14.h,
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductGridSkeleton() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
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
            SizedBox(height: 10.h),
            SkeletonBox(width: double.infinity, height: 12.h),
            SizedBox(height: 6.h),
            SkeletonBox(width: 80.w, height: 10.h),
            SizedBox(height: 9.h),
            SkeletonBox(width: 60.w, height: 14.h),
          ],
        );
      },
    );
  }
}
