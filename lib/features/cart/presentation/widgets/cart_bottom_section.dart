import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/core/widgets/custom_button.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/features/checkout/presentation/pages/place_order.dart';
import 'package:max/core/l10n/app_localizations.dart';

class CartBottomSection extends ConsumerWidget {
  const CartBottomSection({super.key, required this.isClearing});

  final bool isClearing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isCartEmpty = ref.watch(cartProvider.select((s) => s.items.isEmpty));
    final subtotal = ref.watch(cartSubtotalProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  text: l10n.subtotal, size: 14, color: colorScheme.onSurfaceVariant),
              CustomText(
                text: l10n.priceValue(subtotal.toStringAsFixed(2)),
                size: 14,
                color: colorScheme.onSurface,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  text: l10n.delivery, size: 14, color: colorScheme.onSurfaceVariant),
              CustomText(text: l10n.free, size: 14, color: AppColors.accent),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 1, color: colorScheme.outline),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: l10n.estimatedTotal,
                size: 16,
                weight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
              CustomText(
                text: l10n.priceValue(subtotal.toStringAsFixed(2)),
                size: 16,
                weight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          CustomButton(
            isSvg: true,
            title: l10n.checkout,
            onTap: isCartEmpty
                ? null
                : () {
                    HapticUtils.light();
                    final cartItems = ref.read(cartItemsProvider);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceOrder(
                          cartItems: cartItems,
                          total: subtotal,
                        ),
                      ),
                    );
                  },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
