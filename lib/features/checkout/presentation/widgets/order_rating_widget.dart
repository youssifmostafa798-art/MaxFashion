import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/widgets/custom_text.dart';

class OrderRatingWidget extends StatefulWidget {
  const OrderRatingWidget({super.key});

  @override
  State<OrderRatingWidget> createState() => _OrderRatingWidgetState();
}

class _OrderRatingWidgetState extends State<OrderRatingWidget> {
  int _selectedRating = 0;

  static const _ratingMessages = {
    0: 'Rate your experience',
    1: 'We can do better',
    2: 'Thanks for your feedback',
    3: 'Good',
    4: 'Great',
    5: 'Excellent!',
  };

  void _onStarTap(int rating) {
    HapticUtils.selection();
    setState(() {
      _selectedRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isSelected = starIndex <= _selectedRating;

            return GestureDetector(
              onTap: () => _onStarTap(starIndex),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                  child: Icon(
                    key: ValueKey('$starIndex-$isSelected'),
                    isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 40.w,
                    color: isSelected
                        ? const Color(0xFFFFB800)
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }),
        ),
        Gap(12.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: CustomText(
            key: ValueKey(_selectedRating),
            text: _ratingMessages[_selectedRating]!,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
