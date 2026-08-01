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
      MaterialPageRoute(builder: (_) => const AddAddress()),
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
    if (mounted) {
      setState(() {
        _savedAddress = newAddress;
      });
    }
  }

  void _openCard() async {
    final cardData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddCard()),
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
      appBar: const CustemAppbar(showSearchBar: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(title: "Checkout"),

            savedCard != null && _savedAddress != null
                ? const SizedBox.shrink()
                : CustemText(
                    text: "SHIPPING ADDRESS",
                    spacing: 2,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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

                            Gap(8.h),
                            CustemText(
                              text:
                                  "${_savedAddress['city'] ?? ''}${_savedAddress['address'] ?? ''}",
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              size: 15,
                            ),
                            Gap(5.h),
                            CustemText(
                              text:
                                  "${_savedAddress['state'] ?? ''}${_savedAddress['zip'] ?? ''}",
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              size: 15,
                            ),
                            Gap(5.h),
                            CustemText(
                              text: "${_savedAddress['phone'] ?? ''}",
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              size: 15,
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),

            _savedAddress == null
                ? GestureDetector(
                    onTap: () {
                      _openAddress();
                    },
                    child: const _CustomContainer(
                      text: "Add shipping address",
                      iconData: Icons.add,
                      isFree: false,
                    ),
                  )
                : const SizedBox.shrink(),
            Gap(15.h),

            savedCard != null && _savedAddress != null
                ? const SizedBox.shrink()
                : CustemText(text: "SHIPPING METHOD", color: Theme.of(context).colorScheme.onSurfaceVariant),
            Gap(10.h),
            savedCard != null && _savedAddress != null
                ? const SizedBox.shrink()
                : const _CustomContainer(
                    text: "Pickup at store",
                    iconData: Icons.arrow_drop_down,
                    isFree: true,
                  ),
            Gap(20.h),
            savedCard != null && _savedAddress != null
                ? const SizedBox.shrink()
                : CustemText(text: "PAYMENT METHOD", color: Theme.of(context).colorScheme.onSurfaceVariant),
            Gap(10.h),

            savedCard != null
                ? Column(
                    children: [
                      const Divider(),
                      Gap(10.h),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svgs/Mastercard.svg",
                            width: 40.w,
                          ),
                          Gap(10.w),
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final numStr = savedCard['number'].toString();
                                  final suffix = numStr.length >= 2
                                      ? numStr.substring(numStr.length - 2)
                                      : numStr;
                                   return CustemText(
                                     text:
                                         "Master Card ending \u2022\u2022\u2022\u2022$suffix",
                                     color: Theme.of(context).colorScheme.onSurface,
                                   );
                                },
                              ),
                            ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ],
                      ),
                      Gap(10.h),
                      const Divider(),
                    ],
                  )
                : GestureDetector(
                    onTap: () {
                      _openCard();
                    },
                    child: const _CustomContainer(
                      text: "Select payment method",
                      iconData: Icons.arrow_drop_down,
                      isFree: false,
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
                : const SizedBox.shrink(),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustemText(
                  text: "Total",
                  color: Theme.of(context).colorScheme.onSurface,
                  spacing: 3,
                ),
                CustemText(
                  text: "\$ ${widget.total}",
                  color: Colors.red.shade200,
                ),
              ],
            ),
            Gap(20.h),
            Button(
              isSvgg: true,
              title: "PLACE ORDER",
              onTap: () {
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
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(CupertinoIcons.clear),
                                ),
                              ),
                              Gap(20.h),
                              CustemText(
                                text: "PAYMENT SUCCESS",
                                spacing: 2,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 19,
                              ),
                              Gap(40.h),
                              SvgPicture.asset("assets/pop/done.svg"),
                              Gap(40.h),
                              CustemText(
                                text: "Your payment was success",
                                size: 18,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              Gap(10.h),
                              CustemText(
                                text: "Payment ID 15263541",
                                size: 18,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              Gap(20.h),
                              Image.asset(
                                'assets/svgs/line.png',
                                width: 150.w,
                                height: 15.h,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              Gap(20.h),
                              CustemText(
                                text: "Rate your purchase",
                                color: Theme.of(context).colorScheme.onSurface,
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

                              const Spacer(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Button(
                                      isSvgg: false,
                                      title: "SUBMIT",
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
                                      title: "CANCEL",
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

class _CustomContainer extends StatelessWidget {
  const _CustomContainer({
    required this.text,
    required this.iconData,
    required this.isFree,
  });

  final String text;
  final IconData iconData;
  final bool isFree;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustemText(text: text, color: colorScheme.onSurfaceVariant),
          const Spacer(),
          if (isFree) CustemText(text: "FREE", color: colorScheme.onSurfaceVariant),
          Icon(iconData, color: colorScheme.onSurface),
        ],
      ),
    );
  }
}
