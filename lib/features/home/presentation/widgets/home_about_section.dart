import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/haptic_utils.dart';

class HomeAboutSection extends StatelessWidget {
  const HomeAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => HapticUtils.light(),
              child: Icon(Ionicons.logo_twitter, color: colorScheme.onSurface),
            ),
            Gap(30.w),
            GestureDetector(
              onTap: () => HapticUtils.light(),
              child: Icon(Ionicons.logo_instagram, color: colorScheme.onSurface),
            ),
            Gap(30.w),
            GestureDetector(
              onTap: () => HapticUtils.light(),
              child: Icon(Ionicons.logo_facebook, color: colorScheme.onSurface),
            ),
          ],
        ),
        Gap(20.h),
        Image.asset("assets/svgs/line.png", width: 190.w),
        Gap(20.h),
        CustomText(
          height: 2.5,
          text:
              "youssifmostafa798@gmail.com \n       +201553178468\n17:00 - 22:00 - Everyday",
        ),
        Gap(20.h),
        Image.asset("assets/svgs/line.png", width: 190.w),
        Gap(20.h),
        CustomText(height: 2.5, text: "About   Contact    Blog"),
      ],
    );
  }
}
