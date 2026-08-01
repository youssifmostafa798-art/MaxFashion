import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_text.dart';
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
                child: CustemText(
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
                  child: CustemText(
                    text: 'DEFAULT',
                    size: 10,
                    color: colorScheme.surface,
                    spacing: 2,
                  ),
                ),
            ],
          ),
          Gap(10.h),
          CustemText(
            text: address.street,
            size: 14,
            weight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          if (address.apartment != null && address.apartment!.isNotEmpty) ...[
            Gap(2.h),
            CustemText(
              text: address.apartment!,
              size: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
          Gap(4.h),
          CustemText(
            text: '${address.city}, ${address.state} ${address.zip}',
            size: 13,
            color: colorScheme.onSurfaceVariant,
          ),
          CustemText(
            text: address.country,
            size: 13,
            color: colorScheme.onSurfaceVariant,
          ),
          Gap(12.h),
          Row(
            children: [
              _ActionChip(
                icon: Icons.edit_outlined,
                label: 'Edit',
                onTap: onEdit,
                colorScheme: colorScheme,
              ),
              Gap(8.w),
              _ActionChip(
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
              color: isDestructive ? Colors.red.shade300 : colorScheme.onSurface,
            ),
            Gap(4.w),
            CustemText(
              text: label,
              size: 12,
              color: isDestructive ? Colors.red.shade300 : colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
