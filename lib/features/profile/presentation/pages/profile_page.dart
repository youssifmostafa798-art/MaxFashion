import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/features/profile/presentation/widgets/profile_menu_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const CustemText(
          text: 'YOU',
          size: 18,
          color: AppColors.primary,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            const _ProfileHeader(),
            SizedBox(height: 24.h),
            const _MenuSection(),
            SizedBox(height: 24.h),
            const _LogoutButton(),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.grey300,
            ),
            child: Icon(Icons.person, size: 44.w, color: AppColors.white),
          ),
          SizedBox(height: 14.h),
          const CustemText(
            text: 'Alex Johnson',
            size: 18,
            weight: FontWeight.w700,
            color: AppColors.primary,
          ),
          SizedBox(height: 4.h),
          const CustemText(
            text: 'alex.johnson@email.com',
            size: 13,
            color: AppColors.grey500,
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustemText(
          text: 'ACCOUNT',
          size: 12,
          color: AppColors.grey500,
          spacing: 3,
        ),
        SizedBox(height: 12.h),
        ProfileMenuItem(
          icon: Icons.edit_outlined,
          title: 'Edit Profile',
          onTap: () {},
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.shopping_bag_outlined,
          title: 'My Orders',
          trailing: '3',
          onTap: () {},
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.favorite_border,
          title: 'Wishlist',
          trailing: '8',
          onTap: () {},
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.location_on_outlined,
          title: 'Addresses',
          trailing: '2',
          onTap: () {},
        ),
        SizedBox(height: 10.h),
        ProfileMenuItem(
          icon: Icons.settings_outlined,
          title: 'Settings',
          onTap: () {},
        ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return ProfileMenuItem(
      icon: Icons.logout,
      title: 'Logout',
      isDestructive: true,
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouter.auth,
          (route) => false,
        );
      },
    );
  }
}
