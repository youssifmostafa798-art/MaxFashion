import 'package:flutter_test/flutter_test.dart';
import 'package:max/data/models/order_model.dart';

void main() {
  group('OrderModel.fromJson — legacy integer status', () {
    test('status: 0 → OrderStatus.processing', () {
      final json = {
        'order_id': 'ORD-001',
        'order_date': '2025-01-15T10:30:00.000',
        'items': <dynamic>[],
        'total_price': 99.99,
        'payment_method': 'Credit Card',
        'delivery_address': '123 Main St',
        'status': 0,
      };

      final order = OrderModel.fromJson(json);
      expect(order.status, OrderStatus.processing);
    });

    test('status: 1 → OrderStatus.shipped', () {
      final json = {
        'order_id': 'ORD-002',
        'order_date': '2025-02-10T14:00:00.000',
        'items': <dynamic>[],
        'total_price': 50.00,
        'payment_method': 'Cash on Delivery',
        'delivery_address': '456 Oak Ave',
        'status': 1,
      };

      final order = OrderModel.fromJson(json);
      expect(order.status, OrderStatus.shipped);
    });

    test('status: 2 → OrderStatus.delivered', () {
      final json = {
        'order_id': 'ORD-003',
        'order_date': '2025-03-05T09:15:00.000',
        'items': <dynamic>[],
        'total_price': 25.00,
        'payment_method': 'Debit Card',
        'delivery_address': '789 Pine Rd',
        'status': 2,
      };

      final order = OrderModel.fromJson(json);
      expect(order.status, OrderStatus.delivered);
    });

    test('status: 3 → OrderStatus.cancelled', () {
      final json = {
        'order_id': 'ORD-004',
        'order_date': '2025-04-20T16:45:00.000',
        'items': <dynamic>[],
        'total_price': 120.00,
        'payment_method': 'UPI',
        'delivery_address': '321 Elm St',
        'status': 3,
      };

      final order = OrderModel.fromJson(json);
      expect(order.status, OrderStatus.cancelled);
    });
  });

  group('OrderModel.fromJson — current string status', () {
    test('status: "processing" → OrderStatus.processing', () {
      final json = {
        'order_id': 'ORD-010',
        'order_date': '2025-06-01T08:00:00.000',
        'items': <dynamic>[],
        'total_price': 45.00,
        'payment_method': 'Net Banking',
        'delivery_address': '100 Market St',
        'status': 'processing',
      };

      final order = OrderModel.fromJson(json);
      expect(order.status, OrderStatus.processing);
    });

    test('status: "shipped" → OrderStatus.shipped', () {
      final json = {
        'order_id': 'ORD-011',
        'order_date': '2025-06-02T12:00:00.000',
        'items': <dynamic>[],
        'total_price': 75.00,
        'payment_method': 'Credit Card',
        'delivery_address': '200 Center Ave',
        'status': 'shipped',
      };

      final order = OrderModel.fromJson(json);
      expect(order.status, OrderStatus.shipped);
    });
  });

  group('OrderModel.fromJson — edge cases', () {
    test('negative integer status defaults to processing', () {
      final json = {
        'order_id': 'ORD-020',
        'order_date': '2025-07-01T10:00:00.000',
        'items': <dynamic>[],
        'total_price': 10.00,
        'payment_method': 'Cash',
        'delivery_address': 'Test St',
        'status': -1,
      };

      final order = OrderModel.fromJson(json);
      expect(order.status, OrderStatus.processing);
    });

    test('out-of-range integer status (99) defaults to processing', () {
      final json = {
        'order_id': 'ORD-021',
        'order_date': '2025-07-02T10:00:00.000',
        'items': <dynamic>[],
        'total_price': 10.00,
        'payment_method': 'Cash',
        'delivery_address': 'Test St',
        'status': 99,
      };

      final order = OrderModel.fromJson(json);
      expect(order.status, OrderStatus.processing);
    });

    test('null status defaults to processing', () {
      final json = {
        'order_id': 'ORD-022',
        'order_date': '2025-07-03T10:00:00.000',
        'items': <dynamic>[],
        'total_price': 10.00,
        'payment_method': 'Cash',
        'delivery_address': 'Test St',
        'status': null,
      };

      final order = OrderModel.fromJson(json);
      expect(order.status, OrderStatus.processing);
    });

    test('missing status defaults to processing', () {
      final json = {
        'order_id': 'ORD-023',
        'order_date': '2025-07-04T10:00:00.000',
        'items': <dynamic>[],
        'total_price': 10.00,
        'payment_method': 'Cash',
        'delivery_address': 'Test St',
      };

      final order = OrderModel.fromJson(json);
      expect(order.status, OrderStatus.processing);
    });
  });
}
