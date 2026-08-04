import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/search/search_repository.dart';
import 'package:max/data/repositories/product/product_search_matcher.dart';

class LocalSearchRepository implements SearchRepository {
  @override
  List<ProductModel> searchProducts(String query, {List<ProductModel>? source}) {
    final items = source ?? ProductModel.products;
    return ProductSearchMatcher.filterProducts(items, query);
  }

  @override
  List<ProductModel> getPopularProducts() {
    return ProductModel.products.take(4).toList();
  }

  @override
  List<ProductModel> getSuggestedProducts() {
    final all = ProductModel.products;
    if (all.length <= 3) return all;
    return all.sublist(0, 3);
  }
}
