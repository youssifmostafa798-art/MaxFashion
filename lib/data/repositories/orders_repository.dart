import 'package:max/data/models/order_model.dart';

class OrdersRepository {
  final List<OrderModel> _orders = [];

  List<OrderModel> getOrders() => List.unmodifiable(_orders);

  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.orderId == orderId);
    } catch (_) {
      return null;
    }
  }

  void addOrder(OrderModel order) {
    _orders.insert(0, order);
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: status);
    }
  }

  int get orderCount => _orders.length;
}
