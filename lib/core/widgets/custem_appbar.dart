import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'custem_text.dart';

class CustemAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustemAppbar({
    super.key,
    required this.isBlackk,
    this.showBackButton = true,
    this.showSearchBar = false,
  });
  final bool isBlackk;
  final bool showBackButton;
  final bool showSearchBar;

  double get _height => showSearchBar ? 120.h : 60.h;

  @override
  Size get preferredSize => Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    bool isBlack = isBlackk;
    final bool canPop = showBackButton && Navigator.canPop(context);

    return AppBar(
      toolbarHeight: _height,
      backgroundColor: isBlack ? AppColors.primary : Colors.white,
      automaticallyImplyLeading: false,
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40.h,
            child: Row(
              children: [
                if (canPop)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.arrow_back,
                        color: isBlack ? Colors.white : Colors.black,
                        size: 24.w,
                      ),
                    ),
                  ),
                const Spacer(),
                SvgPicture.asset(
                  'assets/logo/logo-bg.svg',
                  colorFilter: ColorFilter.mode(
                    isBlack ? Colors.white : AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const Spacer(),
                if (canPop) SizedBox(width: 40.w),
              ],
            ),
          ),
          if (showSearchBar) ...[
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildSearchBar(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 14.w),
            child: Icon(Icons.search, color: AppColors.grey500, size: 20.w),
          ),
          SizedBox(width: 10.w),
          CustemText(text: 'Search....', size: 14, color: AppColors.grey400),
        ],
      ),
    );
  }
}
