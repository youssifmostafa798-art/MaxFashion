import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/utils/date_formatter.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/core/widgets/custom_text.dart';

class OrderTimeline extends StatelessWidget {
  const OrderTimeline({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final steps = _buildSteps();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'ORDER TIMELINE',
          size: 12,
          spacing: 2,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(height: 16.h),
        ...List.generate(steps.length, (index) {
          final step = steps[index];
          final isLast = index == steps.length - 1;
          final isCompleted = step['completed'] as bool;
          final isCurrent = step['current'] as bool;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted || isCurrent
                          ? colorScheme.onSurface
                          : colorScheme.outline,
                    ),
                    child: isCompleted
                        ? Icon(Icons.check, size: 14.w, color: colorScheme.surface)
                        : isCurrent
                            ? Container(
                                margin: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.surface,
                                ),
                              )
                            : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2.w,
                      height: 40.h,
                      color: isCompleted
                          ? colorScheme.onSurface
                          : colorScheme.outline,
                    ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: step['title'] as String,
                        size: 14,
                        weight: FontWeight.w600,
                        color: isCompleted || isCurrent
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                      ),
                      if (step['date'] != null) ...[
                        SizedBox(height: 2.h),
                        CustomText(
                          text: DateFormatter.formatDateTime(step['date'] as DateTime),
                          size: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  List<Map<String, dynamic>> _buildSteps() {
    final now = order.orderDate;
    return [
      {
        'title': 'Order Placed',
        'date': now,
        'completed': true,
        'current': false,
      },
      {
        'title': 'Processing',
        'date': order.status.index >= OrderStatus.processing.index ? now.add(const Duration(hours: 2)) : null,
        'completed': order.status.index > OrderStatus.processing.index,
        'current': order.status == OrderStatus.processing,
      },
      {
        'title': 'Shipped',
        'date': order.status.index >= OrderStatus.shipped.index ? now.add(const Duration(days: 1)) : null,
        'completed': order.status.index > OrderStatus.shipped.index,
        'current': order.status == OrderStatus.shipped,
      },
      {
        'title': 'Delivered',
        'date': order.status == OrderStatus.delivered ? now.add(const Duration(days: 3)) : null,
        'completed': order.status == OrderStatus.delivered,
        'current': order.status == OrderStatus.delivered,
      },
    ];
  }
}
