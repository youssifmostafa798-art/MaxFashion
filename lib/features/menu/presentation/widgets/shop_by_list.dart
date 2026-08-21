import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';

class ShopByItem {
  final String label;
  final IconData icon;

  const ShopByItem(this.label, this.icon);
}

class ShopByList extends StatelessWidget {
  const ShopByList({super.key});

  static const _items = [
    ShopByItem('New Arrivals', Icons.new_releases_outlined),
    ShopByItem('Trending Now', Icons.trending_up),
    ShopByItem('Best Sellers', Icons.thumb_up_outlined),
    ShopByItem('Online Exclusive', Icons.language),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: _items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 80)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 12 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(item.icon, color: colorScheme.onSurface, size: 22.w),
                SizedBox(width: 14.w),
                Expanded(
                  child: CustomText(
                    text: item.label,
                    size: 14,
                    color: colorScheme.onSurface,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                  size: 20.w,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
