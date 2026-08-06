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

  static List<ProductModel> products = [
    const ProductModel(
      id: 'p1',
      categoryId: 8,
      name: "Boots",
      thumbnailUrl: 'assets/product/product1.png',
      price: 50,
      description: 'Classic leather boots for all seasons',
      brand: 'MaxFashion',
      isFeatured: true,
    ),
    const ProductModel(
      id: 'p2',
      categoryId: 14,
      name: "Earrings",
      thumbnailUrl: 'assets/product/product2.png',
      price: 100,
      description: 'Elegant gold-plated earrings',
      brand: 'MaxFashion',
      isFeatured: true,
    ),
    const ProductModel(
      id: 'p3',
      categoryId: 16,
      name: "Stalesteel\nring",
      thumbnailUrl: 'assets/product/product3.png',
      price: 40,
      description: 'Minimalist steel ring',
      brand: 'MaxFashion',
    ),
    const ProductModel(
      id: 'p4',
      categoryId: 16,
      name: "Gold-plated\nring",
      thumbnailUrl: 'assets/product/product4.png',
      price: 100,
      description: 'Premium gold-plated ring',
      brand: 'MaxFashion',
    ),
    const ProductModel(
      id: 'p5',
      categoryId: 16,
      name: "Gold-plated\nring",
      thumbnailUrl: 'assets/product/product5.png',
      price: 80,
      description: 'Luxury gold ring with white collection',
      brand: 'MaxFashion',
    ),
    const ProductModel(
      id: 'p6',
      categoryId: 20,
      name: "Dress",
      thumbnailUrl: 'assets/product/product6.png',
      price: 120,
      description: 'Elegant evening dress',
      brand: 'MaxFashion',
      isFeatured: true,
    ),
    const ProductModel(
      id: 'p7',
      categoryId: 5,
      name: "Classic\nBlazer",
      thumbnailUrl: 'assets/product/product1.png',
      price: 190,
      description: 'Tailored blazer for men',
      brand: 'MaxFashion',
      isFeatured: true,
    ),
    const ProductModel(
      id: 'p8',
      categoryId: 11,
      name: "Running\nSneakers",
      thumbnailUrl: 'assets/product/product1.png',
      price: 85,
      description: 'Lightweight running sneakers',
      brand: 'MaxFashion',
      isFeatured: true,
    ),
    const ProductModel(
      id: 'p9',
      categoryId: 12,
      name: "Silk\nScarf",
      thumbnailUrl: 'assets/product/product2.png',
      price: 65,
      description: 'Premium silk scarf',
      brand: 'MaxFashion',
    ),
    const ProductModel(
      id: 'p10',
      categoryId: 7,
      name: "Kids\nT-Shirt",
      thumbnailUrl: 'assets/product/product6.png',
      price: 25,
      description: 'Soft cotton t-shirt for kids',
      brand: 'MaxFashion',
    ),
    const ProductModel(
      id: 'p11',
      categoryId: 3,
      name: "Skinny\nJeans",
      thumbnailUrl: 'assets/product/product6.png',
      price: 75,
      description: 'Stretchy skinny jeans for women',
      brand: 'MaxFashion',
    ),
    const ProductModel(
      id: 'p12',
      categoryId: 7,
      name: "Kids\nJacket",
      thumbnailUrl: 'assets/product/product1.png',
      price: 45,
      description: 'Warm winter jacket for kids',
      brand: 'MaxFashion',
    ),
    const ProductModel(
      id: 'p13',
      categoryId: 12,
      name: "Leather\nBelt",
      thumbnailUrl: 'assets/product/product3.png',
      price: 55,
      description: 'Genuine leather belt for men',
      brand: 'MaxFashion',
    ),
    const ProductModel(
      id: 'p14',
      categoryId: 23,
      name: "High\nHeels",
      thumbnailUrl: 'assets/product/product1.png',
      price: 110,
      description: 'Stylish high heels for women',
      brand: 'MaxFashion',
    ),
    const ProductModel(
      id: 'p15',
      categoryId: 17,
      name: "Crossbody\nBag",
      thumbnailUrl: 'assets/product/product5.png',
      price: 95,
      description: 'Compact crossbody bag',
      brand: 'MaxFashion',
      isFeatured: true,
    ),
    const ProductModel(
      id: 'p16',
      categoryId: 4,
      name: "Polo\nShirt",
      thumbnailUrl: 'assets/product/product6.png',
      price: 60,
      description: 'Classic polo shirt for men',
      brand: 'MaxFashion',
    ),
    const ProductModel(
      id: 'p17',
      categoryId: 23,
      name: "Summer\nFlats",
      thumbnailUrl: 'assets/product/product1.png',
      price: 45,
      description: 'Comfortable summer flats',
      brand: 'MaxFashion',
    ),
    const ProductModel(
      id: 'p18',
      categoryId: 6,
      name: "Kids\nShorts",
      thumbnailUrl: 'assets/product/product6.png',
      price: 20,
      description: 'Comfortable shorts for kids',
      brand: 'MaxFashion',
    ),
  ];
}
