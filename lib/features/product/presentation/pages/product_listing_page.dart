import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/widgets/skeletons/product_listing_skeleton.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/features/product/presentation/widgets/product_grid.dart';
import 'package:max/features/product/presentation/widgets/empty_category.dart';

class ProductListingPage extends ConsumerStatefulWidget {
  const ProductListingPage({
    super.key,
    required this.category,
  });

  final String category;

  @override
  ConsumerState<ProductListingPage> createState() => _ProductListingPageState();
}

class _ProductListingPageState extends ConsumerState<ProductListingPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final productsState = ref.watch(productsProvider);
    final products = ref.watch(categoryProductsProvider(widget.category));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: widget.category.toUpperCase(),
          size: 18,
          color: colorScheme.onSurface,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: productsState.isLoading
          ? const ProductListingSkeleton()
          : products.isEmpty
              ? EmptyCategory(category: widget.category)
              : ProductGrid(products: products),
    );
  }
}
