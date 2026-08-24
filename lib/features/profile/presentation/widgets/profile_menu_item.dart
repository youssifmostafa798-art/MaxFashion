import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/haptic_utils.dart';

class ProfileMenuItem extends StatefulWidget {
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
  State<ProfileMenuItem> createState() => _ProfileMenuItemState();
}

class _ProfileMenuItemState extends State<ProfileMenuItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color iconColor =
        widget.isDestructive ? AppColors.accent : colorScheme.onSurface;
    final Color textColor =
        widget.isDestructive ? AppColors.accent : colorScheme.onSurface;

    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _controller.forward() : null,
      onTapUp: widget.onTap != null
          ? (_) {
              _controller.reverse();
              HapticUtils.light();
              widget.onTap?.call();
            }
          : null,
      onTapCancel: widget.onTap != null ? () => _controller.reverse() : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: widget.isDestructive
                  ? AppColors.accent.withValues(alpha: 0.2)
                  : colorScheme.outline,
            ),
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: iconColor, size: 22.w),
              SizedBox(width: 14.w),
              Expanded(
                child: CustomText(
                  text: widget.title,
                  size: 14,
                  color: textColor,
                ),
              ),
              if (widget.trailing != null)
                CustomText(
                  text: widget.trailing!,
                  size: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              SizedBox(width: 4.w),
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left
                    : Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
                size: 20.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
