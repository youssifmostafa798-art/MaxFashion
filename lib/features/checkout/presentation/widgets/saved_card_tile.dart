import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/card_utils.dart';
import 'package:max/data/models/payment_card_model.dart';

class SavedCardTile extends StatelessWidget {
  const SavedCardTile({
    super.key,
    required this.card,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentCardModel card;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14.r),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 1.5.w,
                )
              : null,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              CardUtils.getCardBrandIcon(card.cardBrand),
              width: 40.w,
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: card.maskedNumber,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  Gap(2.h),
                  CustomText(
                    text: l10n.expiresLabel(card.expiry),
                    size: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            if (card.isDefault)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CustomText(
                  text: l10n.defaultBadge,
                  size: 9,
                  color: Theme.of(context).colorScheme.surface,
                  spacing: 1,
                ),
              ),
            if (isSelected)
              Padding(
                padding: EdgeInsetsDirectional.only(start: 8.w),
                child: Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20.w,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
