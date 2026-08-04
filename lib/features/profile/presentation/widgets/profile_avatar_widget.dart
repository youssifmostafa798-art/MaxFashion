import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.avatarUrl,
    this.onTap,
    this.radius = 50,
    this.showCameraIcon = false,
  });

  final String? avatarUrl;
  final VoidCallback? onTap;
  final double radius;
  final bool showCameraIcon;

  bool get _hasAvatar =>
      avatarUrl != null && avatarUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = radius * 2.w;

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.surfaceContainerHighest,
      ),
      child: _hasAvatar
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                gaplessPlayback: true,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultIcon(colorScheme),
              ),
            )
          : _buildDefaultIcon(colorScheme),
    );

    if (!showCameraIcon) {
      return onTap != null ? GestureDetector(onTap: onTap, child: avatar) : avatar;
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            avatar,
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2.w,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: colorScheme.surface,
                  size: 16.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultIcon(ColorScheme colorScheme) {
    return Center(
      child: Icon(
        Icons.account_circle_rounded,
        size: radius * 1.6.w,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
