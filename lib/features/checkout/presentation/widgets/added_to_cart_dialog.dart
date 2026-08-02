import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/core/widgets/custem_bottom.dart';
import 'package:max/core/router/app_router.dart';

void showAddedToCartDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
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
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ),
                Gap(20.h),
                CustemText(
                  text: "ADDED TO CART",
                  spacing: 2,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 19,
                ),
                Gap(40.h),
                SvgPicture.asset("assets/pop/done.svg"),
                Gap(40.h),
                CustemText(
                  text: "Item added to your\ncart successfully",
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap(20.h),
                CustemText(
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
                CustemText(
                  text: "Ready to checkout?",
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Button(
                        isSvgg: false,
                        title: "View\nCart",
                        onTap: () {
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
                      child: Button(
                        isSvgg: false,
                        title: "Shop\nMore",
                        onTap: () {
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
