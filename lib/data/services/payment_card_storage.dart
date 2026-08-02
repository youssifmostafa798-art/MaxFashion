import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/data/models/payment_card_model.dart';

class PaymentCardStorage {
  static const String _key = 'saved_payment_cards';

  static Future<void> saveCards(List<PaymentCardModel> cards) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, PaymentCardModel.encodeList(cards));
  }

  static Future<List<PaymentCardModel>> loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null || jsonString.isEmpty) return [];
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) =>
            PaymentCardModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
