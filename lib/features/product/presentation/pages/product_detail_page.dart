import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/features/checkout/presentation/widgets/card_widget.dart';
import 'package:max/core/widgets/custom_appbar.dart';
import 'package:max/core/widgets/custom_button.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/features/checkout/presentation/widgets/favorite_button.dart';
import 'package:max/features/checkout/presentation/widgets/promo_section.dart';
import 'package:max/features/checkout/presentation/widgets/added_to_cart_dialog.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/data/models/cart_item_model.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/core/widgets/skeletons/product_detail_skeleton.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/theme/app_colors.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key, required this.product});
  final ProductModel product;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int selectedQty = 1;
  String? selectedSize;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final sizes = widget.product.sizes;
    selectedSize = sizes.isNotEmpty ? sizes.first : null;
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: const CustomAppbar(showSearchBar: false),
        body: const ProductDetailSkeleton(),
      );
    }

    return Scaffold(
      appBar: const CustomAppbar(showSearchBar: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [FavoriteButton(product: widget.product)],
              ),
              CardWidget(
                products: widget.product,
                enableQty: true,
                qty: selectedQty,
                onChanged: (v) {
                  HapticUtils.light();
                  setState(() {
                    selectedQty = v;
                  });
                },
              ),
              Gap(16.h),
              if (widget.product.sizes.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: "SIZE",
                    size: 13,
                    weight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    spacing: 2,
                  ),
                ),
                Gap(10.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.product.sizes.map((size) {
                      final isSelected = selectedSize == size;
                      return Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: GestureDetector(
                          onTap: () {
                            HapticUtils.selection();
                            setState(() {
                              selectedSize = size;
                            });
                          },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.outline,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Center(
                            child: CustomText(
                              text: size,
                              size: 13,
                              weight: FontWeight.w600,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.surface
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  ),
                ),
              ],
              const PromoSection(),
              Gap(50.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Est. Total",
                    color: Theme.of(context).colorScheme.onSurface,
                    spacing: 3,
                  ),
                  CustomText(
                    text: "\$ ${widget.product.price * selectedQty}",
                    color: AppColors.errorRed200,
                  ),
                ],
              ),
              Gap(15.h),
              CustomButton(
                isSvg: true,
                title: "Add to cart",
                onTap: () {
                  final productId = CartItemModel.generateProductId(
                    widget.product.name,
                    widget.product.image,
                    selectedSize ?? '',
                  );
                  ref
                      .read(cartProvider.notifier)
                      .addItem(
                        CartItemModel(
                          productId: productId,
                          productName: widget.product.name,
                          productImage: widget.product.image,
                          selectedSize: selectedSize ?? '',
                          quantity: selectedQty,
                          unitPrice: widget.product.price,
                        ),
                      );
                  showAddedToCartDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
