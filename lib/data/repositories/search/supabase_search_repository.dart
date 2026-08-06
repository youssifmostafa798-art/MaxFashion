import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/product/product_repository.dart';
import 'package:max/data/repositories/search/search_repository.dart';

class SupabaseSearchRepository implements SearchRepository {
  final ProductRepository _productRepo;

  SupabaseSearchRepository(this._productRepo);

  @override
  List<ProductModel> searchProducts(String query, {List<ProductModel>? source}) {
    final items = source ?? _productRepo.getAllProducts();
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return [];

    return items.where((p) {
      final searchable =
          '${p.name} ${p.description} ${p.brand}'.toLowerCase();
      return searchable.contains(trimmed);
    }).toList();
  }

  @override
  List<ProductModel> getPopularProducts() {
    return _productRepo.getAllProducts().take(4).toList();
  }

  @override
  List<ProductModel> getSuggestedProducts() {
    final all = _productRepo.getAllProducts();
    if (all.length <= 3) return all;
    return all.sublist(0, 3);
  }
}
