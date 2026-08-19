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
      'card_holder_name': cardHolderName,
      'last4_digits': last4Digits,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'card_brand': cardBrand,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) {
    return PaymentCardModel(
      id: json['id'] as String,
      cardHolderName: (json['card_holder_name'] as String?) ??
          (json['cardHolderName'] as String? ?? ''),
      last4Digits: (json['last4_digits'] as String?) ??
          (json['last4Digits'] as String? ?? ''),
      expiryMonth: (json['expiry_month'] as String?) ??
          (json['expiryMonth'] as String? ?? ''),
      expiryYear: (json['expiry_year'] as String?) ??
          (json['expiryYear'] as String? ?? ''),
      cardBrand: (json['card_brand'] as String?) ??
          (json['cardBrand'] as String? ?? 'unknown'),
      isDefault: (json['is_default'] as bool?) ??
          (json['isDefault'] as bool? ?? false),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
    );
  }

  static String generateId() => IdGenerator.generate();
}
