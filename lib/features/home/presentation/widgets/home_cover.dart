import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';

class HomeCover extends StatelessWidget {
  const HomeCover({super.key, required this.homeContentAsync});

  final AsyncValue<dynamic> homeContentAsync;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return homeContentAsync.when(
      loading: () => ShimmerEffect(
        child: SkeletonBox(
          width: double.infinity,
          height: 200.h,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      error: (_, _) => _buildFallback(colorScheme),
      data: (homeContent) {
        final coverUrl = homeContent?.coverUrl;
        if (coverUrl == null || coverUrl.isEmpty) {
          return _buildFallback(colorScheme);
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            coverUrl,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return ShimmerEffect(
                child: SkeletonBox(
                  width: double.infinity,
                  height: 200.h,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                _buildFallback(colorScheme),
          ),
        );
      },
    );
  }

  Widget _buildFallback(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }
}
