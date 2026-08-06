import 'package:max/data/datasources/local/local_product_data_source.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/product/product_repository.dart';
import 'package:max/data/repositories/product/product_search_matcher.dart';

class LocalProductRepository implements ProductRepository {
  final LocalProductDataSource _dataSource;

  LocalProductRepository(this._dataSource);

  @override
  List<ProductModel> getAllProducts() {
    return _dataSource.products;
  }

  @override
  List<ProductModel> getProductsByCategory(String category) {
    return _dataSource.products
        .where((p) => p.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  List<ProductModel> getFeaturedProducts() {
    return _dataSource.products.where((p) => p.featured).toList();
  }

  @override
  ProductModel? getProductById(String id) {
    try {
      return _dataSource.products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<ProductModel> searchProducts(String query) {
    return ProductSearchMatcher.filterProducts(_dataSource.products, query);
  }
}
