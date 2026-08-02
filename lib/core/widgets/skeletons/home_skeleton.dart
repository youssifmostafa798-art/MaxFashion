import 'package:flutter/material.dart';
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
                    _buildProductGridSkeleton(colorScheme),
                    SizedBox(height: 20.h),
                    Center(
                      child: SkeletonBox(
                        width: 190.w,
                        height: 14.h,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      height: 350.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(8.0.w),
                            child: SkeletonBox(
                              width: 180.w,
                              height: 350.h,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          );
                        },
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

  Widget _buildProductGridSkeleton(ColorScheme colorScheme) {
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
    );
  }
}
