import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/product/product_repository.dart';
import 'package:max/data/repositories/product/local_product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return LocalProductRepository();
});

final allProductsProvider = Provider<List<ProductModel>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getAllProducts();
});

final featuredProductsProvider = Provider<List<ProductModel>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getFeaturedProducts();
});

final categoryProductsProvider =
    Provider.family<List<ProductModel>, String>((ref, category) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProductsByCategory(category);
});

final productByIdProvider =
    Provider.family<ProductModel?, String>((ref, id) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProductById(id);
});
