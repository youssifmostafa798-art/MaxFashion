import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/router/app_router.dart';
import 'package:max/core/widgets/custom_appbar.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/providers/collection_provider.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/data/providers/home_content_provider.dart';
import 'package:max/core/widgets/skeletons/home_skeleton.dart';
import 'package:max/features/home/presentation/widgets/home_cover.dart';
import 'package:max/features/home/presentation/widgets/home_category_filter.dart';
import 'package:max/features/home/presentation/widgets/home_product_grid.dart';
import 'package:max/features/home/presentation/widgets/home_empty_products.dart';
import 'package:max/features/home/presentation/widgets/home_about_section.dart';
import 'package:max/features/collection/presentation/widgets/home_collections_section.dart';
import 'package:max/core/l10n/app_localizations.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final products = ref.watch(filteredHomeProductsProvider);
    final categories = ref.watch(categoriesProvider);
    final homeContentAsync = ref.watch(homeContentProvider);
    final isProductsLoaded = ref.watch(productsLoaded);
    final collectionsAsync = ref.watch(collectionsProvider);

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
          !isProductsLoaded
              ? const SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: HomeSkeleton(),
                )
              : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                  child: Column(
                    children: [
                      Gap(100.h),
                      HomeCover(homeContentAsync: homeContentAsync),
                      Gap(20.h),
                      HomeCategoryFilter(categories: categories),
                      Gap(16.h),
                      products.isEmpty
                          ? const HomeEmptyProducts()
                          : HomeProductGrid(products: products),
                      Gap(5.h),
                      CustomText(
                        text: l10n.exploreCollections.toUpperCase(),
                        size: 20,
                      ),
                      Gap(10.h),
                      Image.asset("assets/svgs/line.png", width: 190.w),
                      Gap(20.h),
                      collectionsAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                        data: (collections) {
                          if (collections.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          final homeCollections = collections.take(5).toList();
                          return HomeCollectionsSection(
                            collections: homeCollections,
                            onCollectionTap: (collection) {
                              Navigator.pushNamed(
                                context,
                                AppRouter.collectionProducts,
                                arguments: collection,
                              );
                            },
                            onSeeMoreTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.allCollections,
                              );
                            },
                          );
                        },
                      ),
                      Gap(20.h),
                      const HomeAboutSection(),
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
                        text: l10n.copyrightText,
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
