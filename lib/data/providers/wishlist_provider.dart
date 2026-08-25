import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/core/l10n/language_provider.dart';
import 'package:max/core/models/loadable_list_state.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/repositories/wishlist/wishlist_repository.dart';
import 'package:max/data/repositories/wishlist/supabase_wishlist_repository.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return SupabaseWishlistRepository();
});

class WishlistNotifier extends StateNotifier<LoadableListState<ProductModel>> {
  final WishlistRepository _repository;
  final String? _userId;

  WishlistNotifier(this._repository, {String? userId}) : _userId = userId, super(const LoadableListState()) {
    _load();
  }

  int? _parseProductId(String productId) {
    if (!productId.startsWith('p')) return null;
    final numericPart = productId.substring(1);
    return int.tryParse(numericPart);
  }

  Future<void> _load() async {
    if (!mounted) return;
    if (_userId == null) {
      state = const LoadableListState();
      return;
    }
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final items = await _repository.loadWishlist();
      if (!mounted) return;
      state = state.copyWith(items: items, isLoading: false);
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(
        items: [],
        isLoading: false,
        error: 'Could not load wishlist. Please try again.',
      );
    }
  }

  bool isWishlisted(String productId) {
    return state.items.any((p) => p.id == productId);
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

    // Optimistic update
    state = state.copyWith(items: [...state.items, product], clearError: true);
    _repository.addToWishlist(dbProductId).catchError((_) {
      // Rollback on failure
      if (mounted) {
        state = state.copyWith(
          items: state.items.where((p) => p.id != product.id).toList(),
          error: 'Could not add to wishlist. Please try again.',
        );
      }
    });
  }

  void remove(String productId) {
    final dbProductId = _parseProductId(productId);
    if (dbProductId == null) return;

    // Optimistic update
    final removedProduct = state.items.where((p) => p.id == productId).firstOrNull;
    state = state.copyWith(
      items: state.items.where((p) => p.id != productId).toList(),
      clearError: true,
    );
    _repository.removeFromWishlist(dbProductId).catchError((_) {
      // Rollback on failure
      if (mounted && removedProduct != null) {
        state = state.copyWith(
          items: [...state.items, removedProduct],
          error: 'Could not remove from wishlist. Please try again.',
        );
      }
    });
  }
}

final wishlistProvider = StateNotifierProvider<WishlistNotifier,
    LoadableListState<ProductModel>>((ref) {
  final repository = ref.watch(wishlistRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return WishlistNotifier(repository, userId: userId);
});

final localizedWishlistItemsProvider = Provider<List<ProductModel>>((ref) {
  final languageCode = ref.watch(localeProvider).languageCode;
  return ref
      .watch(wishlistProvider)
      .items
      .map((product) => product.localizedFor(languageCode))
      .toList();
});

final wishlistCountProvider = Provider<int>((ref) {
  return ref.watch(wishlistProvider).length;
});
