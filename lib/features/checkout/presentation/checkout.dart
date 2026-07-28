import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/card_widget.dart';
import 'package:max/core/widgets/custem_appbar.dart';
import 'package:max/core/widgets/custem_bottom.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/features/checkout/presentation/place_order.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/header.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key, required this.products});
  final ProductModel products;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int selectedQty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustemAppbar(isBlackk: false),
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
                title: "Checkout",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return PlaceOrder(
                          product: widget.products,

                          qty: selectedQty,
                          total: widget.products.price * selectedQty,
                        );
                      },
                    ),
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
