import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class CollectionsCarouselSkeleton extends StatelessWidget {
  const CollectionsCarouselSkeleton({super.key});

  static const int _skeletonCardCount = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(16.h),
        Center(
          child: ShimmerEffect(
            child: SkeletonBox(
              width: 200.w,
              height: 20.h,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Gap(10.h),
        Image.asset("assets/svgs/line.png", width: 190.w),
        Gap(16.h),
        SizedBox(
          height: AppConstants.collectionCarouselHeight.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            itemCount: _skeletonCardCount,
            separatorBuilder: (_, _) => Gap(12.w),
            itemBuilder: (context, index) {
              return ShimmerEffect(
                child: Container(
                  width: AppConstants.collectionCardWidth.w,
                  height: AppConstants.collectionCardHeight.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(
                      AppConstants.collectionCardBorderRadius.r,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                            AppConstants.collectionCardBorderRadius.r,
                          ),
                        ),
                        child: SkeletonBox(
                          width: double.infinity,
                          height: AppConstants.collectionImageHeight.h,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: SkeletonBox(
                              width: 100.w,
                              height: 12.h,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
