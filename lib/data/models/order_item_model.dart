import 'package:max/data/models/cart_item_model.dart';

class OrderItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final String? selectedColor;
  final String? selectedSize;
  final int quantity;
  final double unitPrice;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    this.selectedColor,
    this.selectedSize,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => unitPrice * quantity;

  factory OrderItemModel.fromCartItem(CartItemModel item) {
    return OrderItemModel(
      productId: item.productId,
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
        'productId': productId,
        'productName': productName,
        'productImage': productImage,
        'selectedColor': selectedColor,
        'selectedSize': selectedSize,
        'quantity': quantity,
        'unitPrice': unitPrice,
      };

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      OrderItemModel(
        productId: json['productId'] as String,
        productName: json['productName'] as String,
        productImage: json['productImage'] as String,
        selectedColor: json['selectedColor'] as String?,
        selectedSize: json['selectedSize'] as String?,
        quantity: json['quantity'] as int,
        unitPrice: (json['unitPrice'] as num).toDouble(),
      );
}
