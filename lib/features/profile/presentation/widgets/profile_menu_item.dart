import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/custom_text.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.isDestructive = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? trailing;
  final bool isDestructive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color iconColor =
        isDestructive ? AppColors.accent : colorScheme.onSurface;
    final Color textColor =
        isDestructive ? AppColors.accent : colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDestructive ? AppColors.accent.withValues(alpha: 0.2) : colorScheme.outline,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22.w),
            SizedBox(width: 14.w),
            Expanded(
              child: CustomText(
                text: title,
                size: 14,
                color: textColor,
              ),
            ),
            if (trailing != null)
              CustomText(
                text: trailing!,
                size: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            SizedBox(width: 4.w),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
