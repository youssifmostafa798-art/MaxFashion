import 'package:max/core/constants/app_constants.dart';

class ProductTranslationModel {
  final int productId;
  final String locale;
  final String name;
  final String description;

  const ProductTranslationModel({
    required this.productId,
    required this.locale,
    required this.name,
    this.description = '',
  });

  ProductTranslationModel copyWith({
    int? productId,
    String? locale,
    String? name,
    String? description,
  }) {
    return ProductTranslationModel(
      productId: productId ?? this.productId,
      locale: locale ?? this.locale,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  factory ProductTranslationModel.fromJson(Map<String, dynamic> json) {
    return ProductTranslationModel(
      productId: json['product_id'] as int,
      locale: json['locale'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'locale': locale,
      'name': name,
      'description': description,
    };
  }

  static List<ProductTranslationModel> listFromJson(dynamic json) {
    return (json as List?)
            ?.map(
              (e) => ProductTranslationModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        const [];
  }

  /// Resolves the best translation for [languageCode]: exact match first,
  /// then the fallback locale, otherwise null when no usable row exists.
  static ProductTranslationModel? resolve(
    List<ProductTranslationModel> translations,
    String languageCode,
  ) {
    for (final translation in translations) {
      if (translation.locale == languageCode) return translation;
    }
    final fallback = AppConstants.fallbackLanguageCode;
    if (languageCode == fallback) return null;
    for (final translation in translations) {
      if (translation.locale == fallback) return translation;
    }
    return null;
  }
}
