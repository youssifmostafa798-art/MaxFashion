import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/product/product_repository.dart';
import 'package:max/data/repositories/product/supabase_product_repository.dart';

class ProductsLoadState {
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final bool isLoading;
  final String? error;

  const ProductsLoadState({
    this.products = const [],
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  bool get isLoaded => !isLoading && error == null;

  ProductsLoadState copyWith({
    List<ProductModel>? products,
    List<CategoryModel>? categories,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ProductsLoadState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

String categoryNameById(List<CategoryModel> categories, int categoryId) {
  for (final c in categories) {
    if (c.id == categoryId) return c.name;
  }
  return '';
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final repo = SupabaseProductRepository();
  ref.onDispose(() => repo);
  return repo;
});

class ProductsNotifier extends StateNotifier<ProductsLoadState> {
  final ProductRepository _repository;

  ProductsNotifier(this._repository) : super(const ProductsLoadState()) {
    loadAll();
  }

  Future<void> loadAll() async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _repository.loadAll();
      if (!mounted) return;
      state = state.copyWith(
        products: _repository.getAllProducts(),
        categories: _repository.categories,
        isLoading: false,
      );
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: 'Could not load products. Please try again.',
      );
    }
  }
}

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsLoadState>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductsNotifier(repo);
});

final productsLoaded = Provider<bool>((ref) {
  return ref.watch(productsProvider).isLoaded;
});

final categoriesProvider = Provider<List<CategoryModel>>((ref) {
  return ref.watch(productsProvider).categories;
});

final allProductsProvider = Provider<List<ProductModel>>((ref) {
  return ref.watch(productsProvider).products;
});

final categoryProductsProvider = Provider.family<List<ProductModel>, String>((
  ref,
  category,
) {
  final products = ref.watch(allProductsProvider);
  final categories = ref.watch(categoriesProvider);
  return products.where((p) {
    final name = categoryNameById(categories, p.categoryId);
    return name.toLowerCase() == category.toLowerCase();
  }).toList();
});

final selectedCategoryProvider = StateProvider<int?>((ref) => null);

final shuffledProductsProvider = Provider<List<ProductModel>>((ref) {
  final products = ref.watch(allProductsProvider);
  final shuffled = List<ProductModel>.from(products);
  shuffled.shuffle(Random());
  return shuffled;
});

final sessionSuggestedProductsProvider = Provider<List<ProductModel>>((ref) {
  final products = ref.watch(shuffledProductsProvider);
  return products.take(10).toList();
});

final filteredHomeProductsProvider = Provider<List<ProductModel>>((ref) {
  final selectedCategoryId = ref.watch(selectedCategoryProvider);
  final products = ref.watch(shuffledProductsProvider);

  if (selectedCategoryId == null) return products;

  return products.where((p) => p.categoryId == selectedCategoryId).toList();
});
