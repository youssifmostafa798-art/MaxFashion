import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/utils/date_formatter.dart';
import 'package:max/core/widgets/custom_appbar.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/features/orders/presentation/widgets/order_status_chip.dart';
import 'package:max/features/orders/presentation/widgets/order_timeline.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppbar(showSearchBar: false),
      body: SingleChildScrollView(
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
                        text: 'Order #${order.orderId}',
                        size: 18,
                        weight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: DateFormatter.formatDateTime(order.orderDate),
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
              text: 'PRODUCTS',
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
                          child: Image.asset(
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
                                    'Size: ${item.selectedSize}',
                                    'Color: ${item.selectedColor}',
                                  ].join(' • '),
                                  size: 12,
                                  color: colorScheme.onSurfaceVariant,
                                )
                              else
                                CustomText(
                                  text: 'Size: ${item.selectedSize}',
                                  size: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              SizedBox(height: 4.h),
                              CustomText(
                                text: 'Qty: ${item.quantity}',
                                size: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                        CustomText(
                          text: '\$${item.totalPrice.toStringAsFixed(2)}',
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
                  text: 'Total (${order.itemCount} items)',
                  size: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                CustomText(
                  text: '\$${order.totalPrice.toStringAsFixed(2)}',
                  size: 16,
                  weight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ],
            ),
            SizedBox(height: 24.h),

            _InfoRow(
              label: 'DELIVERY ADDRESS',
              value: order.deliveryAddress,
            ),
            SizedBox(height: 16.h),
            _InfoRow(
              label: 'PAYMENT METHOD',
              value: order.paymentMethod,
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          size: 12,
          spacing: 2,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: CustomText(
            text: value,
            size: 14,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
