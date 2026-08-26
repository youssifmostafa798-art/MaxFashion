import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_image_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/models/product_size_model.dart';
import 'package:max/data/repositories/product/product_repository.dart';

class SupabaseProductRepository implements ProductRepository {
  SupabaseProductRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  List<ProductModel> _productsCache = [];
  List<CategoryModel> _categoriesCache = [];

  List<ProductModel> get products => _productsCache;
  @override
  List<CategoryModel> get categories => _categoriesCache;

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

  Future<void> loadCategories() async {
    final response = await _client
        .from('categories')
        .select('id, name, slug, icon_name, display_order, is_active')
        .order('display_order');

    _categoriesCache = (response as List)
        .map((row) => CategoryModel.fromJson(row as Map<String, dynamic>))
        .where((c) => c.isActive)
        .toList();
  }

  @override
  Future<void> loadAll() async {
    await loadCategories();

    final response = await _client
        .from('products')
        .select(_selectWithRelations)
        .order('id');

    _productsCache =
        (response as List).map((row) => _mapRowToModel(row as Map<String, dynamic>)).toList();
  }

  @override
  List<ProductModel> getAllProducts() => _productsCache;
}
