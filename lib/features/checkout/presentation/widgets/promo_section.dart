import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/widgets/custom_text.dart';

class PromoSection extends StatelessWidget {
  const PromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Gap(20.h),
        const Divider(),
        Gap(20.h),
        Row(
          children: [
            SvgPicture.asset(
              "assets/svgs/promo.svg",
              width: 28.w,
              colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
            ),
            Gap(20.w),
            CustomText(text: l10n.addPromoCode, color: colorScheme.onSurface),
          ],
        ),
        Gap(20.h),
        const Divider(),
        Gap(20.h),
        Row(
          children: [
            SvgPicture.asset(
              "assets/svgs/delivery.svg",
              width: 25.w,
              colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
            ),
            Gap(20.w),
            CustomText(text: l10n.delivery, color: colorScheme.onSurface),
            const Spacer(),
            CustomText(text: l10n.free.toUpperCase(), color: colorScheme.onSurface),
            Gap(5.w),
          ],
        ),
        Gap(10.h),
        const Divider(),
      ],
    );
  }
}
