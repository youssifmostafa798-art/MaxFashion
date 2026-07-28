import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/features/auth/presentation/pages/login_page.dart';
import 'package:max/features/auth/presentation/pages/signup_page.dart';
import 'package:max/features/auth/presentation/widgets/custom_auth_button.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Text(
                'MAX',
                style: TextStyle(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 12,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'FASHION',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 6,
                  color: AppColors.grey500,
                ),
              ),
              const Spacer(flex: 3),
              CustomAuthButton(
                text: 'Sign Up',
                isOutlined: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupPage()),
                  );
                },
              ),
              SizedBox(height: 16.h),
              CustomAuthButton(
                text: 'Login',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
              ),
              SizedBox(height: 32.h),
              Text(
                'Continue as Guest',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey500,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.grey500,
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
