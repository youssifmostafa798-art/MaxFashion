import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';

void showSuccessDialog({
  required BuildContext context,
  required String title,
  required String message,
  IconData icon = Icons.check_circle_rounded,
  Duration autoDismissDuration = const Duration(milliseconds: 1500),
  VoidCallback? onDismissed,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: title,
    transitionDuration: const Duration(milliseconds: 280),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1.0).animate(curvedAnimation),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return Dialog(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          width: 280.w,
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(16.h),
              Icon(
                icon,
                size: 48.w,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              Gap(16.h),
              CustomText(
                text: title.toUpperCase(),
                spacing: 2,
                color: Theme.of(context).colorScheme.onSurface,
                size: 17,
              ),
              Gap(16.h),
              CustomText(
                text: message,
                size: 15,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              Gap(24.h),
            ],
          ),
        ),
      );
    },
  );

  Future.delayed(autoDismissDuration, () {
    if (context.mounted) {
      Navigator.of(context).pop();
      onDismissed?.call();
    }
  });
}
