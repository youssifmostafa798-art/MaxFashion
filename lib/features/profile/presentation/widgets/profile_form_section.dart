import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/utils/list_extensions.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/theme/app_text_styles.dart';
import 'package:max/core/widgets/custom_text.dart';

class ProfileFormSection extends StatelessWidget {
  const ProfileFormSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          size: 12,
          color: colorScheme.onSurfaceVariant,
          spacing: 3,
        ),
        SizedBox(height: 12.h),
        ...children.intersperse(SizedBox(height: 20.h)),
      ],
    );
  }
}

class ProfileFormField extends StatelessWidget {
  const ProfileFormField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.readOnly = false,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.suffixIcon,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final String? label;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? maxLength;
  final IconData? suffixIcon;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          CustomText(
            text: label!,
            size: 12,
            color: colorScheme.onSurfaceVariant,
            spacing: 2,
          ),
          SizedBox(height: 6.h),
        ],
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          cursorColor: colorScheme.onSurface,
          style: TextStyle(
            fontSize: AppTextStyles.fontSize14,
            color: readOnly ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
            fontFamily: AppConstants.fontFamily,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: AppTextStyles.fontSize14,
              fontFamily: AppConstants.fontFamily,
            ),
            counterText: '',
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Icon(
                      suffixIcon,
                      color: colorScheme.onSurfaceVariant,
                      size: 18.w,
                    ),
                  )
                : null,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.outline,
                width: 1.2.w,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.onSurface,
                width: 1.5.w,
              ),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.errorRed400,
                width: 1.2.w,
              ),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.errorRed400,
                width: 1.5.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileFormDropdown extends StatelessWidget {
  const ProfileFormDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hint,
    this.label,
  });

  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          CustomText(
            text: label!,
            size: 12,
            color: colorScheme.onSurfaceVariant,
            spacing: 2,
          ),
          SizedBox(height: 6.h),
        ],
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: colorScheme.onSurfaceVariant,
            size: 22.w,
          ),
          style: TextStyle(
            fontSize: AppTextStyles.fontSize14,
            color: colorScheme.onSurface,
            fontFamily: AppConstants.fontFamily,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: AppTextStyles.fontSize14,
              fontFamily: AppConstants.fontFamily,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.outline,
                width: 1.2.w,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.onSurface,
                width: 1.5.w,
              ),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
