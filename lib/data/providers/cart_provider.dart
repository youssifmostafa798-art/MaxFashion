import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/cart_item_model.dart';
import 'package:max/data/repositories/cart/cart_repository.dart';
import 'package:max/data/repositories/cart/supabase_cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return SupabaseCartRepository();
});

class CartState {
  final List<CartItemModel> items;
  final bool isLoading;
  final String? error;
  final String? updatingItemId;
  final bool isClearing;
  final bool isAdding;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.updatingItemId,
    this.isClearing = false,
    this.isAdding = false,
  });

  CartState copyWith({
    List<CartItemModel>? items,
    bool? isLoading,
    String? error,
    String? updatingItemId,
    bool? isClearing,
    bool? isAdding,
    bool clearError = false,
    bool clearUpdatingItemId = false,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      updatingItemId:
          clearUpdatingItemId ? null : (updatingItemId ?? this.updatingItemId),
      isClearing: isClearing ?? this.isClearing,
      isAdding: isAdding ?? this.isAdding,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _repository;

  CartNotifier(this._repository) : super(const CartState()) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final items = await _repository.loadCart();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        items: [],
        isLoading: false,
        error: 'Could not load your cart. Please try again.',
      );
    }
  }

  Future<void> addItem(CartItemModel item) async {
    state = state.copyWith(isAdding: true, clearError: true);
    try {
      final added = await _repository.addItem(item);
      final currentItems = state.items;
      final index = currentItems.indexWhere(
        (e) =>
            e.productId == added.productId &&
            e.selectedSize == added.selectedSize,
      );
      List<CartItemModel> newItems;
      if (index != -1) {
        newItems = [
          ...currentItems.sublist(0, index),
          added,
          ...currentItems.sublist(index + 1),
        ];
      } else {
        newItems = [...currentItems, added];
      }
      state = state.copyWith(items: newItems, isAdding: false, clearError: true);
    } catch (e) {
      state = state.copyWith(
        isAdding: false,
        error: 'Could not add item to cart. Please try again.',
      );
    }
  }

  Future<void> removeItem(int productId, String? color, String? size) async {
    state = state.copyWith(clearError: true);
    try {
      final item = state.items.firstWhere(
        (e) =>
            e.productId == productId &&
            e.selectedColor == color &&
            e.selectedSize == size,
      );
      if (item.id == null) return;
      state = state.copyWith(updatingItemId: item.id);
      await _repository.removeItem(item.id!);
      final newItems = state.items
          .where(
            (e) =>
                !(e.productId == productId &&
                    e.selectedColor == color &&
                    e.selectedSize == size),
          )
          .toList();
      state = state.copyWith(
        items: newItems,
        clearUpdatingItemId: true,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        clearUpdatingItemId: true,
        error: 'Could not remove item. Please try again.',
      );
    }
  }

  Future<void> incrementQuantity(int index) async {
    if (index < 0 || index >= state.items.length) return;
    final item = state.items[index];
    if (item.id == null) return;
    state = state.copyWith(updatingItemId: item.id, clearError: true);
    try {
      final updated =
          await _repository.updateQuantity(item.id!, item.quantity + 1);
      final newItems = [
        ...state.items.sublist(0, index),
        updated,
        ...state.items.sublist(index + 1),
      ];
      state = state.copyWith(
        items: newItems,
        clearUpdatingItemId: true,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        clearUpdatingItemId: true,
        error: 'Could not update quantity. Please try again.',
      );
    }
  }

  Future<void> decrementQuantity(int index) async {
    if (index < 0 || index >= state.items.length) return;
    final item = state.items[index];
    if (item.quantity <= 1) return;
    if (item.id == null) return;
    state = state.copyWith(updatingItemId: item.id, clearError: true);
    try {
      final updated =
          await _repository.updateQuantity(item.id!, item.quantity - 1);
      final newItems = [
        ...state.items.sublist(0, index),
        updated,
        ...state.items.sublist(index + 1),
      ];
      state = state.copyWith(
        items: newItems,
        clearUpdatingItemId: true,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        clearUpdatingItemId: true,
        error: 'Could not update quantity. Please try again.',
      );
    }
  }

  Future<void> clear() async {
    state = state.copyWith(isClearing: true, clearError: true);
    try {
      await _repository.clearCart();
      state = state.copyWith(
        items: [],
        isClearing: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isClearing: false,
        error: 'Could not clear cart. Please try again.',
      );
    }
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, CartState>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return CartNotifier(repository);
});

final cartItemsProvider = Provider<List<CartItemModel>>((ref) {
  return ref.watch(cartProvider).items;
});

final cartSubtotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartItemsProvider);
  return items.fold(0.0, (sum, item) => sum + item.unitPrice * item.quantity);
});
