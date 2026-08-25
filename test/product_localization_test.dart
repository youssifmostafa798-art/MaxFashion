import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/l10n/language_provider.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/models/product_translation_model.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/data/providers/search_provider.dart';
import 'package:max/data/repositories/product/product_repository.dart';
import 'package:max/data/repositories/search/search_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProductModel _productWithTranslations({
  List<ProductTranslationModel> translations = const [],
}) {
  return ProductModel(
    id: 'p1',
    categoryId: 2,
    name: 'Legacy Name',
    description: 'Legacy description',
    price: 199.99,
    discountPrice: 149.99,
    brand: 'MaxFashion',
    thumbnailUrl: 'products/1/thumb.jpg',
    productImages: const [],
    productSizes: const [],
    translations: translations,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ProductTranslationModel', () {
    const enJson = {
      'product_id': 7,
      'locale': 'en',
      'name': 'Cotton Shirt',
      'description': 'Soft cotton shirt',
    };

    test('fromJson parses a full translation row', () {
      final model = ProductTranslationModel.fromJson(enJson);

      expect(model.productId, 7);
      expect(model.locale, 'en');
      expect(model.name, 'Cotton Shirt');
      expect(model.description, 'Soft cotton shirt');
    });

    test('fromJson defaults description when missing', () {
      final model = ProductTranslationModel.fromJson({
        'product_id': 7,
        'locale': 'ar',
        'name': 'قميص قطني',
      });

      expect(model.description, '');
    });

    test('toJson serializes all fields', () {
      final model = ProductTranslationModel(
        productId: 7,
        locale: 'ar',
        name: 'قميص قطني',
        description: 'قميص قطني ناعم',
      );

      expect(model.toJson(), {
        'product_id': 7,
        'locale': 'ar',
        'name': 'قميص قطني',
        'description': 'قميص قطني ناعم',
      });
    });

    test('fromJson -> toJson round trip is stable', () {
      final model = ProductTranslationModel.fromJson(enJson);

      expect(
        ProductTranslationModel.fromJson(model.toJson()).toJson(),
        enJson,
      );
    });

    test('listFromJson returns empty list for null input', () {
      expect(ProductTranslationModel.listFromJson(null), isEmpty);
    });

    test('listFromJson parses embedded rows', () {
      final list = ProductTranslationModel.listFromJson([
        enJson,
        {'product_id': 7, 'locale': 'ar', 'name': 'قميص قطني'},
      ]);

      expect(list.length, 2);
      expect(list[1].locale, 'ar');
      expect(list[1].description, '');
    });
  });

  group('ProductTranslationModel.resolve', () {
    final translations = [
      const ProductTranslationModel(
        productId: 1,
        locale: 'en',
        name: 'Cotton Shirt',
        description: 'English description',
      ),
      const ProductTranslationModel(
        productId: 1,
        locale: 'ar',
        name: 'قميص قطني',
        description: 'وصف عربي',
      ),
    ];

    test('returns exact English translation for en', () {
      final resolved = ProductTranslationModel.resolve(translations, 'en');

      expect(resolved?.locale, 'en');
      expect(resolved?.name, 'Cotton Shirt');
    });

    test('returns exact Arabic translation for ar', () {
      final resolved = ProductTranslationModel.resolve(translations, 'ar');

      expect(resolved?.locale, 'ar');
      expect(resolved?.name, 'قميص قطني');
    });

    test('falls back to English when Arabic translation missing', () {
      final englishOnly = [translations.first];
      final resolved = ProductTranslationModel.resolve(englishOnly, 'ar');

      expect(resolved?.locale, 'en');
      expect(resolved?.name, 'Cotton Shirt');
    });

    test('returns null when no usable translation exists', () {
      expect(ProductTranslationModel.resolve(const [], 'ar'), isNull);
      expect(ProductTranslationModel.resolve(const [], 'en'), isNull);
    });
  });

  group('ProductModel.localizedFor', () {
    final base = _productWithTranslations();
    final localizedBase = _productWithTranslations(translations: [
      const ProductTranslationModel(
        productId: 1,
        locale: 'en',
        name: 'Cotton Shirt',
        description: 'English description',
      ),
      const ProductTranslationModel(
        productId: 1,
        locale: 'ar',
        name: 'قميص قطني',
        description: 'وصف عربي',
      ),
    ]);

    test('English locale resolves English content', () {
      final result = localizedBase.localizedFor(AppConstants.englishLanguageCode);

      expect(result.name, 'Cotton Shirt');
      expect(result.description, 'English description');
    });

    test('Arabic locale resolves Arabic content', () {
      final result = localizedBase.localizedFor(AppConstants.arabicLanguageCode);

      expect(result.name, 'قميص قطني');
      expect(result.description, 'وصف عربي');
    });

    test('missing Arabic translation falls back to English for display', () {
      final englishOnly = _productWithTranslations(translations: [
        const ProductTranslationModel(
          productId: 1,
          locale: 'en',
          name: 'Cotton Shirt',
          description: 'English description',
        ),
      ]);
      final result = englishOnly.localizedFor(AppConstants.arabicLanguageCode);

      expect(result.name, 'Cotton Shirt');
      expect(result.description, 'English description');
    });

    test('no translations keeps legacy base content', () {
      final result = base.localizedFor(AppConstants.arabicLanguageCode);

      expect(result.name, 'Legacy Name');
      expect(result.description, 'Legacy description');
      expect(identical(result, base), isTrue);
    });

    test('language switch never mutates shared product data', () {
      final arabic = localizedBase.localizedFor(AppConstants.arabicLanguageCode);
      final english = localizedBase.localizedFor(AppConstants.englishLanguageCode);

      for (final resolved in [arabic, english]) {
        expect(resolved.id, base.id);
        expect(resolved.categoryId, base.categoryId);
        expect(resolved.price, base.price);
        expect(resolved.discountPrice, base.discountPrice);
        expect(resolved.brand, base.brand);
        expect(resolved.thumbnailUrl, base.thumbnailUrl);
        expect(resolved.rawId, base.rawId);
      }
    });
  });

  group('allProductsProvider locale projection', () {
    test('re-projects products when the app locale changes', () async {
      final repository = _FakeProductRepository([
        _productWithTranslations(translations: [
          const ProductTranslationModel(
            productId: 1,
            locale: 'en',
            name: 'Cotton Shirt',
            description: 'English description',
          ),
          const ProductTranslationModel(
            productId: 1,
            locale: 'ar',
            name: 'قميص قطني',
            description: 'وصف عربي',
          ),
        ]),
      ]);

      final container = ProviderContainer(overrides: [
        productRepositoryProvider.overrideWithValue(repository),
      ]);
      addTearDown(container.dispose);
      container.listen(allProductsProvider, (_, _) {});

      await Future<void>.delayed(const Duration(milliseconds: 50));

      final englishNames = container
          .read(allProductsProvider)
          .map((p) => p.name)
          .toList();
      expect(englishNames, ['Cotton Shirt']);

      await container.read(localeProvider.notifier).setLocale(const Locale('ar'));

      final arabicNames = container
          .read(allProductsProvider)
          .map((p) => p.name)
          .toList();
      expect(arabicNames, ['قميص قطني']);
    });

    test('keeps English content when Arabic translation missing', () async {
      final repository = _FakeProductRepository([
        _productWithTranslations(translations: [
          const ProductTranslationModel(
            productId: 1,
            locale: 'en',
            name: 'Cotton Shirt',
            description: 'English description',
          ),
        ]),
      ]);

      final container = ProviderContainer(overrides: [
        productRepositoryProvider.overrideWithValue(repository),
      ]);
      addTearDown(container.dispose);
      container.listen(allProductsProvider, (_, _) {});

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await container.read(localeProvider.notifier).setLocale(const Locale('ar'));

      final products = container.read(allProductsProvider);
      expect(products.single.name, 'Cotton Shirt');
      expect(products.single.id, 'p1');
      expect(products.single.price, 199.99);
    });
  });

  group('SearchNotifier locale contract', () {
    Future<ProviderContainer> buildContainer(
      CapturingSearchRepository repository,
      String languageCode,
    ) async {
      SharedPreferences.setMockInitialValues({'language_code': languageCode});
      final container = ProviderContainer(overrides: [
        searchRepositoryProvider.overrideWithValue(repository),
        authStateProvider.overrideWith((ref) => _FakeAuthNotifier()),
      ]);
      addTearDown(container.dispose);
      container.listen(localeProvider, (_, _) {});
      await Future<void>.delayed(const Duration(milliseconds: 150));
      container.listen(searchProvider, (_, _) {});
      return container;
    }

    test('passes active Arabic locale to the repository without conversion',
        () async {
      final repository = CapturingSearchRepository();
      final container = await buildContainer(repository, 'ar');
      container.listen(searchProvider, (_, _) {});

      final notifier = container.read(searchProvider.notifier);
      notifier.onQueryChanged('قميص قطني');

      await Future<void>.delayed(const Duration(milliseconds: 450));

      expect(repository.capturedLocale, 'ar');
      expect(repository.capturedQuery, 'قميص قطني');
    });

    test('passes active English locale to the repository', () async {
      final repository = CapturingSearchRepository();
      final container = await buildContainer(repository, 'en');
      container.listen(searchProvider, (_, _) {});

      final notifier = container.read(searchProvider.notifier);
      notifier.onQueryChanged('cotton shirt');

      await Future<void>.delayed(const Duration(milliseconds: 450));

      expect(repository.capturedLocale, 'en');
      expect(repository.capturedQuery, 'cotton shirt');
    });

    test('loadMore keeps searching with the same active locale', () async {
      final repository = CapturingSearchRepository()
        ..stubResult = const SearchResult(products: [
          ProductModel(
            id: 'p1',
            categoryId: 1,
            name: 'نتيجة',
            description: '',
            price: 10,
            brand: 'MaxFashion',
            thumbnailUrl: '',
          ),
        ], totalCount: 40);
      final container = await buildContainer(repository, 'ar');
      container.listen(searchProvider, (_, _) {});

      final notifier = container.read(searchProvider.notifier);
      notifier.onQueryChanged('قميص');
      await Future<void>.delayed(const Duration(milliseconds: 450));
      await notifier.loadMore();

      expect(repository.capturedLocale, 'ar');
    });

    test('search session resets when the locale changes', () async {
      SharedPreferences.setMockInitialValues({'language_code': 'en'});
      final container = ProviderContainer(overrides: [
        authStateProvider.overrideWith((ref) => _FakeAuthNotifier()),
      ]);
      addTearDown(container.dispose);
      container.listen(localeProvider, (_, _) {});
      await Future<void>.delayed(const Duration(milliseconds: 150));
      container.listen(searchProvider, (_, _) {});

      final notifierBefore = container.read(searchProvider.notifier);
      expect(notifierBefore, isNotNull);

      await container
          .read(localeProvider.notifier)
          .setLocale(const Locale('ar'));

      final notifierAfter = container.read(searchProvider.notifier);
      expect(identical(notifierBefore, notifierAfter), isFalse);
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
  String? capturedLocale;
  int? capturedLimit;
  SearchResult stubResult = const SearchResult(products: [], totalCount: 0);

  @override
  Future<SearchResult> searchProducts(
    String query, {
    String locale = AppConstants.fallbackLanguageCode,
    int limit = 20,
    int offset = 0,
  }) async {
    capturedQuery = query;
    capturedLocale = locale;
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
