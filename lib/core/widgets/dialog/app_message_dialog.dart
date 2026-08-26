import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/core/theme/app_text_styles.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/widgets/dialog/app_dialog_type.dart';

IconData _defaultIconForType(AppDialogType type, ColorScheme colorScheme) {
  switch (type) {
    case AppDialogType.error:
      return Icons.error_outline_rounded;
    case AppDialogType.info:
      return Icons.info_outline_rounded;
    case AppDialogType.warning:
      return Icons.warning_amber_rounded;
    case AppDialogType.confirmation:
      return Icons.help_outline_rounded;
  }
}

Color _defaultIconColorForType(AppDialogType type, ColorScheme colorScheme) {
  switch (type) {
    case AppDialogType.error:
      return colorScheme.error;
    case AppDialogType.info:
      return colorScheme.onSurfaceVariant;
    case AppDialogType.warning:
      return Colors.orange;
    case AppDialogType.confirmation:
      return colorScheme.onSurface;
  }
}

class AppMessageDialog extends StatelessWidget {
  const AppMessageDialog({
    super.key,
    required this.title,
    required this.message,
    this.type = AppDialogType.error,
    this.icon,
    this.primaryActionLabel,
    this.onPrimaryAction,
  });

  final String title;
  final String message;
  final AppDialogType type;
  final IconData? icon;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    AppDialogType type = AppDialogType.error,
    IconData? icon,
    String? primaryActionLabel,
    VoidCallback? onPrimaryAction,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: title,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return AppMessageDialog(
          title: title,
          message: message,
          type: type,
          icon: icon,
          primaryActionLabel: primaryActionLabel,
          onPrimaryAction: onPrimaryAction,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final displayIcon = icon ?? _defaultIconForType(type, colorScheme);
    final iconColor = _defaultIconColorForType(type, colorScheme);
    final displayLabel = primaryActionLabel ?? l10n.gotIt;

    return Dialog(
      child: Container(
        color: colorScheme.surface,
        width: 280.w,
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(10.h),
            Icon(displayIcon, size: 48.w, color: iconColor),
            Gap(16.h),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: AppTextStyles.fontSize18,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                fontFamily: AppConstants.fontFamily,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(12.h),
            Text(
              message,
              style: TextStyle(
                fontSize: AppTextStyles.fontSize14,
                color: colorScheme.onSurfaceVariant,
                fontFamily: AppConstants.fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(20.h),
            Image.asset(
              AppConstants.lineImage,
              width: 150.w,
              height: 15.h,
              color: colorScheme.onSurface,
            ),
            Gap(20.h),
            GestureDetector(
              onTap: () {
                HapticUtils.light();
                Navigator.pop(context);
                onPrimaryAction?.call();
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    displayLabel.toUpperCase(),
                    style: TextStyle(
                      fontSize: AppTextStyles.fontSize14,
                      color: colorScheme.surface,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                ),
              ),
            ),
            Gap(6.h),
          ],
        ),
      ),
    );
  }
}
