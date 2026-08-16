import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/data/repositories/search/search_repository.dart';
import 'package:max/data/repositories/search/supabase_search_repository.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final productRepo = ref.watch(productRepositoryProvider);
  return SupabaseSearchRepository(productRepo);
});

enum SearchContextType { global, home, category, wishlist, cart, orders }

class SearchState {
  final String query;
  final List<ProductModel> results;
  final List<String> recentSearches;
  final List<ProductModel> suggestedProducts;
  final bool isLoading;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.recentSearches = const [],
    this.suggestedProducts = const [],
    this.isLoading = false,
  });

  SearchState copyWith({
    String? query,
    List<ProductModel>? results,
    List<String>? recentSearches,
    List<ProductModel>? suggestedProducts,
    bool? isLoading,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      recentSearches: recentSearches ?? this.recentSearches,
      suggestedProducts: suggestedProducts ?? this.suggestedProducts,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final Ref ref;
  Timer? _debounce;

  SearchNotifier(this.ref) : super(const SearchState()) {
    _loadRecentSearches();
    _loadSuggested();
  }

  void _loadRecentSearches() async {
    final saved = await _loadRecentSearchesFromPrefs();
    state = state.copyWith(recentSearches: saved);
  }

  void _loadSuggested() {
    final suggested = ref.read(sessionSuggestedProductsProvider);
    state = state.copyWith(suggestedProducts: suggested);
  }

  void onQueryChanged(String query) {
    state = state.copyWith(query: query);

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      state = state.copyWith(results: [], isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true);

    final repo = ref.read(searchRepositoryProvider);
    final categories = ref.read(categoriesProvider);
    final results = repo.searchProducts(query, source: null, categories: categories);

    state = state.copyWith(results: results, isLoading: false);
  }

  void addRecentSearch(String query) {
    if (query.trim().isEmpty) return;
    final trimmed = query.trim();
    final current = List<String>.from(state.recentSearches);
    current.remove(trimmed);
    current.insert(0, trimmed);
    if (current.length > 10) current.removeLast();
    state = state.copyWith(recentSearches: current);
    _saveRecentSearches(current);
  }

  void removeRecentSearch(String query) {
    final current = List<String>.from(state.recentSearches);
    current.remove(query);
    state = state.copyWith(recentSearches: current);
    _saveRecentSearches(current);
  }

  void clearRecentSearches() {
    state = state.copyWith(recentSearches: []);
    _saveRecentSearches([]);
  }

  void clearSearch() {
    _debounce?.cancel();
    state = state.copyWith(query: '', results: [], isLoading: false);
  }

  void resetSession() {
    _debounce?.cancel();
    state = state.copyWith(
      query: '',
      results: [],
      isLoading: false,
    );
  }

  static const _kRecentSearchesKey = 'recent_searches';

  Future<List<String>> _loadRecentSearchesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kRecentSearchesKey);
    if (jsonString == null) return [];
    final List<String> decoded =
        (jsonDecode(jsonString) as List).cast<String>();
    return decoded;
  }

  void _saveRecentSearches(List<String> searches) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kRecentSearchesKey, jsonEncode(searches));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});
