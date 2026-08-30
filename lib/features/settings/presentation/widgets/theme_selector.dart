import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/theme/theme_provider.dart';
import 'package:max/core/widgets/custom_text.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key, required this.themeMode, required this.ref});
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
