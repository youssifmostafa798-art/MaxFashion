import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:max/core/theme/theme_provider.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/data/models/user_model.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/features/profile/presentation/widgets/profile_menu_item.dart';

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
        title: CustemText(
          text: 'YOU',
          size: 18,
          color: colorScheme.onSurface,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            _ProfileHeader(user: user),
            SizedBox(height: 24.h),
            const _MenuSection(),
            SizedBox(height: 24.h),
            const _AppearanceSection(),
            SizedBox(height: 24.h),
            _LogoutButton(ref: ref),
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
    final date = user!.memberSince;
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return 'Member since ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final displayName = user?.fullName ?? 'Guest User';
    final displayEmail = user?.email ?? 'guest@example.com';
    final displayPhone = user?.phoneNumber ?? '';
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
              child: user != null && user!.profileImage != null
                  ? ClipOval(
                      child: Image.network(
                        user!.profileImage!,
                        fit: BoxFit.cover,
                        width: 80.w,
                        height: 80.w,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.person,
                          size: 44.w,
                          color: colorScheme.surface,
                        ),
                      ),
                    )
                  : Icon(Icons.person, size: 44.w, color: colorScheme.surface),
            ),
            SizedBox(height: 14.h),
            CustemText(
              text: displayName,
              size: 18,
              weight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
            SizedBox(height: 4.h),
            CustemText(
              text: displayEmail,
              size: 13,
              color: colorScheme.onSurfaceVariant,
            ),
            if (displayPhone.isNotEmpty) ...[
              SizedBox(height: 4.h),
              CustemText(
                text: displayPhone,
                size: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
            SizedBox(height: 4.h),
            CustemText(
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

class _MenuSection extends StatelessWidget {
  const _MenuSection();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustemText(
          text: 'ACCOUNT',
          size: 12,
          color: colorScheme.onSurfaceVariant,
          spacing: 3,
        ),
        SizedBox(height: 12.h),
        ProfileMenuItem(
          icon: Icons.edit_outlined,
          title: 'Edit Profile',
          onTap: () {},
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.shopping_bag_outlined,
          title: 'My Orders',
          trailing: '3',
          onTap: () {},
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.favorite_border,
          title: 'Wishlist',
          trailing: '8',
          onTap: () {},
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.location_on_outlined,
          title: 'Addresses',
          trailing: '2',
          onTap: () {},
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.settings_outlined,
          title: 'Settings',
          onTap: () {},
        ),
      ],
    );
  }
}

class _AppearanceSection extends ConsumerWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustemText(
          text: 'APPEARANCE',
          size: 12,
          color: colorScheme.onSurfaceVariant,
          spacing: 3,
        ),
        SizedBox(height: 12.h),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment<ThemeMode>(
              value: ThemeMode.light,
              label: Text('Light'),
              icon: Icon(Icons.light_mode),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.dark,
              label: Text('Dark'),
              icon: Icon(Icons.dark_mode),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.system,
              label: Text('System'),
              icon: Icon(Icons.settings_brightness),
            ),
          ],
          selected: {themeMode},
          onSelectionChanged: (Set<ThemeMode> selected) {
            ref.read(themeProvider.notifier).setThemeMode(selected.first);
          },
        ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ProfileMenuItem(
      icon: Icons.logout,
      title: 'Logout',
      isDestructive: true,
      onTap: () async {
        await ref.read(authStateProvider.notifier).logout();
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.auth,
            (route) => false,
          );
        }
      },
    );
  }
}
