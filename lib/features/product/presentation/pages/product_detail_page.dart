import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/card_widget.dart';
import 'package:max/core/widgets/custem_appbar.dart';
import 'package:max/core/widgets/custem_bottom.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/core/widgets/favorite_button.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/models/cart_item_model.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/core/router/app_router.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key, required this.product});
  final ProductModel product;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int selectedQty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustemAppbar(showSearchBar: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FavoriteButton(product: widget.product),
                ],
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
              const _PromoSection(),
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
                  ref.read(cartProvider.notifier).addItem(
                        CartItemModel(
                          productId: productId,
                          productName: widget.product.name,
                          productImage: widget.product.image,
                          quantity: selectedQty,
                          unitPrice: widget.product.price,
                        ),
                      );
                  _showAddedToCartDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddedToCartDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            height: 520.h,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ),
                  Gap(20.h),
                  CustemText(
                    text: "ADDED TO CART",
                    spacing: 2,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 19,
                  ),
                  Gap(40.h),
                  SvgPicture.asset("assets/pop/done.svg"),
                  Gap(40.h),
                  CustemText(
                    text: "Item added to your\ncart successfully",
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  Gap(20.h),
                  CustemText(
                    text: "You can review your cart \nor continue shopping.",
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  Gap(40.h),
                  Image.asset(
                    'assets/svgs/line.png',
                    width: 150.w,
                    height: 15.h,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  Gap(40.h),
                  CustemText(
                    text: "Ready to checkout?",
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Button(
                          isSvgg: false,
                          title: "View\nCart",
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(
                              context,
                              AppRouter.main,
                              arguments: 2,
                            );
                          },
                        ),
                      ),
                      Gap(20.w),
                      Expanded(
                        child: Button(
                          isSvgg: false,
                          title: "Shop\nMore",
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PromoSection extends StatelessWidget {
  const _PromoSection();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Gap(20.h),
        const Divider(),
        Gap(20.h),
        Row(
          children: [
            SvgPicture.asset(
              "assets/svgs/promo.svg",
              width: 28.w,
              colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
            ),
            Gap(20.w),
            CustemText(text: "ADD Promo Code", color: colorScheme.onSurface),
          ],
        ),
        Gap(20.h),
        const Divider(),
        Gap(20.h),
        Row(
          children: [
            SvgPicture.asset(
              "assets/svgs/delivery.svg",
              width: 25.w,
              colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
            ),
            Gap(20.w),
            CustemText(text: "Delivery", color: colorScheme.onSurface),
            const Spacer(),
            CustemText(text: "FREE", color: colorScheme.onSurface),
            Gap(5.w),
          ],
        ),
        Gap(10.h),
        const Divider(),
      ],
    );
  }
}
