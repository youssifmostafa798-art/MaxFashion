import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;

  const CustomTextField({super.key, required this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      controller: controller,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return l10n.fieldRequired;
        return null;
      },
      cursorColor: colorScheme.onSurface,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline, width: 1.2.w),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.onSurface, width: 1.5.w),
        ),
      ),
    );
  }
}
