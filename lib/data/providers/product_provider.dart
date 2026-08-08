import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/datasources/local/local_product_data_source.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/product/product_repository.dart';
import 'package:max/data/repositories/product/supabase_product_repository.dart';

final localProductDataSourceProvider = Provider<LocalProductDataSource>((ref) {
  final ds = LocalProductDataSource();
  ds.load();
  return ds;
});

final categoriesProvider = Provider<List<CategoryModel>>((ref) {
  final ds = ref.watch(localProductDataSourceProvider);
  return ds.categories;
});

final _productsLoaded = StateProvider<bool>((ref) => false);

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final repo = SupabaseProductRepository();
  repo.loadAll().then((_) {
    ref.read(_productsLoaded.notifier).state = true;
  });
  return repo;
});

final allProductsProvider = Provider<List<ProductModel>>((ref) {
  ref.watch(_productsLoaded);
  final repo = ref.watch(productRepositoryProvider);
  return repo.getAllProducts();
});

final featuredProductsProvider = Provider<List<ProductModel>>((ref) {
  ref.watch(_productsLoaded);
  final repo = ref.watch(productRepositoryProvider);
  return repo.getFeaturedProducts();
});

final homeProductsProvider = Provider<List<ProductModel>>((ref) {
  ref.watch(_productsLoaded);
  final repo = ref.watch(productRepositoryProvider);
  return repo.getHomeProducts(maxPerCategory: 2);
});

final categoryProductsProvider =
    Provider.family<List<ProductModel>, String>((ref, category) {
  ref.watch(_productsLoaded);
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProductsByCategory(category);
});
