import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/data/providers/auth_provider.dart';

import 'package:max/core/widgets/custom_button.dart';
import 'package:max/features/checkout/presentation/pages/place_order.dart';
import 'package:max/features/main/presentation/pages/main_screen.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/errors/app_error_messages.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  String? _lastShownError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cartState = ref.watch(cartProvider);
    final authState = ref.watch(authStateProvider);
    final isGuest = authState.isGuest;
    final colorScheme = Theme.of(context).colorScheme;

    // Show error SnackBar when error changes
    ref.listen<CartState>(cartProvider, (previous, next) {
      if (next.error != null && next.error != _lastShownError) {
        _lastShownError = next.error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(
              text: AppErrorMessages.resolve(l10n, next.error),
              size: 14,
              color: colorScheme.surface,
            ),
            backgroundColor: colorScheme.error,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      }
      if (next.error == null) {
        _lastShownError = null;
      }
    });

    if (isGuest) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: CustomText(
            text: l10n.myBag.toUpperCase(),
            size: 18,
            color: colorScheme.onSurface,
            spacing: 4,
            weight: FontWeight.bold,
          ),
        ),
        body: _GuestCartView(),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: l10n.myBag.toUpperCase(),
          size: 18,
          color: colorScheme.onSurface,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: cartState.isLoading
          ? _CartLoading()
          : cartState.items.isEmpty
              ? _EmptyCart()
              : _CartContent(cartState: cartState),
    );
  }
}

class _CartLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          CustomText(
            text: l10n.loadingBag,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _CartContent extends ConsumerWidget {
  const _CartContent({required this.cartState});

  final CartState cartState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = cartState.items;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isUpdating = cartState.updatingItemId == item.id;
              return CartItemCard(
                itemId: item.id,
                image: item.productImage,
                title: item.productName,
                price: item.unitPrice,
                quantity: item.quantity,
                selectedColor: item.selectedColor,
                selectedSize: item.selectedSize,
                isUpdating: isUpdating,
                onIncrement: () => ref
                    .read(cartProvider.notifier)
                    .incrementQuantity(index),
                onDecrement: () => ref
                    .read(cartProvider.notifier)
                    .decrementQuantity(index),
                onRemove: () => ref.read(cartProvider.notifier).removeItem(
                      item.productId,
                      item.selectedColor,
                      item.selectedSize,
                    ),
              );
            },
          ),
        ),
        _CartBottomSection(isClearing: cartState.isClearing),
      ],
    );
  }
}

class _CartBottomSection extends ConsumerWidget {
  const _CartBottomSection({required this.isClearing});

  final bool isClearing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isCartEmpty = ref.watch(cartProvider.select((s) => s.items.isEmpty));
    final subtotal = ref.watch(cartSubtotalProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  text: l10n.subtotal, size: 14, color: colorScheme.onSurfaceVariant),
              CustomText(
                text: l10n.priceValue(subtotal.toStringAsFixed(2)),
                size: 14,
                color: colorScheme.onSurface,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  text: l10n.delivery, size: 14, color: colorScheme.onSurfaceVariant),
              CustomText(text: l10n.free, size: 14, color: AppColors.accent),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 1, color: colorScheme.outline),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: l10n.estimatedTotal,
                size: 16,
                weight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
              CustomText(
                text: l10n.priceValue(subtotal.toStringAsFixed(2)),
                size: 16,
                weight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          CustomButton(
            isSvg: true,
            title: l10n.checkout,
            onTap: isCartEmpty
                ? null
                : () {
                    HapticUtils.light();
                    final cartItems = ref.read(cartItemsProvider);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceOrder(
                          cartItems: cartItems,
                          total: subtotal,
                        ),
                      ),
                    );
                  },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80.w,
            color: colorScheme.outline,
          ),
          SizedBox(height: 20.h),
          CustomText(
            text: l10n.yourBagIsEmpty,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: l10n.addItemsToGetStarted,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 30.h),
          GestureDetector(
            onTap: () {
              HapticUtils.light();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const MainScreen(initialTab: 0)),
                (route) => false,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: CustomText(
                text: l10n.startShopping.toUpperCase(),
                size: 14,
                color: Theme.of(context).colorScheme.surface,
                spacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80.w,
            color: colorScheme.outline,
          ),
          SizedBox(height: 20.h),
          CustomText(
            text: l10n.signInToViewBag,
            size: 18,
            color: colorScheme.onSurface,
            weight: FontWeight.w600,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: l10n.saveItemsAcrossDevices,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 30.h),
          GestureDetector(
            onTap: () {
              HapticUtils.light();
              Navigator.pushNamed(context, AppRouter.login);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: CustomText(
                text: l10n.signIn.toUpperCase(),
                size: 14,
                color: colorScheme.surface,
                spacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
