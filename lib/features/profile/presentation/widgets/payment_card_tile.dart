import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/card_utils.dart';
import 'package:max/core/widgets/action_chip_widget.dart';
import 'package:max/data/models/payment_card_model.dart';

class PaymentCardTile extends StatelessWidget {
  const PaymentCardTile({
    super.key,
    required this.card,
    required this.onDelete,
    required this.onSetDefault,
  });

  final PaymentCardModel card;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: card.isDefault
            ? Border.all(color: colorScheme.onSurface, width: 1.5.w)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: card.isDefault
                      ? colorScheme.onSurface
                      : colorScheme.outline,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  text: CardUtils.getCardBrandName(card.cardBrand).toUpperCase(),
                  size: 10,
                  color: card.isDefault
                      ? colorScheme.surface
                      : colorScheme.onSurface,
                  spacing: 2,
                ),
              ),
              Gap(8.w),
              if (card.isDefault)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText(
                    text: l10n.defaultBadge,
                    size: 10,
                    color: colorScheme.surface,
                    spacing: 2,
                  ),
                ),
            ],
          ),
          Gap(12.h),
          Row(
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
                      weight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    Gap(4.h),
                    CustomText(
                      text: card.cardHolderName,
                      size: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              CustomText(
                text: card.expiry,
                size: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              ActionChipWidget(
                icon: Icons.delete_outline,
                label: l10n.deleteLabel,
                onTap: onDelete,
                colorScheme: colorScheme,
                isDestructive: true,
              ),
              const Spacer(),
              if (!card.isDefault)
                GestureDetector(
                  onTap: onSetDefault,
                  child: CustomText(
                    text: l10n.setDefaultLabel,
                    size: 12,
                    color: colorScheme.onSurface,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
