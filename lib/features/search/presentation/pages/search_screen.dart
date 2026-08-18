import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/search_provider.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/features/search/presentation/widgets/search_text_field.dart';
import 'package:max/features/search/presentation/widgets/search_results_list.dart';
import 'package:max/features/search/presentation/widgets/search_suggestions.dart';
import 'package:max/features/product/presentation/pages/product_detail_page.dart';
import 'package:max/core/widgets/skeletons/search_skeleton.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.initialSource, this.searchContext});

  final List<ProductModel>? initialSource;
  final SearchContextType? searchContext;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchProvider.select((s) => s.query));
    final hasQuery = query.trim().isNotEmpty;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        title: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    size: 24.w,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: SearchTextField(
                    autofocus: true,
                    hintText: _getHintText(),
                    onChanged: (value) {
                      ref.read(searchProvider.notifier).onQueryChanged(value);
                    },
                    onClear: () {
                      ref.read(searchProvider.notifier).clearSearch();
                    },
                    onSubmitted: (value) {
                      ref.read(searchProvider.notifier).addRecentSearch(value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: hasQuery
            ? _buildSearchResults()
            : _buildDefaultContent(),
      ),
    );
  }

  String _getHintText() {
    final ctx = widget.searchContext;
    switch (ctx) {
      case SearchContextType.home:
        return 'Search products on home...';
      case SearchContextType.category:
        return 'Search in this category...';
      case SearchContextType.cart:
        return 'Search in your bag...';
      case SearchContextType.wishlist:
        return 'Search in wishlist...';
      case SearchContextType.orders:
        return 'Search in orders...';
      case SearchContextType.global:
        return 'Search....';
      case null:
        return 'Search....';
    }
  }

  Widget _buildSearchResults() {
    final searchState = ref.watch(searchProvider);
    if (searchState.isLoading) {
      return const SearchSkeleton();
    }

    if (searchState.error != null && searchState.results.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48.w,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(height: 16.h),
              Text(
                searchState.error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SearchResultsList(
      products: searchState.results,
      query: searchState.query,
      hasMore: searchState.hasMore,
      isLoadingMore: searchState.isLoadingMore,
      onLoadMore: () => ref.read(searchProvider.notifier).loadMore(),
      onProductSelected: (product) async {
        ref.read(searchProvider.notifier).addRecentSearch(searchState.query);
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => ProductDetailPage(product: product)),
        );
        if (!context.mounted) return;
        ref.read(searchProvider.notifier).resetSession();
      },
    );
  }

  Widget _buildDefaultContent() {
    final suggestedProducts = ref.watch(sessionSuggestedProductsProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          RecentSearchesSection(
            onTap: (query) {
              ref.read(searchProvider.notifier).onQueryChanged(query);
              ref.read(searchProvider.notifier).addRecentSearch(query);
            },
          ),
          SizedBox(height: 24.h),
          SuggestedProductsSection(
            products: suggestedProducts,
          ),
          SizedBox(height: 24.h),
          const PopularCategoriesSection(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
