import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/card_widget.dart';
import 'package:max/core/widgets/custem_appbar.dart';
import 'package:max/core/widgets/custem_bottom.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/models/cart_item_model.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/header.dart';
import 'package:max/core/router/app_router.dart';

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
      appBar: CustemAppbar(isBlackk: false, showSearchBar: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(title: "Checkout"),

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

              promo(),
              Gap(50.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustemText(
                    text: "Est. Total",
                    color: AppColors.primary,
                    spacing: 3,
                  ),
                  CustemText(
                    text: "\$ ${widget.products.price * selectedQty}",
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
                    widget.products.name,
                    widget.products.image,
                  );
                  ref.read(cartProvider.notifier).addItem(
                        CartItemModel(
                          productId: productId,
                          productName: widget.products.name,
                          productImage: widget.products.image,
                          quantity: selectedQty,
                          unitPrice: widget.products.price,
                        ),
                      );
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          color: Colors.white,
                          height: 520.h,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(15.w),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.close),
                                  ),
                                ),
                                Gap(20.h),
                                CustemText(
                                  text: "ADDED TO CART".toUpperCase(),
                                  spacing: 2,
                                  color: Colors.black,
                                  size: 19,
                                ),
                                Gap(40.h),
                                SvgPicture.asset("assets/pop/done.svg"),
                                Gap(40.h),
                                CustemText(
                                  text: "Item added to your\ncart successfully",
                                  size: 18,
                                  color: Colors.black,
                                ),
                                Gap(20.h),
                                CustemText(
                                  text:
                                      "You can review your cart \nor continue shopping.",
                                  size: 18,
                                  color: Colors.black,
                                ),
                                Gap(40.h),
                                Image.asset(
                                  'assets/svgs/line.png',
                                  width: 150.w,
                                  height: 15.h,
                                  color: Colors.black,
                                ),
                                Gap(40.h),
                                CustemText(
                                  text: "Ready to checkout?",
                                  color: Colors.black,
                                ),

                                Spacer(),
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget promo() {
  return Column(
    children: [
      Gap(20.h),
      Divider(),
      Gap(20.h),
      Row(
        children: [
          SvgPicture.asset("assets/svgs/promo.svg", width: 28.w),
          Gap(20.w),
          CustemText(text: "ADD Promo Code", color: AppColors.primary),
        ],
      ),
      Gap(20.h),
      Divider(),
      Gap(20.h),
      Row(
        children: [
          SvgPicture.asset("assets/svgs/delivery.svg", width: 25.w),
          Gap(20.w),
          CustemText(text: "Delivery", color: AppColors.primary),
          Spacer(),
          CustemText(text: "FREE", color: AppColors.primary),
          Gap(5.w),
        ],
      ),
      Gap(10.h),
      Divider(),
    ],
  );
}
