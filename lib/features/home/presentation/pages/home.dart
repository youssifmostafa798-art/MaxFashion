import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:max/core/widgets/custom_appbar.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/cover_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/providers/product_provider.dart';
import 'package:max/features/product/presentation/pages/product_detail_page.dart';
import 'package:max/features/product/presentation/widgets/product_grid_card.dart';
import 'package:max/core/widgets/skeletons/home_skeleton.dart';
import 'package:max/core/utils/haptic_utils.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final products = ref.watch(featuredProductsProvider);

    if (_isLoading) {
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
                      Image.asset("assets/cover/cover1.png"),
                      Gap(20.h),
                      _ProductGrid(
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
                      SizedBox(
                        height: 500.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: CoverModel.covers.length,
                          itemBuilder: (context, index) {
                            final item = CoverModel.covers[index];
                            return Padding(
                              padding: EdgeInsets.all(8.0.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    item.image,
                                    height: 350.h,
                                    fit: BoxFit.cover,
                                  ),
                                  Gap(10.h),
                                  CustomText(text: item.name.toUpperCase()),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
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
