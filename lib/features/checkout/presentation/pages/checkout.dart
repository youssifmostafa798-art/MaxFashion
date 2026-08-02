import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/features/checkout/presentation/widgets/card_widget.dart';
import 'package:max/core/widgets/custom_appbar.dart';
import 'package:max/core/widgets/custom_button.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/features/checkout/presentation/widgets/favorite_button.dart';
import 'package:max/features/checkout/presentation/widgets/promo_section.dart';
import 'package:max/features/checkout/presentation/widgets/added_to_cart_dialog.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/models/cart_item_model.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/core/widgets/header.dart';

class Checkout extends ConsumerStatefulWidget {
  const Checkout({super.key, required this.products});
  final ProductModel products;

  @override
  ConsumerState<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends ConsumerState<Checkout> {
  int selectedQty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(showSearchBar: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Header(title: "Checkout"),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [FavoriteButton(product: widget.products)],
              ),

              CardWidget(
                products: widget.products,
                enableQty: true,
                qty: selectedQty,
                onChanged: (v) {
                  setState(() {
                    selectedQty = v;
                  });
                },
              ),

              const PromoSection(),
              Gap(50.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Est. Total",
                    color: Theme.of(context).colorScheme.onSurface,
                    spacing: 3,
                  ),
                  CustomText(
                    text: "\$ ${widget.products.price * selectedQty}",
                    color: Colors.red.shade200,
                  ),
                ],
              ),
              Gap(15.h),
              CustomButton(
                isSvg: true,
                title: "Add to cart",
                onTap: () {
                  final productId = CartItemModel.generateProductId(
                    widget.products.name,
                    widget.products.image,
                  );
                  ref
                      .read(cartProvider.notifier)
                      .addItem(
                        CartItemModel(
                          productId: productId,
                          productName: widget.products.name,
                          productImage: widget.products.image,
                          quantity: selectedQty,
                          unitPrice: widget.products.price,
                        ),
                      );
                  showAddedToCartDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
