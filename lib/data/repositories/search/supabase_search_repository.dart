import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/data/models/product_image_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/models/product_size_model.dart';
import 'package:max/data/repositories/search/search_repository.dart';

class SupabaseSearchRepository implements SearchRepository {
  SupabaseSearchRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

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

    return ProductModel(
      id: 'p${row['id']}',
      categoryId: row['category_id'] as int,
      name: row['name'] as String? ?? '',
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

  @override
  Future<SearchResult> searchProducts(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return const SearchResult(products: [], totalCount: 0);
    }

    final response = await _client.rpc('search_products', params: {
      'p_query': trimmed,
      'p_limit': limit,
      'p_offset': offset,
    });

    final rows = response as List;
    if (rows.isEmpty) {
      return const SearchResult(products: [], totalCount: 0);
    }

    final totalCount = (rows.first as Map<String, dynamic>)['total_count'] as int;

    final productIds = rows
        .map((row) => (row as Map<String, dynamic>)['id'] as int)
        .toList();

    final enrichedResponse = await _client
        .from('products')
        .select(_selectWithRelations)
        .inFilter('id', productIds);

    final enrichedRows = enrichedResponse as List;
    final enrichedMap = <int, Map<String, dynamic>>{};
    for (final row in enrichedRows) {
      final r = row as Map<String, dynamic>;
      enrichedMap[r['id'] as int] = r;
    }

    final products = productIds
        .map((id) => _mapRowToModel(enrichedMap[id]!))
        .toList();

    return SearchResult(products: products, totalCount: totalCount);
  }

  @override
  Future<List<ProductModel>> getPopularProducts() async {
    final response = await _client
        .from('products')
        .select(_selectWithRelations)
        .eq('is_available', true)
        .eq('is_featured', true)
        .limit(4);

    return (response as List)
        .map((row) => _mapRowToModel(row as Map<String, dynamic>))
        .toList();
  }
}
