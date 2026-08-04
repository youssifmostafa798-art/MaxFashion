import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:max/features/checkout/presentation/widgets/checkout_address_section.dart';
import 'package:max/features/checkout/presentation/widgets/checkout_cart_items_list.dart';
import 'package:max/features/checkout/presentation/widgets/checkout_container.dart';
import 'package:max/features/checkout/presentation/widgets/order_success_dialog.dart';
import 'package:max/features/checkout/presentation/widgets/saved_card_tile.dart';
import 'package:max/features/checkout/presentation/widgets/selected_payment_display.dart';
import 'package:max/features/checkout/presentation/widgets/validation_dialog.dart';
import 'package:max/features/profile/presentation/pages/addresses_page.dart';

import 'package:max/core/utils/card_utils.dart';
import 'package:max/core/utils/id_generator.dart';
import 'package:max/core/widgets/header.dart';
import 'package:max/core/theme/app_colors.dart';


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
      showValidationDialog(
        context: context,
        title: 'MISSING INFORMATION',
        message: 'Please add a shipping address',
      );
      return false;
    }
    if (savedCard == null) {
      showValidationDialog(
        context: context,
        title: 'MISSING INFORMATION',
        message: 'Please select a payment method',
      );
      return false;
    }
    return true;
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
    showOrderSuccessDialog(context: context, orderId: order.orderId);
  }

  String _buildPaymentString() {
    if (savedCard == null) return '';
    final numStr = savedCard!['number'].toString();
    final suffix = numStr.length >= 2
        ? numStr.substring(numStr.length - 2)
        : numStr;
    return 'Master Card ending \u2022\u2022\u2022\u2022$suffix';
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
                ? CheckoutAddressSection(
                    hasAddress: hasAddress,
                    defaultAddress: defaultAddress,
                    user: user,
                    onTap: _openAddresses,
                  )
                : const SizedBox.shrink(),

            !hasAddress
                ? GestureDetector(
                    onTap: () {
                      _openAddresses();
                    },
                    child: const CheckoutContainer(
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
                : const CheckoutContainer(
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
                return SavedCardTile(
                  card: card,
                  isSelected: isSelected,
                  onTap: () => _selectSavedCard(card),
                );
              }),
              GestureDetector(
                onTap: _openCard,
                child: const CheckoutContainer(
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
                    ? SelectedPaymentDisplay(
                        savedCard: savedCard!,
                        selectedCardBrand: _selectedSavedCard?.cardBrand ?? 'mastercard',
                      )
                    : GestureDetector(
                        onTap: _openCard,
                        child: const CheckoutContainer(
                          text: "Select payment method",
                          iconData: Icons.arrow_drop_down,
                          isFree: false,
                        ),
                      )
                : const SizedBox.shrink(),

            Gap(30.h),
            savedCard != null && hasAddress
                ? CheckoutCartItemsList(cartItems: widget.cartItems)
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
                  color: AppColors.errorRed200,
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
}
