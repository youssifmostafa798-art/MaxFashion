import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/search/search_repository.dart';

class LocalSearchRepository implements SearchRepository {
  @override
  List<ProductModel> searchProducts(String query, {List<ProductModel>? source}) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return [];

    final items = source ?? ProductModel.allProducts();

    return items.where((product) {
      final name = product.name.toLowerCase();
      final category = product.category.toLowerCase();
      final collection = product.collection.toLowerCase();
      final description = product.descrp.toLowerCase();
      final keywords = product.keywords.map((k) => k.toLowerCase()).join(' ');
      final searchable = '$name $category $collection $description $keywords';

      return searchable.contains(trimmed);
    }).toList();
  }

  @override
  List<ProductModel> getPopularProducts() {
    return ProductModel.allProducts().take(4).toList();
  }

  @override
  List<ProductModel> getSuggestedProducts() {
    final all = ProductModel.allProducts();
    if (all.length <= 3) return all;
    return all.sublist(0, 3);
  }
}
