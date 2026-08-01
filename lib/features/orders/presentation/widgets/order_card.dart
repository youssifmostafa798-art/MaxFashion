import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/features/orders/presentation/widgets/order_status_chip.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, this.onTap});

  final OrderModel order;
  final VoidCallback? onTap;

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colorScheme.outline),
        ),
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
                      CustemText(
                        text: 'Order #${order.orderId}',
                        size: 15,
                        weight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      SizedBox(height: 4.h),
                      CustemText(
                        text: _formatDate(order.orderDate),
                        size: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                OrderStatusChip(status: order.status),
              ],
            ),
            SizedBox(height: 14.h),
            Container(height: 1, color: colorScheme.outline),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustemText(
                      text: '${order.itemCount} item${order.itemCount > 1 ? 's' : ''}',
                      size: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 2.h),
                    CustemText(
                      text: '\$${order.totalPrice.toStringAsFixed(2)}',
                      size: 16,
                      weight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: CustemText(
                      text: 'VIEW DETAILS',
                      size: 12,
                      color: colorScheme.surface,
                      spacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
