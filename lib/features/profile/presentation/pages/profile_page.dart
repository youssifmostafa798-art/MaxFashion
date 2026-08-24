import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/utils/date_formatter.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/widgets/dialog/guest_prompt_dialog.dart';
import 'package:max/data/models/user_model.dart';
import 'package:max/data/providers/address_provider.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/providers/orders_provider.dart';
import 'package:max/data/providers/payment_card_provider.dart';
import 'package:max/data/providers/wishlist_provider.dart';
import 'package:max/features/orders/presentation/pages/orders_page.dart';
import 'package:max/features/profile/presentation/pages/addresses_page.dart';
import 'package:max/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:max/features/profile/presentation/pages/payment_methods_page.dart';
import 'package:max/features/profile/presentation/widgets/profile_avatar_widget.dart';
import 'package:max/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:max/features/settings/presentation/pages/settings_page.dart';
import 'package:max/features/wishlist/presentation/pages/wishlist_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final isGuest = authState.isGuest;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: l10n.youTitle,
          size: 18,
          color: colorScheme.onSurface,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            _ProfileHeader(user: user, isGuest: isGuest),
            SizedBox(height: 24.h),
            _MenuSection(isGuest: isGuest),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user, required this.isGuest});
  final UserModel? user;
  final bool isGuest;

  String _getMemberSinceText(AppLocalizations l10n) {
    if (user == null) return l10n.memberSinceFallback;
    return l10n.memberSince(
      DateFormatter.formatMonthYear(user!.memberSince, locale: l10n.localeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayName = user?.fullName ?? l10n.guestUser;
    final displayEmail = user?.email ?? 'guest@example.com';
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isGuest
          ? () {
              Navigator.pushNamed(context, AppRouter.signup);
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.outline,
              ),
              child: ProfileAvatar(
                avatarUrl: user?.profileImage,
                radius: 40,
              ),
            ),
            SizedBox(height: 14.h),
            CustomText(
              text: displayName,
              size: 18,
              weight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: displayEmail,
              size: 13,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: _getMemberSinceText(l10n),
              size: 12,
              color: colorScheme.onSurfaceVariant,
            ),
            if (isGuest) ...[
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.login);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: CustomText(
                    text: l10n.signIn,
                    size: 14,
                    color: colorScheme.surface,
                    spacing: 2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends ConsumerWidget {
  const _MenuSection({required this.isGuest});
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
