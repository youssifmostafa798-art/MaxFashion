import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/utils/date_formatter.dart';
import 'package:max/core/utils/order_display_helper.dart';
import 'package:max/core/utils/card_utils.dart';
import 'package:max/core/widgets/custom_appbar.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/features/orders/presentation/widgets/order_status_chip.dart';
import 'package:max/features/orders/presentation/widgets/order_timeline.dart';
import 'package:max/features/orders/presentation/widgets/info_row.dart';

String _formatPaymentMethod(String? paymentMethod, AppLocalizations l10n) {
  if (paymentMethod == null || paymentMethod.isEmpty) return '';
  final parsed = OrderModel.parsePaymentMethod(paymentMethod);
  if (parsed == null) return paymentMethod;
  final brandName = CardUtils.getCardBrandName(parsed.brand);
  return l10n.cardEnding(brandName, parsed.last4);
}

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const CustomAppbar(showSearchBar: false),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: OrderDisplayHelper.formatOrderId(order.orderId),
                        size: 18,
                        weight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: DateFormatter.formatDateTime(
                          order.orderDate,
                          locale: l10n.localeName,
                        ),
                        size: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                OrderStatusChip(status: order.status),
              ],
            ),
            SizedBox(height: 24.h),

            CustomText(
              text: l10n.productsLabel,
              size: 12,
              spacing: 2,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 12.h),
            ...order.items.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            item.productImage,
                            width: 60.w,
                            height: 60.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                color: colorScheme.outline,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.image_outlined,
                                color: colorScheme.surface,
                                size: 28.w,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: item.productName,
                                size: 14,
                                weight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              SizedBox(height: 4.h),
                              if (item.selectedColor != null)
                                CustomText(
                                  text: [
                                    l10n.sizeLabel(item.selectedSize),
                                    l10n.colorLabel(item.selectedColor!),
                                  ].join(' • '),
                                  size: 12,
                                  color: colorScheme.onSurfaceVariant,
                                )
                              else
                                CustomText(
                                  text: l10n.sizeLabel(item.selectedSize),
                                  size: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              SizedBox(height: 4.h),
                              CustomText(
                                text: l10n.qtyLabel(item.quantity.toString()),
                                size: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                        CustomText(
                          text: l10n.priceValue(item.totalPrice.toStringAsFixed(2)),
                          size: 14,
                          weight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ),
                )),
            SizedBox(height: 8.h),
            Container(height: 1, color: colorScheme.outline),
            SizedBox(height: 16.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: l10n.totalItems(order.itemCount.toString()),
                  size: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                CustomText(
                  text: l10n.priceValue(order.totalPrice.toStringAsFixed(2)),
                  size: 16,
                  weight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ],
            ),
            SizedBox(height: 24.h),

            InfoRow(
              label: l10n.deliveryAddressLabel,
              value: order.deliveryAddress,
            ),
            SizedBox(height: 16.h),
            InfoRow(
              label: l10n.paymentMethodLabel,
              value: _formatPaymentMethod(order.paymentMethod, l10n),
            ),
            SizedBox(height: 24.h),

            OrderTimeline(order: order),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
