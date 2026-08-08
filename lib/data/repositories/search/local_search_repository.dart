import 'package:max/data/datasources/local/local_product_data_source.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/search/search_repository.dart';
import 'package:max/data/repositories/product/product_search_matcher.dart';

class LocalSearchRepository implements SearchRepository {
  final LocalProductDataSource _dataSource;

  LocalSearchRepository(this._dataSource);

  @override
  List<ProductModel> searchProducts(
    String query, {
    List<ProductModel>? source,
    List<CategoryModel> categories = const [],
  }) {
    final items = source ?? _dataSource.products;
    return ProductSearchMatcher.filterProducts(items, query, categories: categories);
  }

  @override
  List<ProductModel> getPopularProducts() {
    return _dataSource.products.take(4).toList();
  }

  @override
  List<ProductModel> getSuggestedProducts() {
    final all = _dataSource.products;
    if (all.length <= 3) return all;
    return all.sublist(0, 3);
  }
}
