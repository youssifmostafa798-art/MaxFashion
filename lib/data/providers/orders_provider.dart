import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/data/repositories/orders/order_repository.dart';
import 'package:max/data/repositories/orders/supabase_order_repository.dart';
import 'package:max/data/services/orders_migration_service.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return SupabaseOrderRepository();
});

final ordersMigrationServiceProvider = Provider<OrdersMigrationService>((ref) {
  return OrdersMigrationService();
});

class OrdersNotifier extends StateNotifier<List<OrderModel>> {
  final OrderRepository _repository;
  final OrdersMigrationService _migrationService;

  OrdersNotifier(this._repository, this._migrationService) : super([]) {
    _migrateAndLoad();
  }

  Future<void> _migrateAndLoad() async {
    final isMigrated = await _migrationService.isMigrated;
    if (!isMigrated) {
      await _migrationService.migrate();
    }
    await _repository.loadOrders();
    state = _repository.getOrders();
  }

  Future<void> addOrder(OrderModel order) async {
    await _repository.addOrder(order);
    state = _repository.getOrders();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _repository.updateOrderStatus(orderId, status);
    state = _repository.getOrders();
  }

  OrderModel? getOrderById(String orderId) {
    return _repository.getOrderById(orderId);
  }
}

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, List<OrderModel>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  final migrationService = ref.watch(ordersMigrationServiceProvider);
  return OrdersNotifier(repository, migrationService);
});

final ordersCountProvider = Provider<int>((ref) {
  return ref.watch(ordersProvider).length;
});
