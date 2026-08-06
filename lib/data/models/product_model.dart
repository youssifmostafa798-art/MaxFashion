import 'package:max/data/models/product_image_model.dart';
import 'package:max/data/models/product_size_model.dart';

class ProductModel {
  final String id;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final String brand;
  final String thumbnailUrl;
  final bool isFeatured;
  final bool isAvailable;
  final List<ProductImageModel> productImages;
  final List<ProductSizeModel> productSizes;

  const ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.brand,
    required this.thumbnailUrl,
    this.isFeatured = false,
    this.isAvailable = true,
    this.productImages = const [],
    this.productSizes = const [],
  });

  String get image => thumbnailUrl;

  String get category {
    const map = {
      1: 'Sunglasses',
      2: 'Watches',
      3: 'Jeans',
      4: 'Polos',
      5: 'Shirts',
      6: 'Shorts',
      7: 'T-Shirts',
      8: 'Boots',
      9: 'Loafers',
      10: 'Running Shoes',
      11: 'Sneakers',
      12: 'Accessories',
      13: 'Bracelets',
      14: 'Earrings',
      15: 'Necklaces',
      16: 'Rings',
      17: 'Bags',
      18: 'Blouses',
      19: 'Crop Tops',
      20: 'Dresses',
      21: 'Skirts',
      22: 'Wide Leg Pants',
      23: 'Heels',
    };
    return map[categoryId] ?? '';
  }

  bool get featured => isFeatured;

  String get collection => '';

  List<String> get keywords => [];

  List<String> get sizes => productSizes.map((s) => s.size).toList();

  double get effectivePrice => discountPrice ?? price;

  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  ProductModel copyWith({
    String? id,
    int? categoryId,
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    String? brand,
    String? thumbnailUrl,
    bool? isFeatured,
    bool? isAvailable,
    List<ProductImageModel>? productImages,
    List<ProductSizeModel>? productSizes,
    bool clearDiscountPrice = false,
  }) {
    return ProductModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice:
          clearDiscountPrice ? null : (discountPrice ?? this.discountPrice),
      brand: brand ?? this.brand,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      isAvailable: isAvailable ?? this.isAvailable,
      productImages: productImages ?? this.productImages,
      productSizes: productSizes ?? this.productSizes,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: 'p${json['id']}',
      categoryId: json['category_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: json['discount_price'] != null
          ? (json['discount_price'] as num).toDouble()
          : null,
      brand: json['brand'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      isFeatured: json['is_featured'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'brand': brand,
      'thumbnail_url': thumbnailUrl,
      'is_featured': isFeatured,
      'is_available': isAvailable,
    };
  }
}
