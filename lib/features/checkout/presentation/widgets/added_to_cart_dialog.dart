import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/widgets/custom_button.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/utils/haptic_utils.dart';

void showAddedToCartDialog(BuildContext context) {
  HapticUtils.medium();
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Added to Cart',
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1.0).animate(curvedAnimation),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return Dialog(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          height: 520.h,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      HapticUtils.light();
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close),
                  ),
                ),
                Gap(20.h),
                CustomText(
                  text: "ADDED TO CART",
                  spacing: 2,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 19,
                ),
                Gap(40.h),
                SvgPicture.asset("assets/pop/done.svg"),
                Gap(40.h),
                CustomText(
                  text: "Item added to your\ncart successfully",
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap(20.h),
                CustomText(
                  text: "You can review your cart \nor continue shopping.",
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap(40.h),
                Image.asset(
                  'assets/svgs/line.png',
                  width: 150.w,
                  height: 15.h,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap(40.h),
                CustomText(
                  text: "Ready to checkout?",
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        isSvg: false,
                        title: "View\nCart",
                        onTap: () {
                          HapticUtils.light();
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(
                            context,
                            AppRouter.main,
                            arguments: 2,
                          );
                        },
                      ),
                    ),
                    Gap(20.w),
                    Expanded(
                      child: CustomButton(
                        isSvg: false,
                        title: "Shop\nMore",
                        onTap: () {
                          HapticUtils.light();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
