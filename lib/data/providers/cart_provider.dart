import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/cart_item_model.dart';

class CartNotifier extends StateNotifier<List<CartItemModel>> {
  CartNotifier() : super([]);

  void addItem(CartItemModel item) {
    final existingIndex = state.indexWhere(
      (e) =>
          e.productId == item.productId &&
          e.selectedColor == item.selectedColor &&
          e.selectedSize == item.selectedSize,
    );

    if (existingIndex != -1) {
      final existing = state[existingIndex];
      state = [
        ...state.sublist(0, existingIndex),
        existing.copyWith(quantity: existing.quantity + item.quantity),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, item];
    }
  }

  void removeItem(String productId, String? color, String? size) {
    state = state
        .where(
          (e) =>
              !(e.productId == productId &&
                  e.selectedColor == color &&
                  e.selectedSize == size),
        )
        .toList();
  }

  void incrementQuantity(int index) {
    if (index < 0 || index >= state.length) return;
    final item = state[index];
    state = [
      ...state.sublist(0, index),
      item.copyWith(quantity: item.quantity + 1),
      ...state.sublist(index + 1),
    ];
  }

  void decrementQuantity(int index) {
    if (index < 0 || index >= state.length) return;
    final item = state[index];
    if (item.quantity <= 1) return;
    state = [
      ...state.sublist(0, index),
      item.copyWith(quantity: item.quantity - 1),
      ...state.sublist(index + 1),
    ];
  }

  void clear() => state = [];
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItemModel>>((ref) {
  return CartNotifier();
});

final cartSubtotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0.0, (sum, item) => sum + item.unitPrice * item.quantity);
});

final cartTotalProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  return subtotal;
});
