import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/cart_provider.dart';

import '../../../../core/widgets/custem_bottom.dart';
import '../../../checkout/presentation/place_order.dart';
import '../../../main/presentation/pages/main_screen.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key, this.products});

  final dynamic products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const CustemText(
          text: 'MY BAG',
          size: 18,
          color: AppColors.primary,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: cartItems.isEmpty
          ? _EmptyCart()
          : _CartContent(
              products: products,
            ),
    );
  }
}

class _CartContent extends ConsumerWidget {
  const _CartContent({this.products});
  final dynamic products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return CartItemCard(
                image: item.productImage,
                title: item.productName,
                price: item.unitPrice,
                quantity: item.quantity,
                selectedColor: item.selectedColor,
                selectedSize: item.selectedSize,
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
        _CartBottomSection(products: products),
      ],
    );
  }
}

class _CartBottomSection extends ConsumerWidget {
  const _CartBottomSection({this.products});
  final dynamic products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final total = ref.watch(cartTotalProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.grey200)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustemText(
                  text: 'Subtotal', size: 14, color: AppColors.grey600),
              CustemText(
                text: '\$${subtotal.toStringAsFixed(2)}',
                size: 14,
                color: AppColors.primary,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustemText(
                  text: 'Delivery', size: 14, color: AppColors.grey600),
              CustemText(text: 'Free', size: 14, color: AppColors.accent),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 1, color: AppColors.grey200),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustemText(
                text: 'Est. Total',
                size: 16,
                weight: FontWeight.w700,
                color: AppColors.primary,
              ),
              CustemText(
                text: '\$${total.toStringAsFixed(2)}',
                size: 16,
                weight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Button(
            isSvgg: true,
            title: "Checkout",
            onTap: cartItems.isEmpty
                ? null
                : () {
                    final firstItem = cartItems.first;
                    final product = products ??
                        ProductModel(
                          id: firstItem.productId,
                          name: firstItem.productName,
                          image: firstItem.productImage,
                          price: firstItem.unitPrice,
                          descrp: '',
                        );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceOrder(
                          product: product,
                          qty: firstItem.quantity,
                          total: total,
                        ),
                      ),
                    );
                  },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80.w,
            color: AppColors.grey300,
          ),
          SizedBox(height: 20.h),
          const CustemText(
            text: 'Your bag is empty',
            size: 18,
            color: AppColors.grey600,
          ),
          SizedBox(height: 8.h),
          const CustemText(
            text: 'Add items to get started',
            size: 14,
            color: AppColors.grey400,
          ),
          SizedBox(height: 30.h),
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const MainScreen(initialTab: 0)),
                (route) => false,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const CustemText(
                text: 'START SHOPPING',
                size: 14,
                color: AppColors.white,
                spacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
