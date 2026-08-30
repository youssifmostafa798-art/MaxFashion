import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/widgets/dialog/guest_prompt_dialog.dart';
import 'package:max/data/providers/address_provider.dart';
import 'package:max/data/providers/orders_provider.dart';
import 'package:max/data/providers/payment_card_provider.dart';
import 'package:max/data/providers/wishlist_provider.dart';
import 'package:max/features/orders/presentation/pages/orders_page.dart';
import 'package:max/features/profile/presentation/pages/addresses_page.dart';
import 'package:max/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:max/features/profile/presentation/pages/payment_methods_page.dart';
import 'package:max/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:max/features/settings/presentation/pages/settings_page.dart';
import 'package:max/features/wishlist/presentation/pages/wishlist_page.dart';

class ProfileMenuSection extends ConsumerWidget {
  const ProfileMenuSection({super.key, required this.isGuest});
  final bool isGuest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final ordersCount = ref.watch(ordersCountProvider);
    final wishlistCount = ref.watch(wishlistCountProvider);
    final addressCount = ref.watch(addressCountProvider);
    final cardCount = ref.watch(paymentCardCountProvider);

    void onProtectedTap(String feature) {
      showGuestPromptDialog(
        context: context,
        message: l10n.pleaseSignInToAccessFeature(feature),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: l10n.accountSection,
          size: 12,
          color: colorScheme.onSurfaceVariant,
          spacing: 3,
        ),
        SizedBox(height: 12.h),
        ProfileMenuItem(
          icon: Icons.edit_outlined,
          title: l10n.editProfileMenu,
          onTap: isGuest
              ? () => onProtectedTap(l10n.featureProfileEditing)
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                },
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.shopping_bag_outlined,
          title: l10n.myOrdersMenu,
          trailing: ordersCount > 0 ? '$ordersCount' : null,
          onTap: isGuest
              ? () => onProtectedTap(l10n.featureYourOrders)
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrdersPage()),
                  );
                },
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.favorite_border,
          title: l10n.wishlistMenu,
          trailing: wishlistCount > 0 ? '$wishlistCount' : null,
          onTap: isGuest
              ? () => onProtectedTap(l10n.featureYourWishlist)
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WishlistPage()),
                  );
                },
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.location_on_outlined,
          title: l10n.addressesMenu,
          trailing: addressCount > 0 ? '$addressCount' : null,
          onTap: isGuest
              ? () => onProtectedTap(l10n.featureYourAddresses)
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddressesPage()),
                  );
                },
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.credit_card_outlined,
          title: l10n.paymentMethodsMenu,
          trailing: cardCount > 0 ? '$cardCount' : null,
          onTap: isGuest
              ? () => onProtectedTap(l10n.featurePaymentMethods)
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PaymentMethodsPage()),
                  );
                },
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.settings_outlined,
          title: l10n.settingsMenu,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
        ),
      ],
    );
  }
}
