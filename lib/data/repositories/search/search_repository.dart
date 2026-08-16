import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_model.dart';

abstract class SearchRepository {
  List<ProductModel> searchProducts(
    String query, {
    List<ProductModel>? source,
    List<CategoryModel> categories = const [],
  });
  List<ProductModel> getPopularProducts();
}
