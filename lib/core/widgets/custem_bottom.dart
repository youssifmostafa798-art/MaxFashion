import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/core/theme/app_colors.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.isSvgg,
    required this.title,
    required this.onTap,
  });
  final bool isSvgg;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    bool isSvg = isSvgg;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isSvg
                  ? SvgPicture.asset("assets/svgs/shopping bag.svg", width: 20.w)
                  : SizedBox.shrink(),
              Gap(10.w),
              CustemText(text: title.toUpperCase(), size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
