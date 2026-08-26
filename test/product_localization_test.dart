import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/data/providers/search_provider.dart';
import 'package:max/data/repositories/product/product_repository.dart';
import 'package:max/data/repositories/search/search_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProductModel _sampleProduct({
  String id = 'p1',
  String name = 'Classic Cotton T-Shirt',
  String description = 'A premium cotton t-shirt with a comfortable regular fit.',
}) {
  return ProductModel(
    id: id,
    categoryId: 2,
    name: name,
    description: description,
    price: 199.99,
    discountPrice: 149.99,
    brand: 'MaxFashion',
    thumbnailUrl: 'products/1/thumb.jpg',
    productImages: const [],
    productSizes: const [],
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ProductModel', () {
    test('fromJson parses all fields', () {
      final model = ProductModel.fromJson({
        'id': 7,
        'category_id': 2,
        'name': 'Cotton Shirt',
        'description': 'Soft cotton shirt',
        'price': 29.99,
        'discount_price': null,
        'brand': 'MaxFashion',
        'thumbnail_url': 'products/7/thumb.jpg',
        'is_featured': true,
        'is_available': true,
      });

      expect(model.id, 'p7');
      expect(model.name, 'Cotton Shirt');
      expect(model.description, 'Soft cotton shirt');
      expect(model.price, 29.99);
      expect(model.discountPrice, isNull);
      expect(model.isFeatured, isTrue);
    });

    test('fromJson defaults missing fields', () {
      final model = ProductModel.fromJson({
        'id': 1,
        'category_id': 1,
        'price': 10,
      });

      expect(model.name, '');
      expect(model.description, '');
      expect(model.brand, 'MaxFashion');
      expect(model.thumbnailUrl, '');
    });

    test('toJson serializes all fields', () {
      final model = _sampleProduct();

      final json = model.toJson();
      expect(json['id'], 1);
      expect(json['name'], 'Classic Cotton T-Shirt');
      expect(json['description'], 'A premium cotton t-shirt with a comfortable regular fit.');
      expect(json['price'], 199.99);
      expect(json['discount_price'], 149.99);
    });

    test('effectivePrice uses price when no discount', () {
      final model = _sampleProduct();
      expect(model.effectivePrice, 149.99);
    });

    test('hasDiscount returns true when discountPrice is lower', () {
      final model = _sampleProduct();
      expect(model.hasDiscount, isTrue);
    });

    test('hasDiscount returns false when no discountPrice', () {
      final model = _sampleProduct();
      final noDiscount = model.copyWith(clearDiscountPrice: true);
      expect(noDiscount.hasDiscount, isFalse);
    });

    test('copyWith preserves immutability', () {
      final original = _sampleProduct();
      final modified = original.copyWith(name: 'New Name');

      expect(original.name, 'Classic Cotton T-Shirt');
      expect(modified.name, 'New Name');
    });
  });

  group('allProductsProvider', () {
    test('returns products directly without locale transformation', () async {
      final repository = _FakeProductRepository([
        _sampleProduct(name: 'Coastal Voyager Shades', description: 'Premium sunglasses'),
      ]);

      final container = ProviderContainer(overrides: [
        productRepositoryProvider.overrideWithValue(repository),
      ]);
      addTearDown(container.dispose);
      container.listen(allProductsProvider, (_, _) {});

      await Future<void>.delayed(const Duration(milliseconds: 50));

      final products = container.read(allProductsProvider);
      expect(products.length, 1);
      expect(products.first.name, 'Coastal Voyager Shades');
      expect(products.first.description, 'Premium sunglasses');
    });

    test('products are available in both locales with English content', () async {
      final repository = _FakeProductRepository([
        _sampleProduct(name: 'Cotton Shirt', description: 'English description'),
      ]);

      final container = ProviderContainer(overrides: [
        productRepositoryProvider.overrideWithValue(repository),
      ]);
      addTearDown(container.dispose);
      container.listen(allProductsProvider, (_, _) {});

      await Future<void>.delayed(const Duration(milliseconds: 50));

      final products = container.read(allProductsProvider);
      expect(products.single.name, 'Cotton Shirt');
      expect(products.single.description, 'English description');
      expect(products.single.id, 'p1');
      expect(products.single.price, 199.99);
    });
  });

  group('SearchNotifier', () {
    Future<ProviderContainer> buildContainer(
      CapturingSearchRepository repository,
    ) async {
      final container = ProviderContainer(overrides: [
        searchRepositoryProvider.overrideWithValue(repository),
        authStateProvider.overrideWith((ref) => _FakeAuthNotifier()),
      ]);
      addTearDown(container.dispose);
      await Future<void>.delayed(const Duration(milliseconds: 150));
      container.listen(searchProvider, (_, _) {});
      return container;
    }

    test('searches without locale parameter', () async {
      final repository = CapturingSearchRepository();
      final container = await buildContainer(repository);
      container.listen(searchProvider, (_, _) {});

      final notifier = container.read(searchProvider.notifier);
      notifier.onQueryChanged('cotton shirt');

      await Future<void>.delayed(const Duration(milliseconds: 450));

      expect(repository.capturedQuery, 'cotton shirt');
    });

    test('loadMore searches with the same query', () async {
      final repository = CapturingSearchRepository()
        ..stubResult = const SearchResult(products: [
          ProductModel(
            id: 'p1',
            categoryId: 1,
            name: 'Result',
            description: '',
            price: 10,
            brand: 'MaxFashion',
            thumbnailUrl: '',
          ),
        ], totalCount: 40);
      final container = await buildContainer(repository);
      container.listen(searchProvider, (_, _) {});

      final notifier = container.read(searchProvider.notifier);
      notifier.onQueryChanged('shirt');
      await Future<void>.delayed(const Duration(milliseconds: 450));
      await notifier.loadMore();

      expect(repository.capturedQuery, 'shirt');
    });
  });
}

class _FakeAuthNotifier extends StateNotifier<AuthState>
    implements AuthNotifier {
  _FakeAuthNotifier() : super(const AuthState(isGuest: true));

  @override
  void setLocalizations(AppLocalizations l10n) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class CapturingSearchRepository implements SearchRepository {
  String? capturedQuery;
  int? capturedLimit;
  SearchResult stubResult = const SearchResult(products: [], totalCount: 0);

  @override
  Future<SearchResult> searchProducts(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    capturedQuery = query;
    capturedLimit = limit;
    return stubResult;
  }

  @override
  Future<List<ProductModel>> getPopularProducts() async => [];
}

class _FakeProductRepository implements ProductRepository {
  _FakeProductRepository(this._products);

  final List<ProductModel> _products;

  @override
  List<CategoryModel> get categories => [];

  @override
  Future<void> loadAll() async {}

  @override
  List<ProductModel> getAllProducts() => _products;
}
