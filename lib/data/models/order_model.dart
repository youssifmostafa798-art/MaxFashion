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
}
