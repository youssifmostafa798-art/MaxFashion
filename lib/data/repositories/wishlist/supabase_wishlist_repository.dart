import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/data/models/product_image_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/models/product_size_model.dart';

import 'package:max/data/repositories/wishlist/wishlist_repository.dart';

class SupabaseWishlistRepository implements WishlistRepository {
  SupabaseWishlistRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _selectWithProduct = '''
    id, user_id, product_id, created_at,
    products(
      id, category_id, name, description, price, discount_price,
      brand, thumbnail_url, is_featured, is_available,
      product_images(id, product_id, image_url, sort_order),
      product_sizes(product_id, size, stock)
    )
  ''';

  ProductModel _mapRowToModel(Map<String, dynamic> row) {
    final product = row['products'] as Map<String, dynamic>?;
    if (product == null) {
      throw Exception('Product data not found for wishlist item');
    }

    final images = (product['product_images'] as List?)
            ?.map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final sizes = (product['product_sizes'] as List?)
            ?.map((e) => ProductSizeModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return ProductModel(
      id: 'p${product['id']}',
      categoryId: product['category_id'] as int,
      name: product['name'] as String? ?? '',
      description: product['description'] as String? ?? '',
      price: (product['price'] as num).toDouble(),
      discountPrice: product['discount_price'] != null
          ? (product['discount_price'] as num).toDouble()
          : null,
      brand: product['brand'] as String? ?? 'MaxFashion',
      thumbnailUrl: product['thumbnail_url'] as String? ?? '',
      isFeatured: product['is_featured'] as bool? ?? false,
      isAvailable: product['is_available'] as bool? ?? true,
      productImages: images,
      productSizes: sizes,
    );
  }

  String? _getUserId() {
    return _client.auth.currentUser?.id;
  }

  @override
  Future<List<ProductModel>> loadWishlist() async {
    final userId = _getUserId();
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client
        .from('wishlist_items')
        .select(_selectWithProduct)
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((row) => _mapRowToModel(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addToWishlist(int productId) async {
    final userId = _getUserId();
    if (userId == null) throw Exception('User not authenticated');

    final existing = await _client
        .from('wishlist_items')
        .select('id')
        .eq('user_id', userId)
        .eq('product_id', productId)
        .maybeSingle();

    if (existing != null) return;

    await _client.from('wishlist_items').insert({
      'user_id': userId,
      'product_id': productId,
    });
  }

  @override
  Future<void> removeFromWishlist(int productId) async {
    final userId = _getUserId();
    if (userId == null) throw Exception('User not authenticated');

    await _client
        .from('wishlist_items')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', productId);
  }

  @override
  Future<bool> isProductWishlisted(int productId) async {
    final userId = _getUserId();
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client
        .from('wishlist_items')
        .select('id')
        .eq('user_id', userId)
        .eq('product_id', productId)
        .maybeSingle();

    return response != null;
  }
}
