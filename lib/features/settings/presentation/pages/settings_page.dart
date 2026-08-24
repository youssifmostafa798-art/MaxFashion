import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/l10n/language_provider.dart';
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
    final locale = ref.watch(localeProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final authState = ref.watch(authStateProvider);
    final isGuest = authState.isGuest;

    final l10n = AppLocalizations.of(context)!;
    final languageDisplayName = locale.languageCode == 'ar'
        ? l10n.arabicLanguageName
        : l10n.englishLanguageName;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.arrow_forward
                : Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          text: l10n.settingsTitle,
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
              title: l10n.generalSection,
              children: [
                SettingsTile(
                  icon: Icons.language_outlined,
                  title: l10n.languageLabel,
                  subtitle: languageDisplayName,
                  onTap: () => _showLanguagePicker(context, ref),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SettingsSection(
              title: l10n.appearanceSection,
              children: [_ThemeSelector(themeMode: themeMode, ref: ref)],
            ),
            SizedBox(height: 24.h),
            SettingsSection(
              title: l10n.notificationsSection,
              children: [
                SettingsTileSwitch(
                  icon: Icons.notifications_outlined,
                  title: l10n.pushNotifications,
                  subtitle: l10n.pushNotificationsSubtitle,
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
              title: l10n.privacySection,
              children: [
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: l10n.privacyPolicy,
                  onTap: () => _showPlaceholder(context, l10n.privacyPolicy),
                ),
                SettingsTile(
                  icon: Icons.description_outlined,
                  title: l10n.termsConditions,
                  onTap: () => _showPlaceholder(context, l10n.termsConditions),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SettingsSection(
              title: l10n.supportSection,
              children: [
                SettingsTile(
                  icon: Icons.support_agent_outlined,
                  title: l10n.contactSupport,
                  subtitle: l10n.contactSupportSubtitle,
                  onTap: () => _showPlaceholder(context, l10n.contactSupport),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SettingsSection(
              title: l10n.aboutSection,
              children: [
                SettingsTile(
                  icon: Icons.info_outline,
                  title: l10n.aboutApp,
                  subtitle: l10n.versionLabel,
                  onTap: () => _showAboutDialog(context),
                ),
                SettingsTile(
                  icon: isGuest ? Icons.login : Icons.logout,
                  title: isGuest ? l10n.signInSection : l10n.logoutSection,
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
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.comingSoon(title))));
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final languages = [
      (locale: const Locale('en'), name: l10n.englishLanguageName),
      (locale: const Locale('ar'), name: l10n.arabicLanguageName),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colorScheme.outline,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: l10n.languageLabel,
                size: 16,
                weight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              SizedBox(height: 8.h),
              ...languages.map((lang) {
                final isSelected = currentLocale.languageCode ==
                    lang.locale.languageCode;
                return ListTile(
                  title: CustomText(
                    text: lang.name,
                    size: 14,
                    color: isSelected
                        ? AppColors.accent
                        : colorScheme.onSurface,
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check, color: AppColors.accent, size: 20.w)
                      : null,
                  onTap: () {
                    ref
                        .read(localeProvider.notifier)
                        .setLocale(lang.locale);
                    Navigator.pop(context);
                  },
                );
              }),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showAboutDialog(
      context: context,
      applicationName: 'MaxFashion',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.checkroom,
        size: 40.w,
        color: AppColors.accent,
      ),
      children: [Text(l10n.aboutDescription)],
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
    final l10n = AppLocalizations.of(context)!;

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
              CustomText(text: l10n.themeLabel, size: 14, color: colorScheme.onSurface),
            ],
          ),
          SizedBox(height: 12.h),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text(l10n.themeLight, style: const TextStyle(fontSize: 12)),
                icon: const Icon(Icons.light_mode),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text(l10n.themeDark, style: const TextStyle(fontSize: 12)),
                icon: const Icon(Icons.dark_mode),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text(l10n.themeSystem, style: const TextStyle(fontSize: 12)),
                icon: const Icon(Icons.settings_brightness),
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
