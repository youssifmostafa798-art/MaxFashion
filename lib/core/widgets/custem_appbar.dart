import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:max/core/theme/app_colors.dart';

class CustemAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustemAppbar({super.key, required this.isBlackk});
  final bool isBlackk;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    bool isBlack = isBlackk;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: AppBar(
        centerTitle: true,
        leadingWidth: 30,
        backgroundColor: isBlack ? AppColors.primary : Colors.white,

        // ✅ Menu Button
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // افتحي Drawer أو Menu هنا
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                'assets/svgs/Menu.svg',
                width: 24,
                colorFilter: ColorFilter.mode(
                  isBlack ? Colors.white : AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),

        // ✅ Logo (مش زرار – زي ما هو)
        title: SvgPicture.asset(
          'assets/logo/logo-bg.svg',
          colorFilter: ColorFilter.mode(
            isBlack ? Colors.white : AppColors.primary,
            BlendMode.srcIn,
          ),
        ),

        actions: [
          // ✅ Search Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
          const Gap(20),

          // ✅ Cart Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
