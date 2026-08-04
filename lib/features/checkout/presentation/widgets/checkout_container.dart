import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';

class CheckoutContainer extends StatelessWidget {
  const CheckoutContainer({
    super.key,
    required this.text,
    required this.iconData,
    required this.isFree,
  });

  final String text;
  final IconData iconData;
  final bool isFree;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: text, color: colorScheme.onSurfaceVariant),
          const Spacer(),
          if (isFree)
            CustomText(text: "FREE", color: colorScheme.onSurfaceVariant),
          Icon(iconData, color: colorScheme.onSurface),
        ],
      ),
    );
  }
}
