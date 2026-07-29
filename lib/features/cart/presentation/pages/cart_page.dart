import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/features/cart/presentation/widgets/cart_item_card.dart';

import '../../../../core/widgets/custem_bottom.dart';
import '../../../../data/models/product_model.dart';
import '../../../checkout/presentation/place_order.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, this.products});
  final ProductModel? products;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<_CartItem> _cartItems;
  int selectedQty = 1;
  @override
  void initState() {
    super.initState();
    _cartItems = [
      _CartItem(
        image: 'assets/product/product1.png',
        title: 'Boots',
        price: 50.00,
        quantity: 1,
      ),
      _CartItem(
        image: 'assets/product/product4.png',
        title: 'Gold-plated ring',
        price: 100.00,
        quantity: 2,
      ),
      _CartItem(
        image: 'assets/product/product6.png',
        title: 'Dress',
        price: 120.00,
        quantity: 1,
      ),
    ];
  }

  double get _totalPrice {
    double total = 0;
    for (final item in _cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void _increment(int index) {
    setState(() {
      _cartItems[index].quantity++;
    });
  }

  void _decrement(int index) {
    setState(() {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      }
    });
  }

  void _remove(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: CustemText(
          text: 'MY BAG',
          size: 18,
          color: AppColors.primary,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
    );
  }

  Widget _buildEmptyCart() {
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
          CustemText(
            text: 'Your bag is empty',
            size: 18,
            color: AppColors.grey600,
          ),
          SizedBox(height: 8.h),
          CustemText(
            text: 'Add items to get started',
            size: 14,
            color: AppColors.grey400,
          ),
          SizedBox(height: 30.h),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: CustemText(
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

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              final item = _cartItems[index];
              return CartItemCard(
                image: item.image,
                title: item.title,
                price: item.price,
                quantity: item.quantity,
                onIncrement: () => _increment(index),
                onDecrement: () => _decrement(index),
                onRemove: () => _remove(index),
              );
            },
          ),
        ),
        _buildBottomSection(),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.grey200)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustemText(text: 'Subtotal', size: 14, color: AppColors.grey600),
              CustemText(
                text: '\$${_totalPrice.toStringAsFixed(2)}',
                size: 14,
                color: AppColors.primary,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustemText(text: 'Delivery', size: 14, color: AppColors.grey600),
              CustemText(text: 'Free', size: 14, color: AppColors.accent),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 1, color: AppColors.grey200),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustemText(
                text: 'Est. Total',
                size: 16,
                weight: FontWeight.w700,
                color: AppColors.primary,
              ),
              CustemText(
                text: '\$${_totalPrice.toStringAsFixed(2)}',
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
            onTap: _cartItems.isEmpty
                ? null
                : () {
                    final product =
                        widget.products ??
                        ProductModel(
                          name: _cartItems.first.title,
                          image: _cartItems.first.image,
                          price: _cartItems.first.price,
                          descrp: '',
                        );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return PlaceOrder(
                            product: product,
                            qty: selectedQty,
                            total: _totalPrice,
                          );
                        },
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

class _CartItem {
  final String image;
  final String title;
  final double price;
  int quantity;

  _CartItem({
    required this.image,
    required this.title,
    required this.price,
    required this.quantity,
  });
}
