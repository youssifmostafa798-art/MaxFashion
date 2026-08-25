import 'package:max/core/constants/app_constants.dart';
import 'package:max/data/models/product_model.dart';

class SearchResult {
  final List<ProductModel> products;
  final int totalCount;

  const SearchResult({required this.products, required this.totalCount});
}

abstract class SearchRepository {
  Future<SearchResult> searchProducts(
    String query, {
    String locale = AppConstants.fallbackLanguageCode,
    int limit = 20,
    int offset = 0,
  });

  Future<List<ProductModel>> getPopularProducts();
}
