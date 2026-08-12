import 'package:max/data/models/order_model.dart';

abstract class OrderRepository {
  Future<void> loadOrders();
  List<OrderModel> getOrders();
  Future<void> addOrder(OrderModel order);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
  OrderModel? getOrderById(String orderId);
}
