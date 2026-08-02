import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_appbar.dart';
import 'package:max/core/widgets/custom_button.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/cart_item_model.dart';
import 'package:max/data/models/order_item_model.dart';
import 'package:max/data/models/order_model.dart';
import 'package:max/data/models/payment_card_model.dart';
import 'package:max/data/providers/address_provider.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/data/providers/orders_provider.dart';
import 'package:max/data/providers/payment_card_provider.dart';
import 'package:max/features/checkout/presentation/pages/add_card.dart';
import 'package:max/features/orders/presentation/pages/orders_page.dart';
import 'package:max/features/profile/presentation/pages/addresses_page.dart';

import 'package:max/core/utils/card_utils.dart';
import 'package:max/core/utils/id_generator.dart';
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
  PaymentCardModel? _selectedSavedCard;

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
        _selectedSavedCard = null;
      });
      _saveCurrentCardToProvider();
    }
  }

  void _selectSavedCard(PaymentCardModel card) {
    setState(() {
      _selectedSavedCard = card;
      savedCard = {
        'number': card.last4Digits,
        'name': card.cardHolderName,
        'date': card.expiry,
        'cvv': '',
      };
    });
  }

  void _saveCurrentCardToProvider() {
    if (savedCard == null) return;
    final cardData = savedCard!;
    final number = cardData['number'].toString();
    final last4 = number.length >= 4
        ? number.substring(number.length - 4)
        : number;
    final dateParts = cardData['date'].toString().split('/');
    final month = dateParts.isNotEmpty ? dateParts[0] : '';
    final year = dateParts.length > 1 ? dateParts[1] : '';
    final name = cardData['name'].toString();

    final brand = CardUtils.detectCardBrand(number);

    final newCard = PaymentCardModel(
      id: PaymentCardModel.generateId(),
      cardHolderName: name,
      last4Digits: last4,
      expiryMonth: month,
      expiryYear: year,
      cardBrand: brand,
      isDefault: false,
      createdAt: DateTime.now(),
    );

    final provider = ref.read(paymentCardProvider.notifier);
    if (!provider.isDuplicate(newCard)) {
      provider.add(newCard);
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
                  CustomText(
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
                  CustomText(
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
                  CustomButton(
                    isSvg: false,
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
      orderId: IdGenerator.generateOrderId(),
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

  @override
  Widget build(BuildContext context) {
    final defaultAddress = ref.watch(defaultAddressProvider);
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final hasAddress = defaultAddress != null;
    final savedCards = ref.watch(paymentCardProvider);
    final defaultCard = ref.watch(defaultPaymentCardProvider);

    if (_selectedSavedCard == null && savedCard == null && defaultCard != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _selectedSavedCard == null && savedCard == null) {
          _selectSavedCard(defaultCard);
        }
      });
    }

    return Scaffold(
      appBar: const CustomAppbar(showSearchBar: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(title: "Checkout"),

            savedCard != null && hasAddress
                ? const SizedBox.shrink()
                : CustomText(
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
                                CustomText(
                                  text: user.fullName,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  size: 15,
                                ),
                                CustomText(
                                  text: user.phoneNumber,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  size: 13,
                                ),
                                Gap(4.h),
                              ],
                              CustomText(
                                text: defaultAddress.street,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                size: 14,
                              ),
                              if (defaultAddress.apartment != null &&
                                  defaultAddress.apartment!.isNotEmpty) ...[
                                Gap(2.h),
                                CustomText(
                                  text: defaultAddress.apartment!,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  size: 13,
                                ),
                              ],
                              Gap(2.h),
                              CustomText(
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
                              CustomText(
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
                : CustomText(
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

            if (savedCards.isNotEmpty) ...[
              CustomText(
                text: "SAVED PAYMENT METHODS",
                spacing: 2,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 15,
              ),
              Gap(10.h),
              ...savedCards.map((card) {
                final isSelected = _selectedSavedCard?.id == card.id;
                return GestureDetector(
                  onTap: () => _selectSavedCard(card),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14.r),
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.onSurface,
                              width: 1.5.w,
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          CardUtils.getCardBrandIcon(card.cardBrand),
                          width: 40.w,
                        ),
                        Gap(12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: card.maskedNumber,
                                size: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              Gap(2.h),
                              CustomText(
                                text: 'Expires ${card.expiry}',
                                size: 12,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                        if (card.isDefault)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurface,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: CustomText(
                              text: 'DEFAULT',
                              size: 9,
                              color: Theme.of(context).colorScheme.surface,
                              spacing: 1,
                            ),
                          ),
                        if (isSelected)
                          Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 20.w,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
              GestureDetector(
                onTap: _openCard,
                child: _CustomContainer(
                  text: "Add New Card",
                  iconData: Icons.add,
                  isFree: false,
                ),
              ),
              Gap(20.h),
            ],

            savedCard != null && hasAddress && savedCards.isEmpty
                ? const SizedBox.shrink()
                : savedCards.isEmpty
                    ? CustomText(
                        text: "PAYMENT METHOD",
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )
                    : const SizedBox.shrink(),
            savedCards.isEmpty ? Gap(10.h) : const SizedBox.shrink(),

            savedCards.isEmpty
                ? savedCard != null
                    ? Column(
                        children: [
                          const Divider(),
                          Gap(10.h),
                          Row(
                            children: [
                              SvgPicture.asset(
                                CardUtils.getCardBrandIcon(
                                  _selectedSavedCard?.cardBrand ?? 'mastercard',
                                ),
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
                                    final brandName = CardUtils.getCardBrandName(
                                      _selectedSavedCard?.cardBrand ?? 'mastercard',
                                    );
                                    return CustomText(
                                      text:
                                          "$brandName ending \u2022\u2022\u2022\u2022$suffix",
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
                        onTap: _openCard,
                        child: const _CustomContainer(
                          text: "Select payment method",
                          iconData: Icons.arrow_drop_down,
                          isFree: false,
                        ),
                      )
                : const SizedBox.shrink(),

            Gap(30.h),
            savedCard != null && hasAddress
                ? _buildCartItemsList()
                : const SizedBox.shrink(),
            Gap(30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Total",
                  color: Theme.of(context).colorScheme.onSurface,
                  spacing: 3,
                ),
                CustomText(
                  text: "\$ ${widget.total.toStringAsFixed(2)}",
                  color: Colors.red.shade200,
                ),
              ],
            ),
            Gap(20.h),
            CustomButton(
              isSvg: true,
              title: "PLACE ORDER",
              onTap: () {
                _placeOrderAndConfirm();
              },
            ),
            Gap(60.h),
            ],
          ),
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
                      CustomText(
                        text: item.productName,
                        size: 13,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      SizedBox(height: 2.h),
                      CustomText(
                        text: 'Qty: ${item.quantity}',
                        size: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                CustomText(
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
    final orderId = IdGenerator.generateOrderId();
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
                  CustomText(
                    text: "PAYMENT SUCCESS",
                    spacing: 2,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 19,
                  ),
                  Gap(40.h),
                  SvgPicture.asset("assets/pop/done.svg"),
                  Gap(40.h),
                  CustomText(
                    text: "Your payment was success",
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  Gap(10.h),
                  CustomText(
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
                  CustomText(
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
                        child: CustomButton(
                          isSvg: false,
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
                        child: CustomButton(
                          isSvg: false,
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
          CustomText(text: text, color: colorScheme.onSurfaceVariant),
          const Spacer(),
          if (isFree)
            CustomText(text: "FREE", color: colorScheme.onSurfaceVariant),
          Icon(iconData, color: colorScheme.onSurface),
        ],
      ),
    );
  }
}
