import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/theme/app_text_styles.dart';
import 'package:max/core/utils/haptic_utils.dart';

void showGuestPromptDialog({
  required BuildContext context,
  String? message,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Sign in required',
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
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(10.h),
              Icon(
                Icons.person_outline,
                size: 48.w,
                color: colorScheme.onSurfaceVariant,
              ),
              Gap(16.h),
              Text(
                'Sign in required',
                style: TextStyle(
                  fontSize: AppTextStyles.fontSize18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
              Gap(8.h),
              Text(
                message ?? 'Please sign in to access this feature.',
                style: TextStyle(
                  fontSize: AppTextStyles.fontSize13,
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: AppConstants.fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(24.h),
              GestureDetector(
                onTap: () {
                  HapticUtils.light();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRouter.login);
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
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: AppTextStyles.fontSize14,
                        color: colorScheme.surface,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(10.h),
              GestureDetector(
                onTap: () {
                  HapticUtils.light();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRouter.signup);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: Center(
                    child: Text(
                      'CREATE ACCOUNT',
                      style: TextStyle(
                        fontSize: AppTextStyles.fontSize14,
                        color: colorScheme.onSurface,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(6.h),
              GestureDetector(
                onTap: () {
                  HapticUtils.light();
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: AppTextStyles.fontSize13,
                      color: colorScheme.onSurfaceVariant,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                ),
              ),
              Gap(4.h),
            ],
          ),
        ),
      );
    },
  );
}
