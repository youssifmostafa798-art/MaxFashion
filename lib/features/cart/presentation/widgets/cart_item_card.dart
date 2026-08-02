import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/haptic_utils.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    this.selectedColor,
    required this.selectedSize,
  });

  final String image;
  final String title;
  final double price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final String? selectedColor;
  final String selectedSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey('$title-$selectedSize-$selectedColor'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticUtils.medium();
        onRemove();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24.w),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.red.shade300,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 24.w),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                image,
                width: 90.w,
                height: 110.h,
                fit: BoxFit.cover,
                cacheWidth: 90,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: title.toUpperCase(),
                          size: 13,
                          color: colorScheme.onSurface,
                          spacing: 2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticUtils.light();
                          onRemove();
                        },
                        child: Icon(
                          Icons.close,
                          size: 18.w,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Gap(6.h),
                  CustomText(
                    text: '\$${price.toStringAsFixed(2)}',
                    size: 15,
                    weight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  if (selectedColor != null || selectedSize.isNotEmpty) ...[
                    Gap(6.h),
                    Row(
                      children: [
                        if (selectedColor != null) ...[
                          Container(
                            width: 14.w,
                            height: 14.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _parseColor(selectedColor!),
                              border: Border.all(color: colorScheme.outline),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: selectedColor!,
                            size: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                        if (selectedColor != null && selectedSize.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: CustomText(text: '|', size: 12, color: colorScheme.onSurfaceVariant),
                          ),
                        CustomText(
                          text: 'Size: $selectedSize',
                          size: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                  Gap(10.h),
                  Row(
                    children: [
                      _buildQtyButton(
                        context: context,
                        icon: Icons.remove,
                        onTap: () {
                          HapticUtils.light();
                          onDecrement();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) => ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                          child: CustomText(
                            key: ValueKey(quantity),
                            text: quantity.toString(),
                            size: 14,
                            weight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      _buildQtyButton(
                        context: context,
                        icon: Icons.add,
                        onTap: () {
                          HapticUtils.light();
                          onIncrement();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Icon(icon, size: 16.w, color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }

  static Color _parseColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'brown':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}
