import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_model.dart';

abstract class ProductRepository {
  List<CategoryModel> get categories;
  List<ProductModel> getAllProducts();
  List<ProductModel> getProductsByCategory(
    String category, {
    List<CategoryModel> categories = const [],
  });
  List<ProductModel> getFeaturedProducts();
  List<ProductModel> getHomeProducts({
    List<CategoryModel> categories = const [],
    int maxPerCategory = 2,
  });
  ProductModel? getProductById(String id);
  List<ProductModel> searchProducts(
    String query, {
    List<CategoryModel> categories = const [],
  });
}
