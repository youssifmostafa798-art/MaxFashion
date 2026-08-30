import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/utils/date_formatter.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/user_model.dart';
import 'package:max/features/profile/presentation/widgets/profile_avatar_widget.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user, required this.isGuest});
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
