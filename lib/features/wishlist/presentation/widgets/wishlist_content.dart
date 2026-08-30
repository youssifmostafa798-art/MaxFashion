import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/cart_item_model.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/data/providers/wishlist_provider.dart';
import 'package:max/features/product/presentation/pages/product_detail_page.dart';
import 'package:max/features/wishlist/presentation/widgets/wishlist_item_card.dart';
import 'package:max/core/l10n/app_localizations.dart';

class WishlistContent extends ConsumerWidget {
  const WishlistContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final wishlistItems = ref.watch(localizedWishlistItemsProvider);

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
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
            final selectedSize =
                product.sizes.isNotEmpty ? product.sizes.first : null;
            final dbProductId = int.parse(
              product.id.replaceFirst('p', ''),
            );
            ref
                .read(cartProvider.notifier)
                .addItem(
                  CartItemModel(
                    productId: dbProductId,
                    productName: product.name,
                    productImage: product.image,
                    selectedSize: selectedSize ?? '',
                    quantity: 1,
                    unitPrice: product.price,
                  ),
                );
            final colorScheme = Theme.of(context).colorScheme;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: CustomText(
                  text: l10n.productAddedToCart(product.name),
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
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: product),
              ),
            );
          },
        );
      },
    );
  }
}
