import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/features/cart/presentation/widgets/cart_bottom_section.dart';

class CartContent extends ConsumerWidget {
  const CartContent({super.key, required this.cartState});

  final CartState cartState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = cartState.items;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isUpdating = cartState.updatingItemId == item.id;
              return CartItemCard(
                itemId: item.id,
                image: item.productImage,
                title: item.productName,
                price: item.unitPrice,
                quantity: item.quantity,
                selectedColor: item.selectedColor,
                selectedSize: item.selectedSize,
                isUpdating: isUpdating,
                onIncrement: () => ref
                    .read(cartProvider.notifier)
                    .incrementQuantity(index),
                onDecrement: () => ref
                    .read(cartProvider.notifier)
                    .decrementQuantity(index),
                onRemove: () => ref.read(cartProvider.notifier).removeItem(
                      item.productId,
                      item.selectedColor,
                      item.selectedSize,
                    ),
              );
            },
          ),
        ),
        CartBottomSection(isClearing: cartState.isClearing),
      ],
    );
  }
}
