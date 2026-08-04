import 'package:max/data/models/product_model.dart';

class ProductSearchMatcher {
  const ProductSearchMatcher._();

  static bool matchesQuery(ProductModel product, String trimmedQuery) {
    final name = product.name.toLowerCase();
    final category = product.category.toLowerCase();
    final collection = product.collection.toLowerCase();
    final description = product.description.toLowerCase();
    final keywords = product.keywords.map((k) => k.toLowerCase()).join(' ');
    final searchable = '$name $category $collection $description $keywords';

    return searchable.contains(trimmedQuery);
  }

  static List<ProductModel> filterProducts(
    List<ProductModel> products,
    String query,
  ) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return [];

    return products.where((product) => matchesQuery(product, trimmed)).toList();
  }
}
