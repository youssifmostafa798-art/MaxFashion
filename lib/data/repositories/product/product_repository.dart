import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_model.dart';

abstract class ProductRepository {
  List<CategoryModel> get categories;
  Future<void> loadAll();
  List<ProductModel> getAllProducts();
}
