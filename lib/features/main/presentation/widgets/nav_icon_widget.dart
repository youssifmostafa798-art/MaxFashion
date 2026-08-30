import 'package:flutter/material.dart';
import 'package:max/core/widgets/badge_widget.dart';

class NavIconWidget extends StatelessWidget {
  const NavIconWidget({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final currentIcon = isSelected ? activeIcon : icon;
    final currentColor = isSelected ? activeColor : inactiveColor;

    final iconWidget = Icon(
      currentIcon,
      size: 24,
      color: currentColor,
    );

    if (badgeCount > 0) {
      return BadgeWidget(
        count: badgeCount,
        child: iconWidget,
      );
    }

    return iconWidget;
  }
}
