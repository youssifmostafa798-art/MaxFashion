import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/l10n/app_localizations.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.itemId,
    required this.image,
    required this.title,
    required this.price,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    this.selectedColor,
    required this.selectedSize,
    this.isUpdating = false,
  });

  final String? itemId;
  final String image;
  final String title;
  final double price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final String? selectedColor;
  final String selectedSize;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(itemId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticUtils.medium();
        onRemove();
      },
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsetsDirectional.only(end: 24.w),
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
              child: Image.network(
                image,
                width: 90.w,
                height: 110.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90.w,
                  height: 110.h,
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_outlined,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
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
                    text: l10n.priceValue(price.toStringAsFixed(2)),
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
                            text: l10n.colorLabel(selectedColor!),
                            size: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                        if (selectedColor != null && selectedSize.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: CustomText(text: '|', size: 12, color: colorScheme.onSurfaceVariant),
                          ),
                        if (selectedSize.isNotEmpty)
                          CustomText(
                            text: l10n.sizeLabel(selectedSize),
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
                        onTap: isUpdating
                            ? null
                            : () {
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
                          child: isUpdating
                              ? SizedBox(
                                  key: const ValueKey('loading'),
                                  width: 14.w,
                                  height: 14.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                )
                              : CustomText(
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
                        onTap: isUpdating
                            ? null
                            : () {
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
    required VoidCallback? onTap,
  }) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDisabled
                ? Theme.of(context).colorScheme.outline.withValues(alpha: 0.4)
                : Theme.of(context).colorScheme.outline,
          ),
          color: isDisabled
              ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.5)
              : null,
        ),
        child: Icon(
          icon,
          size: 16.w,
          color: isDisabled
              ? Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4)
              : Theme.of(context).colorScheme.onSurface,
        ),
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
