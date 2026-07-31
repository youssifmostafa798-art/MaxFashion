import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_text.dart';


class Header extends StatelessWidget {
  const Header({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Gap(20.h),
        Center(
          child: CustemText(
            text: title.toUpperCase(),
            color: colorScheme.onSurface,
            size: 18,
            spacing: 7,
          ),
        ),
        Gap(10.h),
        Image.asset(
          'assets/svgs/line.png',
          width: 150.w,
          height: 15.h,
          color: colorScheme.onSurface,
        ),
        Gap(20.h),
      ],
    );
  }
}
