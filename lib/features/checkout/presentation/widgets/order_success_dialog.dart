import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/widgets/custom_button.dart';

enum OrderDialogResult { confirmed, cancelled }

Future<OrderDialogResult?> showOrderSuccessDialog({
  required BuildContext context,
  required String orderId,
}) {
  return showDialog<OrderDialogResult>(
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
                    onTap: () {
                      Navigator.pop(context, OrderDialogResult.cancelled);
                    },
                    child: const Icon(CupertinoIcons.clear),
                  ),
                ),
                Gap(20.h),
                CustomText(
                  text: "PAYMENT SUCCESS",
                  spacing: 2,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 19,
                ),
                Gap(40.h),
                SvgPicture.asset("assets/pop/done.svg"),
                Gap(40.h),
                CustomText(
                  text: "Your payment was success",
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap(10.h),
                CustomText(
                  text: "Payment ID $orderId",
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap(20.h),
                Image.asset(
                  'assets/svgs/line.png',
                  width: 150.w,
                  height: 15.h,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap(20.h),
                CustomText(
                  text: "Rate your purchase",
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap(20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/pop/emogi1.svg"),
                    Gap(20.w),
                    SvgPicture.asset("assets/pop/emogi2.svg"),
                    Gap(20.w),
                    SvgPicture.asset("assets/pop/emogi3.svg"),
                  ],
                ),

                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        isSvg: false,
                        title: "SUBMIT",
                        onTap: () {
                          Navigator.pop(context, OrderDialogResult.confirmed);
                        },
                      ),
                    ),
                    Gap(20.w),
                    Expanded(
                      child: CustomButton(
                        isSvg: false,
                        title: "CANCEL",
                        onTap: () {
                          Navigator.pop(context, OrderDialogResult.cancelled);
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
