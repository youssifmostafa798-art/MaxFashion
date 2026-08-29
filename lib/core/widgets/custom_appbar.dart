import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/features/search/presentation/pages/search_screen.dart';
import 'custom_text.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
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
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: null,
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
    final l10n = AppLocalizations.of(context)!;

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
              padding: EdgeInsetsDirectional.only(start: 14.w),
              child: Icon(
                Icons.search,
                color: colorScheme.onSurfaceVariant,
                size: 20.w,
              ),
            ),
            SizedBox(width: 10.w),
            CustomText(
              text: l10n.searchHint,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
