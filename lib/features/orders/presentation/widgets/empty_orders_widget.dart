import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/features/main/presentation/pages/main_screen.dart';

class EmptyOrdersWidget extends StatelessWidget {
  const EmptyOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80.w,
              color: colorScheme.outline,
            ),
            SizedBox(height: 24.h),
            CustomText(
              text: l10n.noOrdersYet,
              size: 18,
              weight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            SizedBox(height: 10.h),
            CustomText(
              text: l10n.purchasesWillAppear,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 32.h),
            GestureDetector(
              onTap: () {
                HapticUtils.light();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MainScreen(initialTab: 0)),
                  (route) => false,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CustomText(
                  text: l10n.continueShopping,
                  size: 14,
                  color: colorScheme.surface,
                  spacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
