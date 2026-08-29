import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class PaymentMethodsSkeleton extends StatelessWidget {
  const PaymentMethodsSkeleton({super.key, this.itemCount = 2});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            child: SkeletonText(
              width: 140.w,
              height: 14.h,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              separatorBuilder: (_, _) => Gap(14.h),
              itemBuilder: (context, index) {
                return _buildPaymentCardSkeleton(context);
              },
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 15.w, end: 15.w, bottom: 30.h),
            child: SkeletonButton(
              height: 50.h,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCardSkeleton(BuildContext context) {
    return SkeletonCard(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(
                width: 60.w,
                height: 22.h,
                borderRadius: BorderRadius.circular(20.r),
              ),
              SizedBox(width: 8.w),
              SkeletonBox(
                width: 60.w,
                height: 22.h,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              SkeletonBox(
                width: 40.w,
                height: 28.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText(
                      width: 120.w,
                      height: 14.h,
                    ),
                    Gap(4.h),
                    SkeletonText(
                      width: 100.w,
                      height: 12.h,
                    ),
                  ],
                ),
              ),
              SkeletonText(
                width: 50.w,
                height: 12.h,
              ),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              SkeletonBox(
                width: 60.w,
                height: 28.h,
                borderRadius: BorderRadius.circular(8.r),
              ),
              const Spacer(),
              SkeletonText(
                width: 70.w,
                height: 12.h,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
