import 'package:max/data/datasources/local/local_product_data_source.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/product/product_repository.dart';
import 'package:max/data/repositories/product/product_search_matcher.dart';

class LocalProductRepository implements ProductRepository {
  final LocalProductDataSource _dataSource;

  LocalProductRepository(this._dataSource);

  @override
  List<CategoryModel> get categories => _dataSource.categories;

  @override
  List<ProductModel> getAllProducts() {
    return _dataSource.products;
  }

  String _categoryName(List<CategoryModel> categories, int categoryId) {
    for (final c in categories) {
      if (c.id == categoryId) return c.name;
    }
    return '';
  }

  @override
  List<ProductModel> getProductsByCategory(
    String category, {
    List<CategoryModel> categories = const [],
  }) {
    return _dataSource.products.where((p) {
      final name = _categoryName(categories, p.categoryId);
      return name.toLowerCase() == category.toLowerCase();
    }).toList();
  }

  @override
  List<ProductModel> getFeaturedProducts() {
    return _dataSource.products.where((p) => p.featured).toList();
  }

  @override
  List<ProductModel> getHomeProducts({
    List<CategoryModel> categories = const [],
    int maxPerCategory = 2,
  }) {
    final Map<String, List<ProductModel>> byCategory = {};
    for (final p in _dataSource.products) {
      final cat = _categoryName(categories, p.categoryId);
      if (cat.isEmpty) continue;
      byCategory.putIfAbsent(cat, () => []).add(p);
    }

    final result = <ProductModel>[];
    for (final entry in byCategory.entries) {
      final featured = entry.value.where((p) => p.featured).toList();
      final pool = featured.isNotEmpty ? featured : entry.value;
      result.addAll(pool.take(maxPerCategory));
    }
    return result;
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
  List<ProductModel> searchProducts(
    String query, {
    List<CategoryModel> categories = const [],
  }) {
    return ProductSearchMatcher.filterProducts(
      _dataSource.products,
      query,
      categories: categories,
    );
  }
}
