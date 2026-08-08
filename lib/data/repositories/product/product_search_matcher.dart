import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_model.dart';

class ProductSearchMatcher {
  const ProductSearchMatcher._();

  static String _categoryName(List<CategoryModel> categories, int categoryId) {
    for (final c in categories) {
      if (c.id == categoryId) return c.name;
    }
    return '';
  }

  static bool matchesQuery(
    ProductModel product,
    String trimmedQuery, {
    List<CategoryModel> categories = const [],
  }) {
    final name = product.name.toLowerCase();
    final category = _categoryName(categories, product.categoryId).toLowerCase();
    final collection = product.collection.toLowerCase();
    final description = product.description.toLowerCase();
    final keywords = product.keywords.map((k) => k.toLowerCase()).join(' ');
    final searchable = '$name $category $collection $description $keywords';

    return searchable.contains(trimmedQuery);
  }

  static List<ProductModel> filterProducts(
    List<ProductModel> products,
    String query, {
    List<CategoryModel> categories = const [],
  }) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return [];

    return products
        .where((product) => matchesQuery(product, trimmed, categories: categories))
        .toList();
  }
}
