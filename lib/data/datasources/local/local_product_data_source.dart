import 'dart:convert';
import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_image_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/models/product_size_model.dart';

class LocalProductDataSource {
  List<CategoryModel> _categories = [];
  List<ProductModel> _products = [];

  UnmodifiableListView<CategoryModel> get categories =>
      UnmodifiableListView(_categories);

  UnmodifiableListView<ProductModel> get products =>
      UnmodifiableListView(_products);

  Future<void> load() async {
    final results = await Future.wait([
      rootBundle.loadString('assets/data/categories.json'),
      rootBundle.loadString('assets/data/products.json'),
      rootBundle.loadString('assets/data/product_images.json'),
      rootBundle.loadString('assets/data/product_sizes.json'),
    ]);

    _categories = (jsonDecode(results[0]) as List)
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final rawProducts = (jsonDecode(results[1]) as List)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final images = (jsonDecode(results[2]) as List)
        .map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final imagesByProductId = <int, List<ProductImageModel>>{};
    for (final img in images) {
      imagesByProductId.putIfAbsent(img.productId, () => []).add(img);
    }

    final sizes = (jsonDecode(results[3]) as List)
        .map((e) => ProductSizeModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final sizesByProductId = <int, List<ProductSizeModel>>{};
    for (final size in sizes) {
      sizesByProductId.putIfAbsent(size.productId, () => []).add(size);
    }

    _products = rawProducts.map((p) {
      final rawId = int.tryParse(p.id.substring(1)) ?? 0;
      return p.copyWith(
        productImages: imagesByProductId[rawId] ?? [],
        productSizes: sizesByProductId[rawId] ?? [],
      );
    }).toList();
  }
}
