import 'package:max/data/models/cart_item_model.dart';

class OrderItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final String? selectedColor;
  final String selectedSize;
  final int quantity;
  final double unitPrice;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    this.selectedColor,
    required this.selectedSize,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => unitPrice * quantity;

  factory OrderItemModel.fromCartItem(CartItemModel item) {
    return OrderItemModel(
      productId: item.productId.toString(),
      productName: item.productName,
      productImage: item.productImage,
      selectedColor: item.selectedColor,
      selectedSize: item.selectedSize,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
    );
  }

  OrderItemModel copyWith({
    String? productId,
    String? productName,
    String? productImage,
    String? selectedColor,
    String? selectedSize,
    int? quantity,
    double? unitPrice,
  }) {
    return OrderItemModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'product_image': productImage,
        'selected_color': selectedColor,
        'selected_size': selectedSize,
        'quantity': quantity,
        'unit_price': unitPrice,
      };

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      OrderItemModel(
        productId: (json['product_id'] as String?) ??
            (json['productId'] as String?) ??
            '',
        productName: (json['product_name'] as String?) ??
            (json['productName'] as String?) ??
            '',
        productImage: (json['product_image'] as String?) ??
            (json['productImage'] as String?) ??
            '',
        selectedColor: (json['selected_color'] as String?) ??
            (json['selectedColor'] as String?),
        selectedSize: (json['selected_size'] as String?) ??
            (json['selectedSize'] as String?) ??
            'S',
        quantity: (json['quantity'] as int?) ?? 1,
        unitPrice: ((json['unit_price'] ?? json['unitPrice']) as num?)
                ?.toDouble() ??
            0.0,
      );
}
