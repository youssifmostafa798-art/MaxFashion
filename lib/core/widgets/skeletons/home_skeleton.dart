import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(
              width: double.infinity,
              height: 200.h,
              borderRadius: BorderRadius.circular(12.r),
            ),
            Gap(20.h),
            SizedBox(
              height: 40.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (_, _) => Gap(8.w),
                itemBuilder: (context, index) {
                  return SkeletonBox(
                    width: 80.w,
                    height: 40.h,
                    borderRadius: BorderRadius.circular(20.r),
                  );
                },
              ),
            ),
            Gap(16.h),
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
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
            Gap(20.h),
            Center(
              child: SkeletonBox(
                width: 200.w,
                height: 20.h,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Gap(10.h),
            Center(
              child: SkeletonBox(
                width: 190.w,
                height: 2.h,
              ),
            ),
            Gap(16.h),
            SizedBox(
              height: 270.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                separatorBuilder: (_, _) => Gap(12.w),
                itemBuilder: (context, index) {
                  return SkeletonBox(
                    width: 230.w,
                    height: 270.h,
                    borderRadius: BorderRadius.circular(12.r),
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
