import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/l10n/app_localizations.dart';

class GuestOrdersView extends StatelessWidget {
  const GuestOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80.w,
            color: colorScheme.outline,
          ),
          SizedBox(height: 20.h),
          CustomText(
            text: l10n.signInToViewOrders,
            size: 18,
            color: colorScheme.onSurface,
            weight: FontWeight.w600,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: l10n.trackPurchases,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 30.h),
          GestureDetector(
            onTap: () {
              HapticUtils.light();
              Navigator.pushNamed(context, AppRouter.login);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: CustomText(
                text: l10n.signIn,
                size: 14,
                color: colorScheme.surface,
                spacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
