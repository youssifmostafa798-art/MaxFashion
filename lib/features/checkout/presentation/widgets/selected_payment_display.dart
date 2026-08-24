import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/card_utils.dart';

class SelectedPaymentDisplay extends StatelessWidget {
  const SelectedPaymentDisplay({
    super.key,
    required this.savedCard,
    required this.selectedCardBrand,
  });

  final Map<String, dynamic> savedCard;
  final String selectedCardBrand;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        const Divider(),
        Gap(10.h),
        Row(
          children: [
            SvgPicture.asset(
              CardUtils.getCardBrandIcon(selectedCardBrand),
              width: 40.w,
            ),
            Gap(10.w),
            Expanded(
              child: Builder(
                builder: (context) {
                  final numStr = savedCard['number'].toString();
                  final suffix = numStr.length >= 2
                      ? numStr.substring(numStr.length - 2)
                      : numStr;
                  final brandName = CardUtils.getCardBrandName(
                    selectedCardBrand,
                  );
                  return CustomText(
                    text: l10n.cardEnding(brandName, suffix),
                    color: Theme.of(context).colorScheme.onSurface,
                  );
                },
              ),
            ),
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_back_ios_outlined
                  : Icons.arrow_forward_ios_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
        Gap(10.h),
        const Divider(),
      ],
    );
  }
}
