import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/widgets/custom_button.dart';

void showValidationDialog({
  required BuildContext context,
  required String title,
  required String message,
}) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          height: 320.h,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(CupertinoIcons.clear),
                  ),
                ),
                Gap(20.h),
                CustomText(
                  text: title,
                  spacing: 2,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 19,
                ),
                Gap(30.h),
                Icon(
                  Icons.error_outline_rounded,
                  size: 60.w,
                  color: Theme.of(context).colorScheme.error,
                ),
                Gap(30.h),
                CustomText(
                  text: message,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap(20.h),
                Image.asset(
                  'assets/svgs/line.png',
                  width: 150.w,
                  height: 15.h,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const Spacer(),
                CustomButton(
                  isSvg: false,
                  title: "GOT IT",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
