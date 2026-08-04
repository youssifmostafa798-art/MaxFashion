import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/product/product_repository.dart';
import 'package:max/data/repositories/product/product_search_matcher.dart';

class LocalProductRepository implements ProductRepository {
  @override
  List<ProductModel> getAllProducts() {
    return ProductModel.products;
  }

  @override
  List<ProductModel> getProductsByCategory(String category) {
    return ProductModel.products
        .where((p) => p.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  List<ProductModel> getFeaturedProducts() {
    return ProductModel.products.where((p) => p.featured).toList();
  }

  @override
  ProductModel? getProductById(String id) {
    try {
      return ProductModel.products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<ProductModel> searchProducts(String query) {
    return ProductSearchMatcher.filterProducts(ProductModel.products, query);
  }
}
