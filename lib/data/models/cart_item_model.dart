class CartItemModel {
  final String? id;
  final int productId;
  final String productName;
  final String productImage;
  final String? selectedColor;
  final String selectedSize;
  final int quantity;
  final double unitPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CartItemModel({
    this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    this.selectedColor,
    this.selectedSize = '',
    required this.quantity,
    required this.unitPrice,
    this.createdAt,
    this.updatedAt,
  });

  double get totalPrice => unitPrice * quantity;

  bool get hasSize => selectedSize.isNotEmpty;

  CartItemModel copyWith({
    String? id,
    int? productId,
    String? productName,
    String? productImage,
    String? selectedColor,
    String? selectedSize,
    int? quantity,
    double? unitPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearSelectedColor = false,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      selectedColor: clearSelectedColor ? null : (selectedColor ?? this.selectedColor),
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'product_id': productId,
        'product_name': productName,
        'product_image': productImage,
        'selected_color': selectedColor,
        'selected_size': selectedSize,
        'quantity': quantity,
        'unit_price': unitPrice,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id'] as String?,
        productId: json['product_id'] as int,
        productName: (json['product_name'] as String?) ??
            (json['productName'] as String? ?? ''),
        productImage: (json['product_image'] as String?) ??
            (json['productImage'] as String? ?? ''),
        selectedColor: (json['selected_color'] as String?) ??
            (json['selectedColor'] as String?),
        selectedSize: (json['selected_size'] as String?) ??
            (json['selectedSize'] as String? ?? ''),
        quantity: json['quantity'] as int? ?? 1,
        unitPrice: (json['unit_price'] as num?)?.toDouble() ??
            (json['unitPrice'] as num?)?.toDouble() ??
            0.0,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : json['createdAt'] != null
                ? DateTime.parse(json['createdAt'] as String)
                : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : json['updatedAt'] != null
                ? DateTime.parse(json['updatedAt'] as String)
                : null,
      );
}
