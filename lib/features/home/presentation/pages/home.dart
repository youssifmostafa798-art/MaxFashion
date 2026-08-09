import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:max/core/widgets/custom_appbar.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/category_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/data/providers/home_content_provider.dart';
import 'package:max/features/product/presentation/pages/product_detail_page.dart';
import 'package:max/features/product/presentation/widgets/product_grid_card.dart';
import 'package:max/core/widgets/skeletons/home_skeleton.dart';
import 'package:max/core/widgets/skeletons/shimmer_effect.dart';
import 'package:max/core/utils/haptic_utils.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool _coverImageReady = false;
  String? _preloadedCoverUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final products = ref.watch(filteredHomeProductsProvider);
    final categories = ref.watch(categoriesProvider);
    final homeContentAsync = ref.watch(homeContentProvider);
    final isProductsLoaded = ref.watch(productsLoaded);

    ref.listen<AsyncValue<dynamic>>(homeContentProvider, (previous, next) {
      next.whenData((homeContent) {
        if (!mounted) return;
        final coverUrl = homeContent?.coverUrl;
        if (coverUrl != null && coverUrl.isNotEmpty) {
          if (_preloadedCoverUrl == coverUrl) return;
          _preloadedCoverUrl = coverUrl;
          precacheImage(
            NetworkImage(coverUrl),
            context,
          ).then((_) {
            if (mounted) setState(() => _coverImageReady = true);
          }).catchError((_) {
            if (mounted) setState(() => _coverImageReady = true);
          });
        } else {
          _preloadedCoverUrl = '';
          if (!_coverImageReady) {
            setState(() => _coverImageReady = true);
          }
        }
      });
      if (next.hasError) {
        if (!_coverImageReady) {
          if (mounted) setState(() => _coverImageReady = true);
        }
      }
    });

    if (!isProductsLoaded || !_coverImageReady) {
      return const HomeSkeleton();
    }

    return Scaffold(
      appBar: CustomAppbar(showBackButton: false, showSearchBar: true),
      body: Stack(
        children: [
          Positioned(
            top: 0.h,
            left: 0,
            right: 0,
            child: SvgPicture.asset("assets/texts/10.svg"),
          ),
          Positioned(
            top: 30.h,
            left: 0,
            right: 0,
            child: SvgPicture.asset("assets/texts/October.svg"),
          ),
          Positioned(
            top: 75.h,
            left: 0,
            right: 0,
            child: SvgPicture.asset("assets/texts/Collection.svg"),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                  child: Column(
                    children: [
                      Gap(100.h),
                      _HomeCover(homeContentAsync: homeContentAsync),
                      Gap(20.h),
                      _CategoryFilter(categories: categories),
                      Gap(16.h),
                      products.isEmpty
                          ? _EmptyProducts(colorScheme: colorScheme)
                          : _ProductGrid(
                              products: products,
                              colorScheme: colorScheme,
                            ),
                      Gap(5.h),
                      CustomText(
                        text: "You may also like".toUpperCase(),
                        size: 20,
                      ),
                      Gap(10.h),
                      Image.asset("assets/svgs/line.png", width: 190.w),
                      Gap(40.h),

                      about(context),
                      Gap(20.h),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15.h, top: 10.h),
                    child: Center(
                      child: CustomText(
                        height: 2.5,
                        text: "Copyright© OpenUI All Rights Reserved.",
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length + 1,
        separatorBuilder: (_, _) => Gap(8.w),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const _CategoryChip(label: 'All', categoryId: null);
          }
          final category = categories[index - 1];
          return _CategoryChip(label: category.name, categoryId: category.id);
        },
      ),
    );
  }
}

class _CategoryChip extends ConsumerWidget {
  const _CategoryChip({required this.label, required this.categoryId});

  final String label;
  final int? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedId = ref.watch(selectedCategoryProvider);
    final isSelected = selectedId == categoryId;

    return GestureDetector(
      onTap: () {
        HapticUtils.light();
        ref.read(selectedCategoryProvider.notifier).state = categoryId;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.onSurface
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.center,
        child: CustomText(
          text: label.toUpperCase(),
          size: 12,
          color: isSelected ? colorScheme.surface : colorScheme.onSurface,
          weight: isSelected ? FontWeight.bold : FontWeight.normal,
          spacing: 2,
        ),
      ),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48.w,
              color: colorScheme.onSurfaceVariant,
            ),
            Gap(16.h),
            CustomText(
              text: 'No products found',
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products, required this.colorScheme});

  final List<ProductModel> products;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        crossAxisSpacing: 15.w,
        childAspectRatio: 0.50,
      ),
      itemBuilder: (context, index) {
        final item = products[index];
        return ProductGridCard(
          product: item,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => ProductDetailPage(product: item)),
          ),
        );
      },
    );
  }
}

class _HomeCover extends StatelessWidget {
  const _HomeCover({required this.homeContentAsync});

  final AsyncValue<dynamic> homeContentAsync;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return homeContentAsync.when(
      loading: () => ShimmerEffect(
        child: SkeletonBox(
          width: double.infinity,
          height: 200.h,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      error: (_, _) => _buildFallback(colorScheme),
      data: (homeContent) {
        final coverUrl = homeContent?.coverUrl;
        if (coverUrl == null || coverUrl.isEmpty) {
          return _buildFallback(colorScheme);
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            coverUrl,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return ShimmerEffect(
                child: SkeletonBox(
                  width: double.infinity,
                  height: 200.h,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                _buildFallback(colorScheme),
          ),
        );
      },
    );
  }

  Widget _buildFallback(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }
}

Widget about(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => HapticUtils.light(),
            child: Icon(Ionicons.logo_twitter, color: colorScheme.onSurface),
          ),
          Gap(30.w),
          GestureDetector(
            onTap: () => HapticUtils.light(),
            child: Icon(Ionicons.logo_instagram, color: colorScheme.onSurface),
          ),
          Gap(30.w),
          GestureDetector(
            onTap: () => HapticUtils.light(),
            child: Icon(Ionicons.logo_facebook, color: colorScheme.onSurface),
          ),
        ],
      ),
      Gap(20.h),
      Image.asset("assets/svgs/line.png", width: 190.w),
      Gap(20.h),
      CustomText(
        height: 2.5,
        text:
            "youssifmostafa798@gmail.com \n       +201553178468\n17:00 - 22:00 - Everyday",
      ),
      Gap(20.h),
      Image.asset("assets/svgs/line.png", width: 190.w),
      Gap(20.h),
      CustomText(height: 2.5, text: "About   Contact    Blog"),
    ],
  );
}
