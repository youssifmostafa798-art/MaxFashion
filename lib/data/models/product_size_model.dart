class ProductSizeModel {
  final int productId;
  final String size;
  final int stock;

  const ProductSizeModel({
    required this.productId,
    required this.size,
    required this.stock,
  });

  ProductSizeModel copyWith({
    int? productId,
    String? size,
    int? stock,
  }) {
    return ProductSizeModel(
      productId: productId ?? this.productId,
      size: size ?? this.size,
      stock: stock ?? this.stock,
    );
  }

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      productId: json['product_id'] as int,
      size: json['size'] as String,
      stock: json['stock'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'size': size,
      'stock': stock,
    };
  }
}
