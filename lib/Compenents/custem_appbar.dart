import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:max/core/colors.dart';

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
                color: isBlack ? Colors.white : AppColors.primary,
              ),
            ),
          ),
        ),

        // ✅ Logo (مش زرار – زي ما هو)
        title: SvgPicture.asset(
          'assets/logo/logo-bg.svg',
          color: isBlack ? Colors.white : AppColors.primary,
        ),

        actions: [
          // ✅ Search Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                print("Search clicked");
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/svgs/Search.svg',
                  color: isBlack ? Colors.white : AppColors.primary,
                ),
              ),
            ),
          ),
          const Gap(20),

          // ✅ Cart Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                print("Cart clicked");
                // Navigator.push to Cart page
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/svgs/shopping bag.svg',
                  color: isBlack ? Colors.white : AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
