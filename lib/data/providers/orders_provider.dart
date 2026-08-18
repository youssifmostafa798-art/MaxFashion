import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/core/models/loadable_list_state.dart';
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

class OrdersNotifier extends StateNotifier<LoadableListState<OrderModel>> {
  final OrderRepository _repository;
  final OrdersMigrationService _migrationService;
  final String? _userId;

  OrdersNotifier(this._repository, this._migrationService, {String? userId})
      : _userId = userId,
        super(const LoadableListState()) {
    _migrateAndLoad();
  }

  Future<void> _migrateAndLoad() async {
    if (!mounted) return;
    if (_userId == null) {
      state = const LoadableListState();
      return;
    }
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final isMigrated = await _migrationService.isMigrated;
      if (!mounted) return;
      if (!isMigrated) {
        await _migrationService.migrate();
        if (!mounted) return;
      }
      await _repository.loadOrders();
      if (!mounted) return;
      state = state.copyWith(items: _repository.getOrders(), isLoading: false);
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(
        items: [],
        isLoading: false,
        error: 'Could not load orders. Please try again.',
      );
    }
  }

  Future<void> addOrder(OrderModel order) async {
    try {
      await _repository.addOrder(order);
      if (!mounted) return;
      state = state.copyWith(items: _repository.getOrders(), clearError: true);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _repository.updateOrderStatus(orderId, status);
      if (!mounted) return;
      state = state.copyWith(items: _repository.getOrders(), clearError: true);
    } catch (_) {
      rethrow;
    }
  }

  OrderModel? getOrderById(String orderId) {
    return _repository.getOrderById(orderId);
  }
}

final ordersProvider = StateNotifierProvider<OrdersNotifier,
    LoadableListState<OrderModel>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  final migrationService = ref.watch(ordersMigrationServiceProvider);
  final userId = ref.watch(currentUserIdProvider);
  return OrdersNotifier(repository, migrationService, userId: userId);
});

final ordersCountProvider = Provider<int>((ref) {
  return ref.watch(ordersProvider).length;
});
