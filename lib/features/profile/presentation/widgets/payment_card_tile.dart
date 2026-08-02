import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:max/core/widgets/custem_text.dart';
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

  String _getCardBrandIcon() {
    switch (card.cardBrand) {
      case 'visa':
        return 'assets/svgs/visa.svg';
      case 'mastercard':
        return 'assets/svgs/Mastercard.svg';
      default:
        return 'assets/svgs/Mastercard.svg';
    }
  }

  String _getCardBrandName() {
    switch (card.cardBrand) {
      case 'visa':
        return 'Visa';
      case 'mastercard':
        return 'Mastercard';
      default:
        return 'Card';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                child: CustemText(
                  text: _getCardBrandName().toUpperCase(),
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
                  child: CustemText(
                    text: 'DEFAULT',
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
                _getCardBrandIcon(),
                width: 40.w,
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustemText(
                      text: card.maskedNumber,
                      size: 14,
                      weight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    Gap(4.h),
                    CustemText(
                      text: card.cardHolderName,
                      size: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              CustemText(
                text: card.expiry,
                size: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              _ActionChip(
                icon: Icons.delete_outline,
                label: 'Delete',
                onTap: onDelete,
                colorScheme: colorScheme,
                isDestructive: true,
              ),
              const Spacer(),
              if (!card.isDefault)
                GestureDetector(
                  onTap: onSetDefault,
                  child: CustemText(
                    text: 'Set Default',
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

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.colorScheme,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14.w,
              color: isDestructive
                  ? Colors.red.shade300
                  : colorScheme.onSurface,
            ),
            Gap(4.w),
            CustemText(
              text: label,
              size: 12,
              color: isDestructive
                  ? Colors.red.shade300
                  : colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
