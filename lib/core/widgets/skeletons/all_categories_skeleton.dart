import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class AllCategoriesSkeleton extends StatelessWidget {
  const AllCategoriesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: SkeletonText(
              width: 80.w,
              height: 12.h,
            ),
          ),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 12,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SkeletonCircle(size: 64.w),
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
        ],
      ),
    );
  }
}
