class ProductImageModel {
  final int id;
  final int productId;
  final String imageUrl;
  final int sortOrder;

  const ProductImageModel({
    required this.id,
    required this.productId,
    required this.imageUrl,
    required this.sortOrder,
  });

  ProductImageModel copyWith({
    int? id,
    int? productId,
    String? imageUrl,
    int? sortOrder,
  }) {
    return ProductImageModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      imageUrl: imageUrl ?? this.imageUrl,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      imageUrl: json['image_url'] as String,
      sortOrder: json['sort_order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'image_url': imageUrl,
      'sort_order': sortOrder,
    };
  }
}
