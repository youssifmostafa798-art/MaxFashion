import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/features/menu/presentation/widgets/category_grid.dart';
import 'package:max/features/menu/presentation/widgets/menu_search_bar.dart';
import 'package:max/features/menu/presentation/widgets/menu_section_title.dart';
import 'package:max/features/menu/presentation/widgets/shop_by_list.dart';
import 'package:max/features/menu/presentation/pages/all_categories_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'MENU',
          size: 18,
          color: colorScheme.onSurface,
          spacing: 4,
          weight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              const MenuSearchBar(),
              SizedBox(height: 20.h),
              const MenuSectionTitle('CATEGORIES'),
              SizedBox(height: 12.h),
              CategoryGrid(
                showPreview: true,
                onSeeMoreTap: () {
                  HapticUtils.light();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AllCategoriesPage(),
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),
              const MenuSectionTitle('SHOP BY'),
              SizedBox(height: 12.h),
              const ShopByList(),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
