import 'package:flutter/material.dart';
import 'package:max/core/widgets/custom_text.dart';

class MenuSectionTitle extends StatelessWidget {
  const MenuSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: title,
      size: 14,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      spacing: 3,
    );
  }
}
