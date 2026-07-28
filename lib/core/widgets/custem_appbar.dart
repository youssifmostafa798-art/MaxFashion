import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';

class CustemAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustemAppbar({super.key, required this.isBlackk});
  final bool isBlackk;

  @override
  Size get preferredSize => Size.fromHeight(70.h);

  @override
  Widget build(BuildContext context) {
    bool isBlack = isBlackk;

    return Padding(
      padding: EdgeInsets.all(8.w),
      child: AppBar(
        centerTitle: true,
        leadingWidth: 30.w,
        backgroundColor: isBlack ? AppColors.primary : Colors.white,

        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(8.0.w),
              child: SvgPicture.asset(
                'assets/svgs/Menu.svg',
                width: 24.w,
                colorFilter: ColorFilter.mode(
                  isBlack ? Colors.white : AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),

        title: SvgPicture.asset(
          'assets/logo/logo-bg.svg',
          colorFilter: ColorFilter.mode(
            isBlack ? Colors.white : AppColors.primary,
            BlendMode.srcIn,
          ),
        ),

        actions: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.all(8.0.w),
                child: SvgPicture.asset(
                  'assets/svgs/Search.svg',
                  colorFilter: ColorFilter.mode(
                    isBlack ? Colors.white : AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          Gap(20.w),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.all(8.0.w),
                child: SvgPicture.asset(
                  'assets/svgs/shopping bag.svg',
                  colorFilter: ColorFilter.mode(
                    isBlack ? Colors.white : AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
