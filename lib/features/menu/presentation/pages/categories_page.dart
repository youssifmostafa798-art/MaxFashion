import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/custem_text.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: CustemText(
          text: 'MENU',
          size: 18,
          color: AppColors.primary,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                _buildSearchBar(),
                SizedBox(height: 20.h),
                _buildSectionTitle('CATEGORIES'),
                SizedBox(height: 12.h),
                _buildCategoryGrid(),
                SizedBox(height: 24.h),
                _buildSectionTitle('SHOP BY'),
                SizedBox(height: 12.h),
                _buildShopByList(),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 14.w),
            child: Icon(Icons.search, color: AppColors.grey500, size: 20.w),
          ),
          SizedBox(width: 10.w),
          CustemText(
            text: 'Search categories...',
            size: 14,
            color: AppColors.grey400,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return CustemText(
      text: title,
      size: 14,
      color: AppColors.grey600,
      spacing: 3,
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      _CategoryItem('Men', Icons.male),
      _CategoryItem('Women', Icons.female),
      _CategoryItem('Kids', Icons.child_care),
      _CategoryItem('Shoes', Icons.shopping_bag_outlined),
      _CategoryItem('Accessories', Icons.watch_outlined),
      _CategoryItem('Brands', Icons.star_border),
      _CategoryItem('Sale', Icons.local_offer_outlined),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final cat = categories[index];
        return _buildCategoryItem(cat);
      },
    );
  }

  Widget _buildCategoryItem(_CategoryItem cat) {
    final bool isSale = cat.label == 'Sale';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: isSale
                ? AppColors.accent.withValues(alpha: 0.08)
                : AppColors.grey100,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(
            cat.icon,
            color: isSale ? AppColors.accent : AppColors.primary,
            size: 28.w,
          ),
        ),
        SizedBox(height: 6.h),
        CustemText(
          text: cat.label,
          size: 11,
          color: isSale ? AppColors.accent : AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildShopByList() {
    final items = [
      _ShopByItem('New Arrivals', Icons.new_releases_outlined),
      _ShopByItem('Trending Now', Icons.trending_up),
      _ShopByItem('Best Sellers', Icons.thumb_up_outlined),
      _ShopByItem('Online Exclusive', Icons.language),
    ];

    return Column(
      children: items.map((item) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(item.icon, color: AppColors.primary, size: 22.w),
              SizedBox(width: 14.w),
              Expanded(
                child: CustemText(
                  text: item.label,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.grey500, size: 20.w),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _CategoryItem {
  final String label;
  final IconData icon;

  const _CategoryItem(this.label, this.icon);
}

class _ShopByItem {
  final String label;
  final IconData icon;

  const _ShopByItem(this.label, this.icon);
}
