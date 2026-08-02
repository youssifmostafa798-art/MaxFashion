import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/data/models/product_model.dart';

const _wishlistKey = 'wishlist_ids';

class WishlistNotifier extends StateNotifier<List<ProductModel>> {
  WishlistNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_wishlistKey);
    if (raw == null) return;
    final List<String> ids =
        (jsonDecode(raw) as List).cast<String>();
    final idSet = ids.toSet();
    state = ProductModel.products
        .where((p) => idSet.contains(p.id))
        .toList();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = state.map((p) => p.id).toList();
    await prefs.setString(_wishlistKey, jsonEncode(ids));
  }

  bool isWishlisted(String productId) {
    return state.any((p) => p.id == productId);
  }

  void toggle(ProductModel product) {
    if (isWishlisted(product.id)) {
      remove(product.id);
    } else {
      add(product);
    }
  }

  void add(ProductModel product) {
    if (isWishlisted(product.id)) return;
    state = [...state, product];
    _save();
  }

  void remove(String productId) {
    state = state.where((p) => p.id != productId).toList();
    _save();
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<ProductModel>>((ref) {
  return WishlistNotifier();
});

final wishlistCountProvider = Provider<int>((ref) {
  return ref.watch(wishlistProvider).length;
});
