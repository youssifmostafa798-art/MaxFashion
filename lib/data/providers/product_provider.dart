import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/product/product_repository.dart';
import 'package:max/data/repositories/product/supabase_product_repository.dart';

final categoriesProvider = Provider<List<CategoryModel>>((ref) {
  ref.watch(productsLoaded);
  final repo = ref.watch(productRepositoryProvider);
  return repo.categories;
});

String categoryNameById(List<CategoryModel> categories, int categoryId) {
  for (final c in categories) {
    if (c.id == categoryId) return c.name;
  }
  return '';
}

final productsLoaded = StateProvider<bool>((ref) => false);

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final repo = SupabaseProductRepository();
  repo.loadAll().then((_) {
    ref.read(productsLoaded.notifier).state = true;
  });
  return repo;
});

final allProductsProvider = Provider<List<ProductModel>>((ref) {
  ref.watch(productsLoaded);
  final repo = ref.watch(productRepositoryProvider);
  return repo.getAllProducts();
});

final categoryProductsProvider = Provider.family<List<ProductModel>, String>((
  ref,
  category,
) {
  ref.watch(productsLoaded);
  final repo = ref.watch(productRepositoryProvider);
  final categories = ref.watch(categoriesProvider);
  return repo.getProductsByCategory(category, categories: categories);
});

final selectedCategoryProvider = StateProvider<int?>((ref) => null);

final shuffledProductsProvider = Provider<List<ProductModel>>((ref) {
  ref.watch(productsLoaded);
  final products = ref.watch(allProductsProvider);
  final shuffled = List<ProductModel>.from(products);
  shuffled.shuffle(Random());
  return shuffled;
});

final sessionSuggestedProductsProvider = Provider<List<ProductModel>>((ref) {
  ref.watch(productsLoaded);
  final products = ref.watch(shuffledProductsProvider);
  return products.take(10).toList();
});

final filteredHomeProductsProvider = Provider<List<ProductModel>>((ref) {
  final selectedCategoryId = ref.watch(selectedCategoryProvider);
  final products = ref.watch(shuffledProductsProvider);

  if (selectedCategoryId == null) return products;

  return products.where((p) => p.categoryId == selectedCategoryId).toList();
});
