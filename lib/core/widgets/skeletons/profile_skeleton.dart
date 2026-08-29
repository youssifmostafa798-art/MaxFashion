import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  SkeletonCircle(size: 80.w),
                  Gap(14.h),
                  SkeletonText(
                    width: 120.w,
                    height: 18.h,
                  ),
                  Gap(6.h),
                  SkeletonText(
                    width: 100.w,
                    height: 12.h,
                  ),
                  Gap(6.h),
                  SkeletonText(
                    width: 90.w,
                    height: 10.h,
                  ),
                ],
              ),
            ),
            Gap(24.h),
            SkeletonText(
              width: 80.w,
              height: 10.h,
            ),
            Gap(16.h),
            ...List.generate(6, (_) => _buildMenuItemSkeleton(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemSkeleton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          SkeletonBox(
            width: 24.w,
            height: 24.w,
            borderRadius: BorderRadius.circular(6.r),
          ),
          SizedBox(width: 14.w),
          SkeletonText(
            width: 120.w,
            height: 14.h,
          ),
          const Spacer(),
          SkeletonText(
            width: 24.w,
            height: 12.h,
          ),
        ],
      ),
    );
  }
}
