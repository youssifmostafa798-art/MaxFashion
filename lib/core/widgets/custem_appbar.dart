import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/features/search/presentation/pages/search_screen.dart';
import 'custem_text.dart';

class CustemAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustemAppbar({
    super.key,
    this.showBackButton = true,
    this.showSearchBar = false,
  });
  final bool showBackButton;
  final bool showSearchBar;

  double get _height => showSearchBar ? 120.h : 60.h;

  @override
  Size get preferredSize => Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    final bool canPop = showBackButton && Navigator.canPop(context);
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      toolbarHeight: _height,
      backgroundColor: colorScheme.surfaceContainerHigh,
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
                        color: colorScheme.onSurface,
                        size: 24.w,
                      ),
                    ),
                  ),
                const Spacer(),
                SvgPicture.asset(
                  'assets/logo/logo-bg.svg',
                  colorFilter: ColorFilter.mode(
                    colorScheme.onSurface,
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
              child: _SearchBar(),
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        );
      },
      child: Container(
        height: 48.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 14.w),
              child: Icon(Icons.search, color: colorScheme.onSurfaceVariant, size: 20.w),
            ),
            SizedBox(width: 10.w),
            CustemText(
              text: 'Search....',
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
