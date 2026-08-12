import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/data/models/cart_item_model.dart';
import 'package:max/data/repositories/cart/cart_repository.dart';

class SupabaseCartRepository implements CartRepository {
  SupabaseCartRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const String _storageBaseUrl =
      'https://tonctmdcntftugdskqmb.supabase.co/storage/v1/object/public/product-images';

  static const _selectWithProduct = '''
    id, user_id, product_id, size, quantity, created_at, updated_at,
    products(
      name, thumbnail_url, price, discount_price
    )
  ''';

  String _buildImageUrl(String? thumbnailUrl) {
    if (thumbnailUrl == null || thumbnailUrl.isEmpty) return '';
    if (thumbnailUrl.startsWith('http')) return thumbnailUrl;
    return '$_storageBaseUrl/$thumbnailUrl';
  }

  String? _sizeForDb(String selectedSize) {
    return selectedSize.isEmpty ? null : selectedSize;
  }

  String _sizeFromDb(String? dbSize) {
    return dbSize ?? '';
  }

  CartItemModel _mapRowToModel(Map<String, dynamic> row) {
    final product = row['products'] as Map<String, dynamic>?;
    final productName = product?['name'] as String? ?? '';
    final thumbnailUrl = product?['thumbnail_url'] as String?;
    final price = (product?['price'] as num?)?.toDouble() ?? 0.0;
    final discountPrice = product?['discount_price'] != null
        ? (product?['discount_price'] as num).toDouble()
        : null;

    return CartItemModel(
      id: row['id'] as String,
      productId: row['product_id'] as int,
      productName: productName,
      productImage: _buildImageUrl(thumbnailUrl),
      selectedSize: _sizeFromDb(row['size'] as String?),
      quantity: row['quantity'] as int,
      unitPrice: discountPrice ?? price,
      createdAt: row['created_at'] != null
          ? DateTime.parse(row['created_at'] as String)
          : null,
      updatedAt: row['updated_at'] != null
          ? DateTime.parse(row['updated_at'] as String)
          : null,
    );
  }

  @override
  Future<List<CartItemModel>> loadCart() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client
        .from('cart_items')
        .select(_selectWithProduct)
        .eq('user_id', userId)
        .order('created_at');

    return (response as List)
        .map((row) => _mapRowToModel(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CartItemModel> addItem(CartItemModel item) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final existing = await _findExistingItem(
      productId: item.productId,
      selectedSize: item.selectedSize,
    );

    if (existing != null) {
      final newQuantity = existing.quantity + item.quantity;
      return updateQuantity(existing.id!, newQuantity);
    }

    final response = await _client
        .from('cart_items')
        .insert({
          'user_id': userId,
          'product_id': item.productId,
          'size': _sizeForDb(item.selectedSize),
          'quantity': item.quantity,
        })
        .select(_selectWithProduct)
        .single();

    return _mapRowToModel(response);
  }

  @override
  Future<CartItemModel> updateQuantity(String cartItemId, int quantity) async {
    if (quantity < 1) throw Exception('Quantity must be at least 1');

    final response = await _client
        .from('cart_items')
        .update({
          'quantity': quantity,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', cartItemId)
        .select(_selectWithProduct)
        .single();

    return _mapRowToModel(response);
  }

  @override
  Future<void> removeItem(String cartItemId) async {
    await _client.from('cart_items').delete().eq('id', cartItemId);
  }

  @override
  Future<void> clearCart() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _client.from('cart_items').delete().eq('user_id', userId);
  }

  Future<CartItemModel?> _findExistingItem({
    required int productId,
    required String selectedSize,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final dbSize = _sizeForDb(selectedSize);

    var query = _client
        .from('cart_items')
        .select(_selectWithProduct)
        .eq('user_id', userId)
        .eq('product_id', productId);

    if (dbSize != null) {
      query = query.eq('size', dbSize);
    } else {
      query = query.filter('size', 'is', null);
    }

    final response = await query.maybeSingle();
    if (response == null) return null;

    return _mapRowToModel(response);
  }
}
