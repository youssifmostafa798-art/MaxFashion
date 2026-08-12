import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/data/providers/auth_provider.dart';
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
    try {
      final isMigrated = await _migrationService.isMigrated;
      if (!mounted) return;
      if (!isMigrated) {
        await _migrationService.migrate();
        if (!mounted) return;
      }
      await _repository.loadOrders();
      if (!mounted) return;
      state = _repository.getOrders();
    } catch (_) {
      if (!mounted) return;
      state = [];
    }
  }

  Future<void> addOrder(OrderModel order) async {
    try {
      await _repository.addOrder(order);
      if (!mounted) return;
      state = _repository.getOrders();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _repository.updateOrderStatus(orderId, status);
      if (!mounted) return;
      state = _repository.getOrders();
    } catch (_) {
      rethrow;
    }
  }

  OrderModel? getOrderById(String orderId) {
    return _repository.getOrderById(orderId);
  }
}

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, List<OrderModel>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  final migrationService = ref.watch(ordersMigrationServiceProvider);
  ref.watch(currentUserIdProvider);
  return OrdersNotifier(repository, migrationService);
});

final ordersCountProvider = Provider<int>((ref) {
  return ref.watch(ordersProvider).length;
});
