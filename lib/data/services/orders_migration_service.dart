import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/data/models/order_model.dart';

class OrdersMigrationService {
  static const String _migrationKey = 'orders_migrated_to_supabase';
  static const String _ordersKey = 'orders';

  final SupabaseClient _client;

  OrdersMigrationService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<bool> get isMigrated async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_migrationKey) ?? false;
  }

  Future<OrdersMigrationResult> migrate() async {
    final result = OrdersMigrationResult();

    final user = _client.auth.currentUser;
    if (user == null) {
      result.failed++;
      result.errors.add('User not authenticated — cannot assign user_id to orders');
      return result;
    }

    final userId = user.id;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_ordersKey);

    if (jsonString == null || jsonString.isEmpty) {
      result.localOrdersFound = 0;
      await prefs.setBool(_migrationKey, true);
      return result;
    }

    final jsonList = jsonDecode(jsonString) as List;
    final localOrders = jsonList
        .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
        .toList();

    result.localOrdersFound = localOrders.length;

    if (localOrders.isEmpty) {
      await prefs.setBool(_migrationKey, true);
      return result;
    }

    for (final localOrder in localOrders) {
      try {
        final existingOrder = await _client
            .from('orders')
            .select('id')
            .eq('order_number', localOrder.orderId)
            .eq('user_id', userId)
            .maybeSingle();

        if (existingOrder != null) {
          result.skipped++;
          result.skippedOrderIds.add(localOrder.orderId);
          continue;
        }

        final orderResponse = await _client
            .from('orders')
            .insert({
              'user_id': userId,
              'order_number': localOrder.orderId,
              'total_price': localOrder.totalPrice,
              'status': _statusToDb(localOrder.status),
              'delivery_address': localOrder.deliveryAddress,
              'payment_method': localOrder.paymentMethod,
              'created_at': localOrder.orderDate.toUtc().toIso8601String(),
            })
            .select('id')
            .single();

        final dbOrderId = orderResponse['id'] as String;

        if (localOrder.items.isNotEmpty) {
          final itemsPayload = localOrder.items.map((item) {
            return {
              'order_id': dbOrderId,
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

        result.migrated++;
        result.migratedOrderIds.add(localOrder.orderId);
      } catch (e) {
        result.failed++;
        result.errors.add('Order ${localOrder.orderId}: ${e.toString()}');
      }
    }

    if (result.failed == 0) {
      await prefs.setBool(_migrationKey, true);
    }

    return result;
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

  int? _parseProductId(String productId) {
    return int.tryParse(productId);
  }
}

class OrdersMigrationResult {
  int localOrdersFound = 0;
  int migrated = 0;
  int skipped = 0;
  int failed = 0;
  final List<String> migratedOrderIds = [];
  final List<String> skippedOrderIds = [];
  final List<String> errors = [];

  bool get allSucceeded => failed == 0;
  bool get hasWork => localOrdersFound > 0;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('=== Orders Migration Result ===');
    buffer.writeln('Local orders found: $localOrdersFound');
    buffer.writeln('Migrated: $migrated');
    buffer.writeln('Skipped (already exist): $skipped');
    buffer.writeln('Failed: $failed');

    if (migratedOrderIds.isNotEmpty) {
      buffer.writeln('Migrated order IDs: ${migratedOrderIds.join(', ')}');
    }
    if (skippedOrderIds.isNotEmpty) {
      buffer.writeln('Skipped order IDs: ${skippedOrderIds.join(', ')}');
    }
    if (errors.isNotEmpty) {
      buffer.writeln('Errors:');
      for (final error in errors) {
        buffer.writeln('  - $error');
      }
    }

    return buffer.toString();
  }
}
