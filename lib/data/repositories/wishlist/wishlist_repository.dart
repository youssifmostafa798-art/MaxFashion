import 'package:max/data/models/product_model.dart';

abstract class WishlistRepository {
  Future<List<ProductModel>> loadWishlist();
  Future<void> addToWishlist(int productId);
  Future<void> removeFromWishlist(int productId);
  Future<bool> isProductWishlisted(int productId);
}
