import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/utils/date_formatter.dart';
import 'package:max/core/widgets/custom_text.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'YOU',
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
            _ProfileHeader(user: user),
            SizedBox(height: 24.h),
            const _MenuSection(),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});
  final UserModel? user;

  String _getMemberSinceText() {
    if (user == null) return 'Member since —';
    return 'Member since ${DateFormatter.formatMonthYear(user!.memberSince)}';
  }

  @override
  Widget build(BuildContext context) {
    final displayName = user?.fullName ?? 'Guest User';
    final displayEmail = user?.email ?? 'guest@example.com';
    final displayPhone = user?.phoneNumber ?? '';
    final displayGender = user?.gender ?? '';
    final displayCountry = user?.country ?? '';
    final displayDob = user?.dateOfBirth;
    final displayBio = user?.bio ?? '';
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: user == null
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
            if (displayPhone.isNotEmpty) ...[
              SizedBox(height: 4.h),
              CustomText(
                text: displayPhone,
                size: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
            if (displayGender.isNotEmpty) ...[
              SizedBox(height: 4.h),
              CustomText(
                text: displayGender,
                size: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
            if (displayCountry.isNotEmpty) ...[
              SizedBox(height: 4.h),
              CustomText(
                text: displayCountry,
                size: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
            if (displayDob != null) ...[
              SizedBox(height: 4.h),
              CustomText(
                text: DateFormatter.formatDateNumeric(displayDob),
                size: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
            if (displayBio.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomText(
                  text: displayBio,
                  size: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            SizedBox(height: 4.h),
            CustomText(
              text: _getMemberSinceText(),
              size: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends ConsumerWidget {
  const _MenuSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final ordersCount = ref.watch(ordersCountProvider);
    final wishlistCount = ref.watch(wishlistCountProvider);
    final addressCount = ref.watch(addressCountProvider);
    final cardCount = ref.watch(paymentCardCountProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'ACCOUNT',
          size: 12,
          color: colorScheme.onSurfaceVariant,
          spacing: 3,
        ),
        SizedBox(height: 12.h),
        ProfileMenuItem(
          icon: Icons.edit_outlined,
          title: 'Edit Profile',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfilePage()),
            );
          },
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.shopping_bag_outlined,
          title: 'My Orders',
          trailing: ordersCount > 0 ? '$ordersCount' : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersPage()),
            );
          },
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.favorite_border,
          title: 'Wishlist',
          trailing: wishlistCount > 0 ? '$wishlistCount' : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WishlistPage()),
            );
          },
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.location_on_outlined,
          title: 'Addresses',
          trailing: addressCount > 0 ? '$addressCount' : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddressesPage()),
            );
          },
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.credit_card_outlined,
          title: 'Payment Methods',
          trailing: cardCount > 0 ? '$cardCount' : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PaymentMethodsPage()),
            );
          },
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.settings_outlined,
          title: 'Settings',
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
