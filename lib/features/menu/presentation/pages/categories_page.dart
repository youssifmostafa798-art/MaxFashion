import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/features/search/presentation/pages/search_screen.dart';
import 'package:max/data/providers/search_provider.dart';

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
        title: CustemText(
          text: 'MENU',
          size: 18,
          color: colorScheme.onSurface,
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
                const _SearchBar(),
                SizedBox(height: 20.h),
                const _SectionTitle('CATEGORIES'),
                SizedBox(height: 12.h),
                const _CategoryGrid(),
                SizedBox(height: 24.h),
                const _SectionTitle('SHOP BY'),
                SizedBox(height: 12.h),
                const _ShopByList(),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SearchScreen(
              searchContext: SearchContextType.category,
            ),
          ),
        );
      },
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 14.w),
              child: Icon(Icons.search, color: colorScheme.onSurfaceVariant, size: 20.w),
            ),
            SizedBox(width: 10.w),
            CustemText(
              text: 'Search categories...',
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return CustemText(
      text: title,
      size: 14,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      spacing: 3,
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid();

  static const _categories = [
    _CategoryItem('Men', Icons.male),
    _CategoryItem('Women', Icons.female),
    _CategoryItem('Kids', Icons.child_care),
    _CategoryItem('Shoes', Icons.shopping_bag_outlined),
    _CategoryItem('Accessories', Icons.watch_outlined),
    _CategoryItem('Brands', Icons.star_border),
    _CategoryItem('Sale', Icons.local_offer_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        return _CategoryItemWidget(cat: _categories[index]);
      },
    );
  }
}

class _CategoryItemWidget extends StatelessWidget {
  const _CategoryItemWidget({required this.cat});
  final _CategoryItem cat;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(
            cat.icon,
            color: isSale ? AppColors.accent : colorScheme.onSurface,
            size: 28.w,
          ),
        ),
        SizedBox(height: 6.h),
        CustemText(
          text: cat.label,
          size: 11,
          color: isSale ? AppColors.accent : colorScheme.onSurface,
        ),
      ],
    );
  }
}

class _ShopByList extends StatelessWidget {
  const _ShopByList();

  static const _items = [
    _ShopByItem('New Arrivals', Icons.new_releases_outlined),
    _ShopByItem('Trending Now', Icons.trending_up),
    _ShopByItem('Best Sellers', Icons.thumb_up_outlined),
    _ShopByItem('Online Exclusive', Icons.language),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: _items.map((item) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(item.icon, color: colorScheme.onSurface, size: 22.w),
              SizedBox(width: 14.w),
              Expanded(
                child: CustemText(
                  text: item.label,
                  size: 14,
                  color: colorScheme.onSurface,
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant, size: 20.w),
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
