import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';
import 'package:max/data/models/collection_model.dart';

class CollectionCard extends StatefulWidget {
  const CollectionCard({
    super.key,
    required this.collection,
    required this.onTap,
  });

  final CollectionModel collection;
  final VoidCallback onTap;

  @override
  State<CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticUtils.light();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          width: AppConstants.collectionCardWidth.w,
          height: AppConstants.collectionCardHeight.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppConstants.collectionCardBorderRadius.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppConstants.collectionCardBorderRadius.r),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: AppConstants.collectionImageHeight.h,
                  child: _buildImage(colorScheme),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: widget.collection.name.toUpperCase(),
                      size: 12,
                      weight: FontWeight.bold,
                      spacing: 2,
                      maxLines: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ColorScheme colorScheme) {
    final imageUrl = widget.collection.fullImageUrl;

    if (imageUrl == null) {
      return _buildFallback(colorScheme);
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return ShimmerEffect(
          child: SkeletonBox(
            width: double.infinity,
            height: double.infinity,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _buildFallback(colorScheme),
    );
  }

  Widget _buildFallback(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_outlined,
        color: colorScheme.onSurfaceVariant,
        size: 32.w,
      ),
    );
  }
}
