import 'package:max/data/models/product_model.dart';

abstract class ProductRepository {
  List<ProductModel> getAllProducts();
  List<ProductModel> getProductsByCategory(String category);
  List<ProductModel> getFeaturedProducts();
  List<ProductModel> getHomeProducts({int maxPerCategory = 2});
  ProductModel? getProductById(String id);
  List<ProductModel> searchProducts(String query);
}
