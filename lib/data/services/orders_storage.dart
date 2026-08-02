import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/data/models/order_model.dart';

class OrdersStorage {
  static const String _key = 'orders';

  static Future<void> saveOrders(List<OrderModel> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = orders.map((order) => order.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  static Future<List<OrderModel>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null || jsonString.isEmpty) return [];
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
