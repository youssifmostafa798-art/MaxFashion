import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/constants/app_constants.dart';

class AppTextStyles {
  const AppTextStyles._();

  // Numeric font size values (preserving exact .sp values from the codebase)
  static double get fontSize9 => 9.sp;
  static double get fontSize12 => 12.sp;
  static double get fontSize13 => 13.sp;
  static double get fontSize14 => 14.sp;
  static double get fontSize15 => 15.sp;
  static double get fontSize18 => 18.sp;
  static double get fontSize32 => 32.sp;

  // Combined: fontSize 14 + Tenor Sans font (most common inline TextStyle pattern)
  static TextStyle get bodyMediumTenor => TextStyle(
    fontSize: 14.sp,
    fontFamily: AppConstants.fontFamily,
  );
}
