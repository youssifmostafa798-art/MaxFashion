import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/data/repositories/orders_repository.dart';

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository();
});

class OrdersNotifier extends StateNotifier<List<OrderModel>> {
  final OrdersRepository _repository;

  OrdersNotifier(this._repository) : super(_repository.getOrders());

  void addOrder(OrderModel order) {
    _repository.addOrder(order);
    state = _repository.getOrders();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    _repository.updateOrderStatus(orderId, status);
    state = _repository.getOrders();
  }

  OrderModel? getOrderById(String orderId) {
    return _repository.getOrderById(orderId);
  }
}

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, List<OrderModel>>((ref) {
  final repository = ref.watch(ordersRepositoryProvider);
  return OrdersNotifier(repository);
});

final ordersCountProvider = Provider<int>((ref) {
  return ref.watch(ordersProvider).length;
});
