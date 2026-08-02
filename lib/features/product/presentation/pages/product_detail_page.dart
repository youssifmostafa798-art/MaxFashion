import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/features/checkout/presentation/widgets/card_widget.dart';
import 'package:max/core/widgets/custem_appbar.dart';
import 'package:max/core/widgets/custem_bottom.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/features/checkout/presentation/widgets/favorite_button.dart';
import 'package:max/features/checkout/presentation/widgets/promo_section.dart';
import 'package:max/features/checkout/presentation/widgets/added_to_cart_dialog.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/models/cart_item_model.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/core/widgets/skeletons/product_detail_skeleton.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key, required this.product});
  final ProductModel product;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int selectedQty = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: const CustemAppbar(showSearchBar: false),
        body: const ProductDetailSkeleton(),
      );
    }

    return Scaffold(
      appBar: const CustemAppbar(showSearchBar: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [FavoriteButton(product: widget.product)],
              ),
              CardWidget(
                products: widget.product,
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
                  CustemText(
                    text: "Est. Total",
                    color: Theme.of(context).colorScheme.onSurface,
                    spacing: 3,
                  ),
                  CustemText(
                    text: "\$ ${widget.product.price * selectedQty}",
                    color: Colors.red.shade200,
                  ),
                ],
              ),
              Gap(15.h),
              Button(
                isSvgg: true,
                title: "Add to cart",
                onTap: () {
                  final productId = CartItemModel.generateProductId(
                    widget.product.name,
                    widget.product.image,
                  );
                  ref
                      .read(cartProvider.notifier)
                      .addItem(
                        CartItemModel(
                          productId: productId,
                          productName: widget.product.name,
                          productImage: widget.product.image,
                          quantity: selectedQty,
                          unitPrice: widget.product.price,
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
