import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_button.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/l10n/app_localizations.dart';

class EmptyPaymentMethods extends StatelessWidget {
  const EmptyPaymentMethods({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\ud83d\udcb3',
              style: TextStyle(fontSize: 64.w),
            ),
            Gap(24.h),
            CustomText(
              text: l10n.noSavedCards,
              size: 18,
              weight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
            Gap(10.h),
            CustomText(
              text: l10n.addFirstPaymentMethod,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            Gap(40.h),
            CustomButton(
              isSvg: false,
              title: l10n.addCardButton,
              onTap: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}
