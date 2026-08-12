import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/wishlist/wishlist_repository.dart';
import 'package:max/data/repositories/wishlist/supabase_wishlist_repository.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return SupabaseWishlistRepository();
});

class WishlistNotifier extends StateNotifier<List<ProductModel>> {
  final WishlistRepository _repository;

  WishlistNotifier(this._repository) : super([]) {
    _load();
  }

  int? _parseProductId(String productId) {
    if (!productId.startsWith('p')) return null;
    final numericPart = productId.substring(1);
    return int.tryParse(numericPart);
  }

  Future<void> _load() async {
    try {
      state = await _repository.loadWishlist();
    } catch (_) {
      state = [];
    }
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
    final dbProductId = _parseProductId(product.id);
    if (dbProductId == null) return;
    state = [...state, product];
    _repository.addToWishlist(dbProductId);
  }

  void remove(String productId) {
    final dbProductId = _parseProductId(productId);
    if (dbProductId == null) return;
    state = state.where((p) => p.id != productId).toList();
    _repository.removeFromWishlist(dbProductId);
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<ProductModel>>((ref) {
  final repository = ref.watch(wishlistRepositoryProvider);
  return WishlistNotifier(repository);
});

final wishlistCountProvider = Provider<int>((ref) {
  return ref.watch(wishlistProvider).length;
});
