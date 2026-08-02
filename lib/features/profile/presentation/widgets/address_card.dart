import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/action_chip_widget.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/address_model.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: address.isDefault
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
                  color: address.isDefault
                      ? colorScheme.onSurface
                      : colorScheme.outline,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  text: address.label.toUpperCase(),
                  size: 10,
                  color: address.isDefault
                      ? colorScheme.surface
                      : colorScheme.onSurface,
                  spacing: 2,
                ),
              ),
              Gap(8.w),
              if (address.isDefault)
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
                    text: 'DEFAULT',
                    size: 10,
                    color: colorScheme.surface,
                    spacing: 2,
                  ),
                ),
            ],
          ),
          Gap(10.h),
          CustomText(
            text: address.street,
            size: 14,
            weight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          if (address.apartment != null && address.apartment!.isNotEmpty) ...[
            Gap(2.h),
            CustomText(
              text: address.apartment!,
              size: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
          Gap(4.h),
          CustomText(
            text: '${address.city}, ${address.state} ${address.zip}',
            size: 13,
            color: colorScheme.onSurfaceVariant,
          ),
          CustomText(
            text: address.country,
            size: 13,
            color: colorScheme.onSurfaceVariant,
          ),
          Gap(12.h),
          Row(
            children: [
              ActionChipWidget(
                icon: Icons.edit_outlined,
                label: 'Edit',
                onTap: onEdit,
                colorScheme: colorScheme,
              ),
              Gap(8.w),
              ActionChipWidget(
                icon: Icons.delete_outline,
                label: 'Delete',
                onTap: onDelete,
                colorScheme: colorScheme,
                isDestructive: true,
              ),
              const Spacer(),
              if (!address.isDefault)
                GestureDetector(
                  onTap: onSetDefault,
                  child: CustomText(
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
