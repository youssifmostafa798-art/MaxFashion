import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';

class CustemTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;

  const CustemTextField({super.key, required this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Please fill the field';
        return null;
      },
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.grey400),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey300, width: 1.2.w),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5.w),
        ),
      ),
    );
  }
}
