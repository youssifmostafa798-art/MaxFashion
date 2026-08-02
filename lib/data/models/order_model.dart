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
        'orderId': orderId,
        'orderDate': orderDate.toIso8601String(),
        'items': items.map((item) => item.toJson()).toList(),
        'totalPrice': totalPrice,
        'paymentMethod': paymentMethod,
        'deliveryAddress': deliveryAddress,
        'status': status.index,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: json['orderId'] as String,
        orderDate: DateTime.parse(json['orderDate'] as String),
        items: (json['items'] as List)
            .map((item) =>
                OrderItemModel.fromJson(item as Map<String, dynamic>))
            .toList(),
        totalPrice: (json['totalPrice'] as num).toDouble(),
        paymentMethod: json['paymentMethod'] as String,
        deliveryAddress: json['deliveryAddress'] as String,
        status: OrderStatus.values[json['status'] as int],
      );
}
