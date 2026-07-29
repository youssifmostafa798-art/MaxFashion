import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/card_widget.dart';

import 'package:max/core/widgets/custem_appbar.dart';
import 'package:max/core/widgets/custem_bottom.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/data/models/product_model.dart';

import 'package:max/features/checkout/presentation/add_address.dart';
import 'package:max/features/checkout/presentation/add_card.dart';

import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/header.dart';

class PlaceOrder extends StatefulWidget {
  const PlaceOrder({
    super.key,
    required this.product,
    required this.qty,
    required this.total,
  });

  final ProductModel product;
  final int qty;
  final double total;

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  dynamic _savedAddress;
  dynamic savedCard;

  void _openAddress() async {
    final addressData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddAddress()),
    );
    if (addressData != null) {
      setState(() {
        _savedAddress = addressData;
      });
    }
  }

  void editAddress() async {
    final newAddress = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddAddress(editData: _savedAddress)),
    );
    setState(() {
      _savedAddress = newAddress;
    });
  }

  void _openCard() async {
    final cardData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddCard()),
    );
    if (cardData != null) {
      setState(() {
        savedCard = cardData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustemAppbar(isBlackk: false, showSearchBar: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(title: "Checkout"),

            savedCard != null && _savedAddress != null
                ? SizedBox.shrink()
                : CustemText(
                    text: "Shipping address".toUpperCase(),
                    spacing: 2,
                    color: const Color.fromARGB(255, 170, 169, 169),
                    size: 15,
                  ),
            Gap(15.h),

            _savedAddress != null
                ? GestureDetector(
                    onTap: () {
                      editAddress();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(20.h),
                            CustemText(
                              text:
                                  "${_savedAddress['first'] + _savedAddress['last']}",
                              spacing: 2,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            Gap(8.h),
                            CustemText(
                              text:
                                  "${_savedAddress['city'] + _savedAddress['address']}",

                              color: const Color.fromARGB(255, 170, 169, 169),
                              size: 15,
                            ),
                            Gap(5.h),
                            CustemText(
                              text:
                                  "${_savedAddress['state'] + _savedAddress['zip']}",

                              color: const Color.fromARGB(255, 170, 169, 169),
                              size: 15,
                            ),
                            Gap(5.h),
                            CustemText(
                              text: "${_savedAddress['phone']}",

                              color: const Color.fromARGB(255, 170, 169, 169),
                              size: 15,
                            ),
                          ],
                        ),

                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),

            _savedAddress == null
                ? GestureDetector(
                    onTap: () {
                      _openAddress();
                    },
                    child: custemContanair(
                      "Add shipping address",
                      Icons.add,
                      false,
                    ),
                  )
                : SizedBox.shrink(),
            Gap(15.h),

            savedCard != null && _savedAddress != null
                ? SizedBox.shrink()
                : CustemText(
                    text: "Shipping Method".toUpperCase(),
                    color: const Color.fromARGB(255, 111, 111, 111),
                  ),
            Gap(10.h),
            savedCard != null && _savedAddress != null
                ? SizedBox.shrink()
                : custemContanair(
                    "Pickup at store",
                    Icons.arrow_drop_down,
                    true,
                  ),
            Gap(20.h),
            savedCard != null && _savedAddress != null
                ? SizedBox.shrink()
                : CustemText(
                    text: "Payment method".toUpperCase(),
                    color: const Color.fromARGB(255, 111, 111, 111),
                  ),
            Gap(10.h),

            savedCard != null
                ? Column(
                    children: [
                      Divider(),
                      Gap(10.h),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svgs/Mastercard.svg",
                            width: 40.w,
                          ),
                          Gap(10.w),
                          Expanded(
                            child: CustemText(
                              text:
                                  "Master Card ending ••••${savedCard['number'].toString().substring(savedCard['number'].length - 2)}",
                              color: Colors.black,
                            ),
                          ),

                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      Gap(10.h),
                      Divider(),
                    ],
                  )
                : GestureDetector(
                    onTap: () {
                      _openCard();
                    },
                    child: custemContanair(
                      "Select payment method",
                      Icons.arrow_drop_down,
                      false,
                    ),
                  ),
            Gap(30.h),
            savedCard != null && _savedAddress != null
                ? CardWidget(
                    products: widget.product,
                    enableQty: true,
                    qty: widget.qty,
                    onChanged: (qty) {},
                  )
                : SizedBox.shrink(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustemText(text: "Total", color: AppColors.primary, spacing: 3),
                CustemText(
                  text: "\$ ${widget.total}",
                  color: Colors.red.shade200,
                ),
              ],
            ),
            Gap(20.h),
            Button(
              isSvgg: true,
              title: "Place order".toUpperCase(),
              onTap: () {
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
                                  child: Icon(CupertinoIcons.clear),
                                ),
                              ),
                              Gap(20.h),
                              CustemText(
                                text: "Payment success".toUpperCase(),
                                spacing: 2,
                                color: Colors.black,
                                size: 19,
                              ),
                              Gap(40.h),
                              SvgPicture.asset("assets/pop/done.svg"),
                              Gap(40.h),
                              CustemText(
                                text: "Your payment was success",
                                size: 18,
                                color: Colors.black,
                              ),
                              Gap(10.h),
                              CustemText(
                                text: "Payment ID 15263541",
                                size: 18,
                                color: Colors.black,
                              ),
                              Gap(20.h),
                              Image.asset(
                                'assets/svgs/line.png',
                                width: 150.w,
                                height: 15.h,
                                color: Colors.black,
                              ),
                              Gap(20.h),
                              CustemText(
                                text: "Rate your purchase",

                                color: Colors.black,
                              ),
                              Gap(20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/pop/emogi1.svg"),
                                  Gap(20.w),
                                  SvgPicture.asset("assets/pop/emogi2.svg"),
                                  Gap(20.w),
                                  SvgPicture.asset("assets/pop/emogi3.svg"),
                                ],
                              ),

                              Spacer(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Button(
                                      isSvgg: false,
                                      title: "Submit".toUpperCase(),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  Gap(20.w),
                                  Expanded(
                                    child: Button(
                                      isSvgg: false,
                                      title: "Cancel".toUpperCase(),

                                      onTap: () {
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
            Gap(60.h),
          ],
        ),
      ),
    );
  }
}

Widget custemContanair(String text, IconData iconData, bool isFree) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustemText(text: text, color: const Color.fromARGB(255, 121, 120, 120)),
        Spacer(),

        if (isFree)
          CustemText(
            text: "FREE",
            color: const Color.fromARGB(255, 121, 120, 120),
          ),

        Icon(iconData, color: Colors.black),
      ],
    ),
  );
}
