import 'package:max/data/models/product_model.dart';

abstract class SearchRepository {
  List<ProductModel> searchProducts(String query, {List<ProductModel>? source});
  List<ProductModel> getPopularProducts();
  List<ProductModel> getSuggestedProducts();
}
