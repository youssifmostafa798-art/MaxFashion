import 'package:max/data/models/order_item_model.dart';

enum OrderStatus { processing, shipped, delivered, cancelled }

class OrderModel {
  final String orderId;
  final DateTime orderDate;
  final List<OrderItemModel> items;
  final double totalPrice;
  final String paymentMethod;
  final String deliveryAddress;
  final OrderStatus status;

  const OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.items,
    required this.totalPrice,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.status,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  String get statusLabel {
    switch (status) {
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static String statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  static OrderStatus statusFromString(String? value) {
    switch (value) {
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'processing':
      default:
        return OrderStatus.processing;
    }
  }

  OrderModel copyWith({
    String? orderId,
    DateTime? orderDate,
    List<OrderItemModel>? items,
    double? totalPrice,
    String? paymentMethod,
    String? deliveryAddress,
    OrderStatus? status,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      orderDate: orderDate ?? this.orderDate,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'order_date': orderDate.toIso8601String(),
        'items': items.map((item) => item.toJson()).toList(),
        'total_price': totalPrice,
        'payment_method': paymentMethod,
        'delivery_address': deliveryAddress,
        'status': statusToString(status),
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: (json['order_id'] as String?) ??
            (json['orderId'] as String?) ??
            '',
        orderDate: (() {
          final raw = json['order_date'] ?? json['orderDate'];
          if (raw == null) return DateTime.now();
          return DateTime.parse(raw as String);
        })(),
        items: (json['items'] as List?)
                ?.map((item) =>
                    OrderItemModel.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],
        totalPrice: ((json['total_price'] ?? json['totalPrice']) as num?)
                ?.toDouble() ??
            0.0,
        paymentMethod: (json['payment_method'] as String?) ??
            (json['paymentMethod'] as String?) ??
            '',
        deliveryAddress: (json['delivery_address'] as String?) ??
            (json['deliveryAddress'] as String?) ??
            '',
        status: (() {
          final raw = json['status'];
          if (raw is int) {
            if (raw >= 0 && raw < OrderStatus.values.length) {
              return OrderStatus.values[raw];
            }
            return OrderStatus.processing;
          }
          return statusFromString(raw as String?);
        })(),
      );
}
