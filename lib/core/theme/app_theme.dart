import 'package:flutter/material.dart';
import 'package:max/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    colorScheme: const ColorScheme.light(
      surface: AppColors.white,
      onSurface: AppColors.black,
      surfaceContainerHighest: AppColors.grey100,
      outline: AppColors.grey200,
      onSurfaceVariant: AppColors.grey500,
      surfaceContainerHigh: AppColors.grey100,
      surfaceContainerLow: AppColors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: AppColors.black),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.black,
      unselectedItemColor: AppColors.grey500,
    ),
    dividerColor: AppColors.grey200,
    iconTheme: const IconThemeData(color: AppColors.black),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF121212),
      onSurface: Colors.white,
      surfaceContainerHighest: AppColors.blackMedium,
      outline: AppColors.grey800,
      onSurfaceVariant: AppColors.grey400,
      surfaceContainerHigh: AppColors.darkSurface,
      surfaceContainerLow: Color(0xFF121212),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: Colors.white,
      unselectedItemColor: AppColors.grey400,
    ),
    dividerColor: AppColors.grey800,
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
