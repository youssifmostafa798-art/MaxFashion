import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/cart_item_model.dart';

class CheckoutCartItemsList extends StatelessWidget {
  const CheckoutCartItemsList({
    super.key,
    required this.cartItems,
  });

  final List<CartItemModel> cartItems;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    item.productImage,
                    width: 48.w,
                    height: 48.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        color: Theme.of(context).colorScheme.surface,
                        size: 20.w,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: item.productName,
                        size: 13,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      SizedBox(height: 2.h),
                      CustomText(
                        text: item.selectedSize.isNotEmpty
                            ? l10n.sizeQtyLabel(item.selectedSize, item.quantity.toString())
                            : l10n.qtyLabel(item.quantity.toString()),
                        size: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                CustomText(
                  text: l10n.priceValue(item.totalPrice.toStringAsFixed(2)),
                  size: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
