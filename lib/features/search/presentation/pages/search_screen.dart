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
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/errors/app_error_messages.dart';

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
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.arrow_forward
                        : Icons.arrow_back,
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
    final l10n = AppLocalizations.of(context)!;
    final ctx = widget.searchContext;
    switch (ctx) {
      case SearchContextType.home:
        return l10n.searchOnHomeHint;
      case SearchContextType.category:
        return l10n.searchInCategoryHint;
      case SearchContextType.cart:
        return l10n.searchInBagHint;
      case SearchContextType.wishlist:
        return l10n.searchInWishlistHint;
      case SearchContextType.orders:
        return l10n.searchInOrdersHint;
      case SearchContextType.global:
        return l10n.searchHint;
      case null:
        return l10n.searchHint;
    }
  }

  Widget _buildSearchResults() {
    final searchState = ref.watch(searchProvider);
    final l10n = AppLocalizations.of(context)!;
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
                AppErrorMessages.resolve(l10n, searchState.error),
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
