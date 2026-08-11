import 'package:max/data/models/cart_item_model.dart';

abstract class CartRepository {
  Future<List<CartItemModel>> loadCart();
  Future<CartItemModel> addItem(CartItemModel item);
  Future<CartItemModel> updateQuantity(String cartItemId, int quantity);
  Future<void> removeItem(String cartItemId);
  Future<void> clearCart();
}
