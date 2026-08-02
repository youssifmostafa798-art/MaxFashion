class CartItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final String? selectedColor;
  final String selectedSize;
  final int quantity;
  final double unitPrice;

  const CartItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    this.selectedColor,
    required this.selectedSize,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => unitPrice * quantity;

  CartItemModel copyWith({
    String? productId,
    String? productName,
    String? productImage,
    String? selectedColor,
    String? selectedSize,
    int? quantity,
    double? unitPrice,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  static String generateProductId(String name, String image, String size) {
    return '${name}_${image}_$size'.replaceAll(RegExp(r'\s+'), '_');
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'productImage': productImage,
        'selectedColor': selectedColor,
        'selectedSize': selectedSize,
        'quantity': quantity,
        'unitPrice': unitPrice,
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        productId: json['productId'] as String,
        productName: json['productName'] as String,
        productImage: json['productImage'] as String,
        selectedColor: json['selectedColor'] as String?,
        selectedSize: (json['selectedSize'] as String?) ?? 'S',
        quantity: json['quantity'] as int,
        unitPrice: (json['unitPrice'] as num).toDouble(),
      );
}
