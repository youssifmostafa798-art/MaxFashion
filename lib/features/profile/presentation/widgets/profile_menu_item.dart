import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/custem_text.dart';

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
    final Color iconColor =
        isDestructive ? AppColors.accent : AppColors.primary;
    final Color textColor =
        isDestructive ? AppColors.accent : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDestructive ? AppColors.accent.withValues(alpha: 0.2) : AppColors.grey200,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22.w),
            SizedBox(width: 14.w),
            Expanded(
              child: CustemText(
                text: title,
                size: 14,
                color: textColor,
              ),
            ),
            if (trailing != null)
              CustemText(
                text: trailing!,
                size: 13,
                color: AppColors.grey500,
              ),
            SizedBox(width: 4.w),
            Icon(
              Icons.chevron_right,
              color: AppColors.grey400,
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
