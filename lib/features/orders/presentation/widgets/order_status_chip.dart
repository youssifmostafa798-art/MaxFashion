import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/core/theme/app_text_styles.dart';

class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status});

  final OrderStatus status;

  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case OrderStatus.processing:
        return colorScheme.primaryContainer;
      case OrderStatus.shipped:
        return Colors.blue.shade100;
      case OrderStatus.delivered:
        return Colors.green.shade100;
      case OrderStatus.cancelled:
        return colorScheme.errorContainer;
    }
  }

  Color _getTextColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case OrderStatus.processing:
        return colorScheme.onPrimaryContainer;
      case OrderStatus.shipped:
        return Colors.blue.shade800;
      case OrderStatus.delivered:
        return Colors.green.shade800;
      case OrderStatus.cancelled:
        return colorScheme.onErrorContainer;
    }
  }

  String _getStatusLabel(AppLocalizations l10n) {
    switch (status) {
      case OrderStatus.processing:
        return l10n.statusProcessing;
      case OrderStatus.shipped:
        return l10n.statusShipped;
      case OrderStatus.delivered:
        return l10n.statusDelivered;
      case OrderStatus.cancelled:
        return l10n.statusCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        _getStatusLabel(l10n),
        style: TextStyle(
          fontSize: AppTextStyles.fontSize12,
          fontWeight: FontWeight.w600,
          color: _getTextColor(context),
        ),
      ),
    );
  }
}
