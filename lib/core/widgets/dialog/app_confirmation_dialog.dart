import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/core/theme/app_text_styles.dart';
import 'package:max/core/utils/haptic_utils.dart';

class AppConfirmationDialog extends StatelessWidget {
  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.confirmLabel = 'CONFIRM',
    this.cancelLabel = 'CANCEL',
    this.isDestructive = false,
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String message;
  final IconData? icon;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    String confirmLabel = 'CONFIRM',
    String cancelLabel = 'CANCEL',
    bool isDestructive = false,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<bool>(
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
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return AppConfirmationDialog(
          title: title,
          message: message,
          icon: icon,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          isDestructive: isDestructive,
          onConfirm: () => Navigator.pop(context, true),
          onCancel: () => Navigator.pop(context, false),
        );
      },
    ).then((result) => result ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      child: Container(
        color: colorScheme.surface,
        width: 280.w,
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(10.h),
            if (icon != null) ...[
              Icon(
                icon,
                size: 48.w,
                color: isDestructive ? Colors.red.shade300 : colorScheme.onSurface,
              ),
              Gap(16.h),
            ],
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: AppTextStyles.fontSize18,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                fontFamily: AppConstants.fontFamily,
                letterSpacing: 2,
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
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticUtils.light();
                      onCancel?.call();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          cancelLabel.toUpperCase(),
                          style: TextStyle(
                            fontSize: AppTextStyles.fontSize14,
                            color: colorScheme.onSurface,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticUtils.medium();
                      onConfirm?.call();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: isDestructive
                            ? Colors.red.shade300
                            : colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          confirmLabel.toUpperCase(),
                          style: TextStyle(
                            fontSize: AppTextStyles.fontSize14,
                            color: isDestructive ? Colors.white : colorScheme.surface,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(6.h),
          ],
        ),
      ),
    );
  }
}
