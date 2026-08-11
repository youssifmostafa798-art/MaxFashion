import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/features/product/presentation/pages/product_detail_page.dart';
import 'package:max/features/product/presentation/widgets/product_grid_card.dart';

class HomeProductGrid extends StatelessWidget {
  const HomeProductGrid({super.key, required this.products});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
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
