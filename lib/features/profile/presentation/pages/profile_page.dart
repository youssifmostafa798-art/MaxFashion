import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/widgets/skeletons/profile_skeleton.dart';
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/features/profile/presentation/widgets/profile_header.dart';
import 'package:max/features/profile/presentation/widgets/profile_menu_section.dart';

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
      body: authState.isLoading
          ? const ProfileSkeleton()
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            ProfileHeader(user: user, isGuest: isGuest),
            SizedBox(height: 24.h),
            ProfileMenuSection(isGuest: isGuest),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
