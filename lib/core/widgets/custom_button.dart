import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.isSvg,
    required this.title,
    required this.onTap,
  });
  final bool isSvg;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: colorScheme.onSurface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSvg)
                SvgPicture.asset(
                  "assets/svgs/shopping bag.svg",
                  width: 20.w,
                  colorFilter: ColorFilter.mode(
                    colorScheme.surface,
                    BlendMode.srcIn,
                  ),
                ),
              Gap(10.w),
              CustomText(text: title.toUpperCase(), size: 15, color: colorScheme.surface),
            ],
          ),
        ),
      ),
    );
  }
}
