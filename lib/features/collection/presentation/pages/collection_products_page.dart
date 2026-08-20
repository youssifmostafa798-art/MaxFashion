import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/collection_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/features/product/presentation/pages/product_detail_page.dart';
import 'package:max/features/product/presentation/widgets/product_grid_card.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            HapticUtils.light();
            Navigator.pop(context);
          },
        ),
      ),
      body: products.isEmpty
          ? _EmptyCollection(collectionName: collection.name)
          : _ProductGrid(products: products),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: CustomText(
            text:
                '${products.length} ${products.length == 1 ? 'item' : 'items'}',
            size: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              crossAxisSpacing: 15.w,
              childAspectRatio: 0.50,
            ),
            itemBuilder: (context, index) {
              final item = products[index];
              return ProductGridCard(
                product: item,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: item),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmptyCollection extends StatelessWidget {
  const _EmptyCollection({required this.collectionName});
  final String collectionName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 48.w,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h),
            CustomText(
              text: 'No Products Found',
              size: 18,
              color: colorScheme.onSurface,
              weight: FontWeight.w600,
              spacing: 2,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: 'No items in $collectionName yet',
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
