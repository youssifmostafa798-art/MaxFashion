import 'package:max/data/models/product_model.dart';

class SearchResultModel {
  final List<ProductModel> products;
  final String query;

  const SearchResultModel({
    required this.products,
    required this.query,
  });
}
