import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/repositories/search/search_repository.dart';

class SupabaseSearchRepository implements SearchRepository {
  SupabaseSearchRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  ProductModel _mapRowToModel(Map<String, dynamic> row) {
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
      productImages: const [],
      productSizes: const [],
    );
  }

  @override
  Future<SearchResult> searchProducts(
    String query, {
    String locale = AppConstants.fallbackLanguageCode,
    int limit = 20,
    int offset = 0,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return const SearchResult(products: [], totalCount: 0);
    }

    final response = await _client.rpc('search_products', params: {
      'p_query': trimmed,
      'p_locale': locale,
      'p_limit': limit,
      'p_offset': offset,
    });

    final rows = response as List;
    if (rows.isEmpty) {
      return const SearchResult(products: [], totalCount: 0);
    }

    final totalCount = (rows.first as Map<String, dynamic>)['total_count'] as int;
    final products = rows
        .map((row) => _mapRowToModel(row as Map<String, dynamic>))
        .toList();

    return SearchResult(products: products, totalCount: totalCount);
  }

  @override
  Future<List<ProductModel>> getPopularProducts() async {
    final response = await _client
        .from('products')
        .select('id, category_id, name, description, price, discount_price, '
            'brand, thumbnail_url, is_featured, is_available')
        .eq('is_available', true)
        .eq('is_featured', true)
        .limit(4);

    return (response as List)
        .map((row) => _mapRowToModel(row as Map<String, dynamic>))
        .toList();
  }
}
