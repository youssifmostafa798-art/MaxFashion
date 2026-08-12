import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/data/models/order_item_model.dart';
import 'package:max/data/repositories/orders/order_repository.dart';

class SupabaseOrderRepository implements OrderRepository {
  SupabaseOrderRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const String _storageBaseUrl =
      'https://tonctmdcntftugdskqmb.supabase.co/storage/v1/object/public/product-images';

  static const _selectWithItems = '''
    id, user_id, order_number, total_price, status,
    delivery_address, payment_method, created_at, updated_at,
    order_items(
      id, product_id, product_name, product_image,
      selected_color, selected_size, quantity, unit_price, created_at
    )
  ''';

  String _buildImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http')) return url;
    return '$_storageBaseUrl/$url';
  }

  String _statusToDb(OrderStatus status) {
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

  OrderStatus _statusFromDb(String status) {
    switch (status) {
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

  int? _parseProductId(String productId) {
    return int.tryParse(productId);
  }

  OrderItemModel _mapItemRow(Map<String, dynamic> row) {
    final rawProductId = row['product_id'];
    final productId = rawProductId != null ? rawProductId.toString() : '';

    return OrderItemModel(
      productId: productId,
      productName: row['product_name'] as String,
      productImage: _buildImageUrl(row['product_image'] as String?),
      selectedColor: row['selected_color'] as String?,
      selectedSize: row['selected_size'] as String? ?? 'S',
      quantity: row['quantity'] as int,
      unitPrice: (row['unit_price'] as num).toDouble(),
    );
  }

  OrderModel _mapOrderRow(Map<String, dynamic> row) {
    final itemsRaw = row['order_items'] as List? ?? [];
    final items = itemsRaw
        .map((item) => _mapItemRow(item as Map<String, dynamic>))
        .toList();

    return OrderModel(
      orderId: row['order_number'] as String,
      orderDate: DateTime.parse(row['created_at'] as String),
      items: items,
      totalPrice: (row['total_price'] as num).toDouble(),
      paymentMethod: row['payment_method'] as String,
      deliveryAddress: row['delivery_address'] as String,
      status: _statusFromDb(row['status'] as String),
    );
  }

  List<OrderModel> _orders = [];

  @override
  List<OrderModel> getOrders() => List.unmodifiable(_orders);

  @override
  Future<void> loadOrders() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client
        .from('orders')
        .select(_selectWithItems)
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    _orders = (response as List)
        .map((row) => _mapOrderRow(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addOrder(OrderModel order) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final orderResponse = await _client
        .from('orders')
        .insert({
          'user_id': userId,
          'order_number': order.orderId,
          'total_price': order.totalPrice,
          'status': _statusToDb(order.status),
          'delivery_address': order.deliveryAddress,
          'payment_method': order.paymentMethod,
          'created_at': order.orderDate.toUtc().toIso8601String(),
        })
        .select('id')
        .single();

    final orderId = orderResponse['id'] as String;

    if (order.items.isNotEmpty) {
      final itemsPayload = order.items.map((item) {
        return {
          'order_id': orderId,
          'product_id': _parseProductId(item.productId),
          'product_name': item.productName,
          'product_image': item.productImage,
          'selected_color': item.selectedColor,
          'selected_size': item.selectedSize,
          'quantity': item.quantity,
          'unit_price': item.unitPrice,
        };
      }).toList();

      await _client.from('order_items').insert(itemsPayload);
    }

    await loadOrders();
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _client
        .from('orders')
        .update({
          'status': _statusToDb(status),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('order_number', orderId)
        .eq('user_id', userId);

    await loadOrders();
  }

  @override
  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.orderId == orderId);
    } catch (_) {
      return null;
    }
  }
}
