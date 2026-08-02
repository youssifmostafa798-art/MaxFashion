import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/haptic_utils.dart';

class ActionChipWidget extends StatelessWidget {
  const ActionChipWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.colorScheme,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticUtils.light();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14.w,
              color: isDestructive ? Colors.red.shade300 : colorScheme.onSurface,
            ),
            Gap(4.w),
            CustomText(
              text: label,
              size: 12,
              color: isDestructive ? Colors.red.shade300 : colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
