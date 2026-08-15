import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/features/search/presentation/pages/search_screen.dart';
import 'package:max/data/providers/search_provider.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/features/product/presentation/pages/product_listing_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
        HapticUtils.light();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const SearchScreen(searchContext: SearchContextType.category),
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
              child: Icon(
                Icons.search,
                color: colorScheme.onSurfaceVariant,
                size: 20.w,
              ),
            ),
            SizedBox(width: 10.w),
            CustomText(
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
    return CustomText(
      text: title,
      size: 14,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      spacing: 3,
    );
  }
}

class _CategoryGrid extends ConsumerWidget {
  const _CategoryGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

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
        return _CategoryItemWidget(category: categories[index], index: index);
      },
    );
  }
}

class _CategoryItemWidget extends StatefulWidget {
  const _CategoryItemWidget({required this.category, required this.index});
  final CategoryModel category;
  final int index;

  @override
  State<_CategoryItemWidget> createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<_CategoryItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final category = widget.category;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTap: () {
            HapticUtils.light();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductListingPage(category: category.name),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.asset(
                    category.iconAssetPath,
                    width: 64.w,
                    height: 64.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              CustomText(
                text: category.name,
                size: 11,
                color: colorScheme.onSurface,
              ),
            ],
          ),
        ),
      ),
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
      children: _items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 80)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 12 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Container(
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
                  child: CustomText(
                    text: item.label,
                    size: 14,
                    color: colorScheme.onSurface,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                  size: 20.w,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ShopByItem {
  final String label;
  final IconData icon;

  const _ShopByItem(this.label, this.icon);
}
