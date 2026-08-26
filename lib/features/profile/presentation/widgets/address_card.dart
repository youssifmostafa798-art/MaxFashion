import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/constants/app_constants.dart';
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

  /// Maps address labels to their localized display form.
  /// Handles canonical domain values, legacy English values, and
  /// legacy localized values stored before the domain/presentation fix.
  String _displayLabel(AppLocalizations l10n, String label) {
    final lower = label.toLowerCase();
    if (lower == AppConstants.addressLabelHome.toLowerCase() ||
        lower == '\u0627\u0644\u0645\u0646\u0632\u0644') {
      return l10n.homeLabel.toUpperCase();
    }
    if (lower == AppConstants.addressLabelWork.toLowerCase() ||
        lower == '\u0627\u0644\u0639\u0645\u0644') {
      return l10n.workLabel.toUpperCase();
    }
    if (lower == AppConstants.addressLabelOther.toLowerCase() ||
        lower == '\u0623\u062e\u0631\u0649') {
      return l10n.otherLabel.toUpperCase();
    }
    return label.toUpperCase();
  }

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
                  text: _displayLabel(l10n, address.label),
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
                    text: l10n.defaultBadge,
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
                label: l10n.editButton,
                onTap: onEdit,
                colorScheme: colorScheme,
              ),
              Gap(8.w),
              ActionChipWidget(
                icon: Icons.delete_outline,
                label: l10n.deleteLabel,
                onTap: onDelete,
                colorScheme: colorScheme,
                isDestructive: true,
              ),
              const Spacer(),
              if (!address.isDefault)
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
