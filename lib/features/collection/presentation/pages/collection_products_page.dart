import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/collection_model.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/features/product/presentation/widgets/product_grid.dart';
import 'package:max/features/collection/presentation/widgets/empty_collection.dart';

class CollectionProductsPage extends ConsumerWidget {
  const CollectionProductsPage({super.key, required this.collection});

  final CollectionModel collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final allProducts = ref.watch(allProductsProvider);

    final products = allProducts
        .where((p) => collection.categoryIds.contains(p.categoryId))
        .toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: collection.name.toUpperCase(),
          size: 18,
          color: colorScheme.onSurface,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: products.isEmpty
          ? EmptyCollection(collectionName: collection.name)
          : ProductGrid(products: products),
    );
  }
}
