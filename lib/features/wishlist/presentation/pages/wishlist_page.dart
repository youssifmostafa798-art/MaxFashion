import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/data/models/cart_item_model.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/data/providers/wishlist_provider.dart';
import 'package:max/features/checkout/presentation/checkout.dart';
import 'package:max/features/main/presentation/pages/main_screen.dart';
import 'package:max/features/wishlist/presentation/widgets/wishlist_item_card.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistItems = ref.watch(wishlistProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: CustemText(
          text: 'WISHLIST',
          size: 18,
          color: colorScheme.onSurface,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: wishlistItems.isEmpty ? const _EmptyWishlist() : _WishlistContent(),
    );
  }
}

class _WishlistContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistItems = ref.watch(wishlistProvider);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: wishlistItems.length,
      itemBuilder: (context, index) {
        final product = wishlistItems[index];
        return WishlistItemCard(
          product: product,
          onRemove: () {
            ref.read(wishlistProvider.notifier).remove(product.id);
          },
          onMoveToCart: () {
            final productId = CartItemModel.generateProductId(
              product.name,
              product.image,
            );
            ref
                .read(cartProvider.notifier)
                .addItem(
                  CartItemModel(
                    productId: productId,
                    productName: product.name,
                    productImage: product.image,
                    quantity: 1,
                    unitPrice: product.price,
                  ),
                );
            final colorScheme = Theme.of(context).colorScheme;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: CustemText(
                  text: '${product.name} added to cart',
                  size: 14,
                  color: colorScheme.surface,
                ),
                backgroundColor: colorScheme.onSurface,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Checkout(products: product)),
            );
          },
        );
      },
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80.w, color: colorScheme.outline),
          SizedBox(height: 20.h),
          CustemText(
            text: 'Your wishlist is empty',
            size: 18,
            weight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          SizedBox(height: 8.h),
          CustemText(
            text: 'Save your favorite products here.',
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 30.h),
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const MainScreen(initialTab: 0),
                ),
                (route) => false,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: CustemText(
                text: 'CONTINUE SHOPPING',
                size: 14,
                color: colorScheme.surface,
                spacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
