import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/features/auth/presentation/widgets/custom_auth_button.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              Image.asset(
                'assets/logo/logo.png',
                width: 120.w,
                height: 120.w,
                cacheWidth: 120,
              ),
              const Spacer(flex: 3),
              CustomAuthButton(
                text: 'Create Account',
                isOutlined: true,
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.signup);
                },
              ),
              SizedBox(height: 16.h),
              CustomAuthButton(
                text: 'Already have account',
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.login);
                },
              ),
              SizedBox(height: 32.h),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRouter.main);
                },
                child: Text(
                  'Continue as Guest',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey500,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.grey500,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
