import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_appbar.dart';
import 'package:max/core/widgets/custem_bottom.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/data/models/cart_item_model.dart';
import 'package:max/data/models/order_item_model.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/data/providers/address_provider.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/data/providers/orders_provider.dart';
import 'package:max/features/checkout/presentation/pages/add_card.dart';
import 'package:max/features/orders/presentation/pages/orders_page.dart';
import 'package:max/features/profile/presentation/pages/addresses_page.dart';

import 'package:max/core/widgets/header.dart';

class PlaceOrder extends ConsumerStatefulWidget {
  const PlaceOrder({super.key, required this.cartItems, required this.total});

  final List<CartItemModel> cartItems;
  final double total;

  @override
  ConsumerState<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends ConsumerState<PlaceOrder> {
  Map<String, dynamic>? savedCard;

  String _joinParts(List<String?> parts) {
    return parts.where((p) => p != null && p.isNotEmpty).join(', ');
  }

  String _buildPaymentString() {
    if (savedCard == null) return '';
    final numStr = savedCard!['number'].toString();
    final suffix = numStr.length >= 2
        ? numStr.substring(numStr.length - 2)
        : numStr;
    return 'Master Card ending \u2022\u2022\u2022\u2022$suffix';
  }

  void _openAddresses() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddressesPage()),
    );
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

  bool _validateOrder() {
    final defaultAddr = ref.read(defaultAddressProvider);
    if (defaultAddr == null) {
      _showValidationDialog(
        title: 'MISSING INFORMATION',
        message: 'Please add a shipping address',
      );
      return false;
    }
    if (savedCard == null) {
      _showValidationDialog(
        title: 'MISSING INFORMATION',
        message: 'Please select a payment method',
      );
      return false;
    }
    return true;
  }

  void _showValidationDialog({required String title, required String message}) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            height: 320.h,
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
                    text: title,
                    spacing: 2,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 19,
                  ),
                  Gap(30.h),
                  Icon(
                    Icons.error_outline_rounded,
                    size: 60.w,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  Gap(30.h),
                  CustemText(
                    text: message,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  Gap(20.h),
                  Image.asset(
                    'assets/svgs/line.png',
                    width: 150.w,
                    height: 15.h,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const Spacer(),
                  Button(
                    isSvgg: false,
                    title: "GOT IT",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _placeOrderAndConfirm() {
    if (!_validateOrder()) return;

    final orderItems = widget.cartItems
        .map((item) => OrderItemModel.fromCartItem(item))
        .toList();

    final defaultAddr = ref.read(defaultAddressProvider);
    final user = ref.read(authStateProvider).user;

    final deliveryParts = <String>[
      if (user != null) user.fullName,
      if (user != null && user.phoneNumber.isNotEmpty) user.phoneNumber,
      if (defaultAddr != null) defaultAddr.fullAddress,
    ];

    final order = OrderModel(
      orderId: _generateOrderId(),
      orderDate: DateTime.now(),
      items: orderItems,
      totalPrice: widget.total,
      paymentMethod: _buildPaymentString(),
      deliveryAddress: deliveryParts.join(', '),
      status: OrderStatus.processing,
    );

    ref.read(ordersProvider.notifier).addOrder(order);
    ref.read(cartProvider.notifier).clear();
    _showSuccessDialog();
  }

  String _generateOrderId() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final defaultAddress = ref.watch(defaultAddressProvider);
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final hasAddress = defaultAddress != null;

    return Scaffold(
      appBar: const CustemAppbar(showSearchBar: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(title: "Checkout"),

            savedCard != null && hasAddress
                ? const SizedBox.shrink()
                : CustemText(
                    text: "SHIPPING ADDRESS",
                    spacing: 2,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 15,
                  ),
            Gap(15.h),

            hasAddress
                ? GestureDetector(
                    onTap: () {
                      _openAddresses();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (user != null) ...[
                                Gap(8.h),
                                CustemText(
                                  text: user.fullName,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  size: 15,
                                ),
                                CustemText(
                                  text: user.phoneNumber,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  size: 13,
                                ),
                                Gap(4.h),
                              ],
                              CustemText(
                                text: defaultAddress.street,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                size: 14,
                              ),
                              if (defaultAddress.apartment != null &&
                                  defaultAddress.apartment!.isNotEmpty) ...[
                                Gap(2.h),
                                CustemText(
                                  text: defaultAddress.apartment!,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  size: 13,
                                ),
                              ],
                              Gap(2.h),
                              CustemText(
                                text: _joinParts([
                                  defaultAddress.city,
                                  defaultAddress.state,
                                  defaultAddress.zip,
                                ]),
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                size: 13,
                              ),
                              CustemText(
                                text: defaultAddress.country,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                size: 13,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),

            !hasAddress
                ? GestureDetector(
                    onTap: () {
                      _openAddresses();
                    },
                    child: const _CustomContainer(
                      text: "Add shipping address",
                      iconData: Icons.add,
                      isFree: false,
                    ),
                  )
                : const SizedBox.shrink(),
            Gap(15.h),

            savedCard != null && hasAddress
                ? const SizedBox.shrink()
                : CustemText(
                    text: "SHIPPING METHOD",
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            Gap(10.h),
            savedCard != null && hasAddress
                ? const SizedBox.shrink()
                : const _CustomContainer(
                    text: "Pickup at store",
                    iconData: Icons.arrow_drop_down,
                    isFree: true,
                  ),
            Gap(20.h),
            savedCard != null && hasAddress
                ? const SizedBox.shrink()
                : CustemText(
                    text: "PAYMENT METHOD",
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
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
                                final numStr = savedCard!['number'].toString();
                                final suffix = numStr.length >= 2
                                    ? numStr.substring(numStr.length - 2)
                                    : numStr;
                                return CustemText(
                                  text:
                                      "Master Card ending \u2022\u2022\u2022\u2022$suffix",
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
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
            savedCard != null && hasAddress
                ? _buildCartItemsList()
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
                  text: "\$ ${widget.total.toStringAsFixed(2)}",
                  color: Colors.red.shade200,
                ),
              ],
            ),
            Gap(20.h),
            Button(
              isSvgg: true,
              title: "PLACE ORDER",
              onTap: () {
                _placeOrderAndConfirm();
              },
            ),
            Gap(60.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemsList() {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final item = widget.cartItems[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    item.productImage,
                    width: 48.w,
                    height: 48.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        color: Theme.of(context).colorScheme.surface,
                        size: 20.w,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustemText(
                        text: item.productName,
                        size: 13,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      SizedBox(height: 2.h),
                      CustemText(
                        text: 'Qty: ${item.quantity}',
                        size: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                CustemText(
                  text: '\$${item.totalPrice.toStringAsFixed(2)}',
                  size: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSuccessDialog() {
    final orderId = _generateOrderId();
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
                    text: "Payment ID $orderId",
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OrdersPage(),
                              ),
                            );
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
          if (isFree)
            CustemText(text: "FREE", color: colorScheme.onSurfaceVariant),
          Icon(iconData, color: colorScheme.onSurface),
        ],
      ),
    );
  }
}
