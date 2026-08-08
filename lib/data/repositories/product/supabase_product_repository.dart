import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/data/models/product_image_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/models/product_size_model.dart';
import 'package:max/data/repositories/product/product_repository.dart';

class SupabaseProductRepository implements ProductRepository {
  SupabaseProductRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  List<ProductModel> _productsCache = [];

  List<ProductModel> get products => _productsCache;

  static const _selectWithRelations =
      'id, category_id, name, description, price, discount_price, '
      'brand, thumbnail_url, is_featured, is_available, '
      'product_images(id, product_id, image_url, sort_order), '
      'product_sizes(product_id, size, stock)';

  ProductModel _mapRowToModel(Map<String, dynamic> row) {
    final images = (row['product_images'] as List?)
            ?.map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final sizes = (row['product_sizes'] as List?)
            ?.map((e) => ProductSizeModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final categoryId = row['category_id'] as int;

    return ProductModel(
      id: 'p${row['id']}',
      categoryId: categoryId,
      name: row['name'] as String,
      description: row['description'] as String? ?? '',
      price: (row['price'] as num).toDouble(),
      discountPrice: row['discount_price'] != null
          ? (row['discount_price'] as num).toDouble()
          : null,
      brand: row['brand'] as String? ?? 'MaxFashion',
      thumbnailUrl: row['thumbnail_url'] as String? ?? '',
      isFeatured: row['is_featured'] as bool? ?? false,
      isAvailable: row['is_available'] as bool? ?? true,
      productImages: images,
      productSizes: sizes,
    );
  }

  Future<void> loadAll() async {
    final response = await _client
        .from('products')
        .select(_selectWithRelations)
        .order('id');

    _productsCache =
        (response as List).map((row) => _mapRowToModel(row as Map<String, dynamic>)).toList();
  }

  @override
  List<ProductModel> getAllProducts() => _productsCache;

  @override
  List<ProductModel> getProductsByCategory(String category) {
    return _productsCache
        .where((p) => p.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  List<ProductModel> getFeaturedProducts() {
    return _productsCache.where((p) => p.featured).toList();
  }

  @override
  List<ProductModel> getHomeProducts({int maxPerCategory = 2}) {
    final Map<String, List<ProductModel>> byCategory = {};
    for (final p in _productsCache) {
      final cat = p.category;
      if (cat.isEmpty) continue;
      byCategory.putIfAbsent(cat, () => []).add(p);
    }

    final result = <ProductModel>[];
    for (final entry in byCategory.entries) {
      final featured = entry.value.where((p) => p.featured).toList();
      final pool = featured.isNotEmpty ? featured : entry.value;
      result.addAll(pool.take(maxPerCategory));
    }
    return result;
  }

  @override
  ProductModel? getProductById(String id) {
    try {
      return _productsCache.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<ProductModel> searchProducts(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return [];

    return _productsCache.where((p) {
      final searchable =
          '${p.name} ${p.description} ${p.brand}'.toLowerCase();
      return searchable.contains(trimmed);
    }).toList();
  }
}
