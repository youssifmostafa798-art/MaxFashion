import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_text.dart';

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
    this.selectedSize,
  });

  final String image;
  final String title;
  final double price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final String? selectedColor;
  final String? selectedSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
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
                      child: CustemText(
                        text: title.toUpperCase(),
                        size: 13,
                        color: colorScheme.onSurface,
                        spacing: 2,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: Icon(
                        Icons.close,
                        size: 18.w,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Gap(6.h),
                CustemText(
                  text: '\$${price.toStringAsFixed(2)}',
                  size: 15,
                  weight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                if (selectedColor != null || selectedSize != null) ...[
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
                        CustemText(
                          text: selectedColor!,
                          size: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                      if (selectedColor != null && selectedSize != null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: CustemText(text: '|', size: 12, color: colorScheme.onSurfaceVariant),
                        ),
                      if (selectedSize != null)
                        CustemText(
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
                      onTap: onDecrement,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: CustemText(
                        text: quantity.toString(),
                        size: 14,
                        weight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    _buildQtyButton(
                      context: context,
                      icon: Icons.add,
                      onTap: onIncrement,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
