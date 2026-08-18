import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:max/core/router/app_router.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/theme/theme_provider.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/features/profile/presentation/providers/edit_profile_provider.dart';
import 'package:max/features/settings/presentation/widgets/settings_section.dart';
import 'package:max/features/settings/presentation/widgets/settings_tile.dart';

final notificationsEnabledProvider = StateProvider<bool>((ref) => true);

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final authState = ref.watch(authStateProvider);
    final isGuest = authState.isGuest;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          text: 'SETTINGS',
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
            SettingsSection(
              title: 'GENERAL',
              children: [
                SettingsTile(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: 'English (US)',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Language selection coming soon'),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SettingsSection(
              title: 'APPEARANCE',
              children: [_ThemeSelector(themeMode: themeMode, ref: ref)],
            ),
            SizedBox(height: 24.h),
            SettingsSection(
              title: 'NOTIFICATIONS',
              children: [
                SettingsTileSwitch(
                  icon: Icons.notifications_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Receive order updates and promotions',
                  value: notificationsEnabled,
                  onChanged: (value) {
                    ref.read(notificationsEnabledProvider.notifier).state =
                        value;
                  },
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SettingsSection(
              title: 'PRIVACY',
              children: [
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => _showPlaceholder(context, 'Privacy Policy'),
                ),
                SettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  onTap: () => _showPlaceholder(context, 'Terms & Conditions'),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SettingsSection(
              title: 'SUPPORT',
              children: [
                SettingsTile(
                  icon: Icons.support_agent_outlined,
                  title: 'Contact Support',
                  subtitle: 'Get help with your account',
                  onTap: () => _showPlaceholder(context, 'Contact Support'),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SettingsSection(
              title: 'ABOUT',
              children: [
                SettingsTile(
                  icon: Icons.info_outline,
                  title: 'About App',
                  subtitle: 'Version 1.0.0',
                  onTap: () => _showAboutDialog(context),
                ),
                SettingsTile(
                  icon: isGuest ? Icons.login : Icons.logout,
                  title: isGuest ? 'Sign In' : 'Logout',
                  isDestructive: !isGuest,
                  onTap: () => _handleLogout(context, ref),
                ),
              ],
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  void _showPlaceholder(BuildContext context, String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title coming soon')));
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'MaxFashion',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.checkroom,
        size: 40.w,
        color: AppColors.accent,
      ),
      children: [const Text('Your premium fashion destination.')],
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final authState = ref.read(authStateProvider);
    if (authState.isGuest) {
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.auth, (route) => false);
      }
      return;
    }
    await ref.read(authStateProvider.notifier).logout();
    ref.invalidate(editProfileProvider);
    if (context.mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRouter.auth, (route) => false);
    }
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.themeMode, required this.ref});
  final ThemeMode themeMode;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.palette_outlined,
                color: colorScheme.onSurfaceVariant,
                size: 22.w,
              ),
              SizedBox(width: 14.w),
              CustomText(text: 'Theme', size: 14, color: colorScheme.onSurface),
            ],
          ),
          SizedBox(height: 12.h),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text('Light', style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text('Dark', style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.dark_mode),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text('System', style: TextStyle(fontSize: 12)),
                icon: Icon(Icons.settings_brightness),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (Set<ThemeMode> selected) {
              ref.read(themeProvider.notifier).setThemeMode(selected.first);
            },
          ),
        ],
      ),
    );
  }
}
