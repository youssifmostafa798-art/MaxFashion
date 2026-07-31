import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_text.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.size = 16,
    this.color,
    this.weight = FontWeight.normal,
    this.highlightColor,
    this.spacing = 1,
  });

  final String text;
  final String query;
  final double size;
  final Color? color;
  final FontWeight weight;
  final Color? highlightColor;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? colorScheme.onSurface;
    final effectiveHighlight = highlightColor ?? colorScheme.onSurface;

    if (query.trim().isEmpty) {
      return CustemText(
        text: text,
        size: size,
        color: effectiveColor,
        weight: weight,
        spacing: spacing,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.trim().toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(
          text: text.substring(start),
          style: TextStyle(
            fontSize: size.sp,
            color: effectiveColor,
            fontWeight: weight,
            fontFamily: 'Tenor_Sans',
            letterSpacing: spacing,
          ),
        ));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: TextStyle(
            fontSize: size.sp,
            color: effectiveColor,
            fontWeight: weight,
            fontFamily: 'Tenor_Sans',
            letterSpacing: spacing,
          ),
        ));
      }

      spans.add(TextSpan(
        text: text.substring(index, index + lowerQuery.length),
        style: TextStyle(
          fontSize: size.sp,
          color: effectiveHighlight,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tenor_Sans',
          letterSpacing: spacing,
          decoration: TextDecoration.underline,
          decorationThickness: 1.5,
        ),
      ));

      start = index + lowerQuery.length;
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
