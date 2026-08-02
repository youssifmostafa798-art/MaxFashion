import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/product/product_repository.dart';

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
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return [];

    return ProductModel.products.where((product) {
      final name = product.name.toLowerCase();
      final category = product.category.toLowerCase();
      final collection = product.collection.toLowerCase();
      final description = product.description.toLowerCase();
      final keywords = product.keywords.map((k) => k.toLowerCase()).join(' ');
      final searchable = '$name $category $collection $description $keywords';

      return searchable.contains(trimmed);
    }).toList();
  }
}
