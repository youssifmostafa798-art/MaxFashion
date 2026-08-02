import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.size = 16,
    this.weight = FontWeight.normal,
    this.color,
    this.height = 1,
    this.spacing = 1,
  });
  final String text;
  final double size;
  final FontWeight weight;
  final Color? color;
  final double height;
  final double spacing;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        letterSpacing: spacing,
        fontSize: size.sp,
        color: color ?? Theme.of(context).colorScheme.onSurface,
        fontWeight: weight,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'Tenor_Sans',
        height: height,
      ),
    );
  }
}
