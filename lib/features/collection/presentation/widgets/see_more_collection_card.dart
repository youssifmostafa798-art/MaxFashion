import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/l10n/app_localizations.dart';

class SeeMoreCollectionCard extends StatefulWidget {
  const SeeMoreCollectionCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<SeeMoreCollectionCard> createState() => _SeeMoreCollectionCardState();
}

class _SeeMoreCollectionCardState extends State<SeeMoreCollectionCard>
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
    final l10n = AppLocalizations.of(context)!;
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
            borderRadius: BorderRadius.circular(
              AppConstants.collectionCardBorderRadius.r,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.onSurface,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: 24.w,
                  color: colorScheme.onSurface,
                ),
              ),
              Gap(10.h),
              CustomText(
                text: l10n.seeMore,
                size: 12,
                weight: FontWeight.bold,
                spacing: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
