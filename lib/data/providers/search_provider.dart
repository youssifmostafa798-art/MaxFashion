import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/repositories/search/search_repository.dart';
import 'package:max/data/repositories/search/supabase_search_repository.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SupabaseSearchRepository();
});

enum SearchContextType { global, home, category, wishlist, cart, orders }

class SearchState {
  final String query;
  final List<ProductModel> results;
  final List<String> recentSearches;
  final List<ProductModel> suggestedProducts;
  final bool isLoading;
  final bool isLoadingMore;
  final int totalCount;
  final int currentPage;
  final String? error;

  static const int pageSize = 20;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.recentSearches = const [],
    this.suggestedProducts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.totalCount = 0,
    this.currentPage = 0,
    this.error,
  });

  bool get hasMore => results.length < totalCount;

  SearchState copyWith({
    String? query,
    List<ProductModel>? results,
    List<String>? recentSearches,
    List<ProductModel>? suggestedProducts,
    bool? isLoading,
    bool? isLoadingMore,
    int? totalCount,
    int? currentPage,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      recentSearches: recentSearches ?? this.recentSearches,
      suggestedProducts: suggestedProducts ?? this.suggestedProducts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final Ref ref;
  final String? userId;
  Timer? _debounce;

  SearchNotifier(this.ref, {this.userId}) : super(const SearchState()) {
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final saved = await _loadRecentSearchesFromPrefs();
    if (!mounted) return;
    state = state.copyWith(recentSearches: saved);
  }

  void onQueryChanged(String query) {
    state = state.copyWith(query: query, error: null);

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _search(query);
    });
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(results: [], isLoading: false, totalCount: 0);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repo = ref.read(searchRepositoryProvider);
      final result = await repo.searchProducts(
        query,
        limit: SearchState.pageSize,
        offset: 0,
      );

      state = state.copyWith(
        results: result.products,
        totalCount: result.totalCount,
        currentPage: 0,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Search failed. Please try again.',
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final repo = ref.read(searchRepositoryProvider);
      final nextPage = state.currentPage + 1;
      final result = await repo.searchProducts(
        state.query,
        limit: SearchState.pageSize,
        offset: nextPage * SearchState.pageSize,
      );

      state = state.copyWith(
        results: [...state.results, ...result.products],
        currentPage: nextPage,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: 'Failed to load more results.',
      );
    }
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
    state = state.copyWith(
      query: '',
      results: [],
      isLoading: false,
      totalCount: 0,
      currentPage: 0,
      error: null,
    );
  }

  void resetSession() {
    _debounce?.cancel();
    state = state.copyWith(
      query: '',
      results: [],
      isLoading: false,
      totalCount: 0,
      currentPage: 0,
      error: null,
    );
  }

  String get _recentSearchesKey {
    if (userId != null) return 'recent_searches_$userId';
    return 'recent_searches_guest';
  }

  Future<List<String>> _loadRecentSearchesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_recentSearchesKey);
    if (jsonString == null) return [];
    final List<String> decoded =
        (jsonDecode(jsonString) as List).cast<String>();
    return decoded;
  }

  Future<void> _saveRecentSearches(List<String> searches) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_recentSearchesKey, jsonEncode(searches));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  return SearchNotifier(ref, userId: userId);
});
