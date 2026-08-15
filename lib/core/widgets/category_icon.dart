import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({
    super.key,
    required this.assetPath,
    this.size = 64,
    this.borderRadius = 16,
    this.fit = BoxFit.cover,
  });

  final String assetPath;
  final double size;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: assetPath.isEmpty
            ? const SizedBox.shrink()
            : Image.asset(
                assetPath,
                width: size.w,
                height: size.w,
                fit: fit,
                color: colorScheme.onSurface,
                colorBlendMode: BlendMode.srcIn,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
      ),
    );
  }
}
