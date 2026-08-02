import 'package:max/data/models/order_model.dart';
import 'package:max/data/services/orders_storage.dart';

class OrdersRepository {
  List<OrderModel> _orders = [];

  List<OrderModel> getOrders() => List.unmodifiable(_orders);

  Future<void> loadOrders() async {
    _orders = await OrdersStorage.loadOrders();
  }

  Future<void> addOrder(OrderModel order) async {
    _orders.insert(0, order);
    await OrdersStorage.saveOrders(_orders);
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: status);
      await OrdersStorage.saveOrders(_orders);
    }
  }

  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.orderId == orderId);
    } catch (_) {
      return null;
    }
  }
}
