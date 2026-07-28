import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';

class CustomAuthButton extends StatelessWidget {
  const CustomAuthButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.isOutlined = false,
  });

  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: isOutlined ? AppColors.transparent : AppColors.primary,
          borderRadius: BorderRadius.circular(8.r),
          border: isOutlined
              ? Border.all(color: AppColors.grey400, width: 1.w)
              : null,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOutlined ? AppColors.primary : AppColors.white,
                    ),
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: isOutlined ? AppColors.primary : AppColors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
