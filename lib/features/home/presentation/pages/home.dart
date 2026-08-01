import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:max/core/widgets/custem_appbar.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/core/widgets/favorite_button.dart';
import 'package:max/data/models/cover_model.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/features/checkout/presentation/checkout.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustemAppbar(
        showBackButton: false,
        showSearchBar: true,
      ),
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
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                  child: Column(
                    children: [
                      Gap(100.h),
                      Image.asset("assets/cover/cover1.png"),
                      Gap(20.h),
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ProductModel.products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 15.w,
                          childAspectRatio: 0.50,
                        ),
                        itemBuilder: (context, index) {
                          final item = ProductModel.products[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => Checkout(products: item),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Image.asset(item.image),
                                    Positioned(
                                      top: 8.w,
                                      right: 8.w,
                                      child: FavoriteButton(product: item),
                                    ),
                                  ],
                                ),
                                Gap(10.h),
                                CustemText(text: item.name),
                                CustemText(
                                  text: item.descrp,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                Gap(9.h),
                                CustemText(
                                  text: "\$ ${item.price.toString()}",
                                  color: Color(0xffDD8560),
                                  size: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Gap(5.h),
                      CustemText(
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
                                  CustemText(text: item.name.toUpperCase()),
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
                      child: CustemText(
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

Widget about(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Ionicons.logo_twitter, color: colorScheme.onSurface),
          Gap(30.w),
          Icon(Ionicons.logo_instagram, color: colorScheme.onSurface),
          Gap(30.w),
          Icon(Ionicons.logo_facebook, color: colorScheme.onSurface),
        ],
      ),
      Gap(20.h),
      Image.asset("assets/svgs/line.png", width: 190.w),
      Gap(20.h),
      CustemText(
        height: 2.5,
        text:
            "support@openui.design \n       +60 825 876 \n08:00 - 22:00 - Everyday",
      ),
      Gap(20.h),
      Image.asset("assets/svgs/line.png", width: 190.w),
      Gap(20.h),
      CustemText(height: 2.5, text: "About   Contact    Blog"),
    ],
  );
}
