import 'dart:convert';
import 'package:max/core/utils/id_generator.dart';

class PaymentCardModel {
  final String id;
  final String cardHolderName;
  final String last4Digits;
  final String expiryMonth;
  final String expiryYear;
  final String cardBrand;
  final bool isDefault;
  final DateTime createdAt;

  const PaymentCardModel({
    required this.id,
    required this.cardHolderName,
    required this.last4Digits,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cardBrand,
    this.isDefault = false,
    required this.createdAt,
  });

  String get maskedNumber => '**** **** **** $last4Digits';

  String get expiry => '$expiryMonth/$expiryYear';

  PaymentCardModel copyWith({
    String? id,
    String? cardHolderName,
    String? last4Digits,
    String? expiryMonth,
    String? expiryYear,
    String? cardBrand,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return PaymentCardModel(
      id: id ?? this.id,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      last4Digits: last4Digits ?? this.last4Digits,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      cardBrand: cardBrand ?? this.cardBrand,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardHolderName': cardHolderName,
      'last4Digits': last4Digits,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'cardBrand': cardBrand,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) {
    return PaymentCardModel(
      id: json['id'] as String,
      cardHolderName: json['cardHolderName'] as String,
      last4Digits: json['last4Digits'] as String,
      expiryMonth: json['expiryMonth'] as String,
      expiryYear: json['expiryYear'] as String,
      cardBrand: json['cardBrand'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  static String encodeList(List<PaymentCardModel> cards) {
    return jsonEncode(cards.map((c) => c.toJson()).toList());
  }

  static List<PaymentCardModel> decodeList(String encoded) {
    final List<dynamic> list = jsonDecode(encoded) as List<dynamic>;
    return list
        .map((item) => PaymentCardModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static String generateId() => IdGenerator.generate();
}
