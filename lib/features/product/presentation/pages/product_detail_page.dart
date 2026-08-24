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
import 'package:max/data/providers/auth_provider.dart';
import 'package:max/data/providers/cart_provider.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/core/widgets/dialog/guest_prompt_dialog.dart';
import 'package:max/core/l10n/app_localizations.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key, required this.product});
  final ProductModel product;

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int selectedQty = 1;
  String? selectedSize;

  @override
  void initState() {
    super.initState();
    final sizes = widget.product.sizes;
    selectedSize = sizes.isNotEmpty ? sizes.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                showDescription: false,
                qty: selectedQty,
                onChanged: (v) {
                  HapticUtils.light();
                  setState(() {
                    selectedQty = v;
                  });
                },
              ),
              Gap(16.h),
              Text(
                widget.product.description,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFamily: 'Tenor_Sans',
                  height: 1.4,
                ),
              ),
              if (widget.product.sizes.isNotEmpty) ...[
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CustomText(
                    text: l10n.size,
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
                        padding: EdgeInsetsDirectional.only(end: 10.w),
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
                    text: l10n.estimatedTotal,
                    color: Theme.of(context).colorScheme.onSurface,
                    spacing: 3,
                  ),
                  CustomText(
                    text: l10n.priceValue((widget.product.price * selectedQty).toString()),
                    color: AppColors.errorRed200,
                  ),
                ],
              ),
              Gap(15.h),
              CustomButton(
                isSvg: true,
                title: l10n.addToCart,
                onTap: () {
                  final isGuest = ref.read(authStateProvider).isGuest;
                  if (isGuest) {
                    showGuestPromptDialog(
                      context: context,
                      message: l10n.signInToAddToBag,
                    );
                    return;
                  }
                  final dbProductId = int.parse(
                    widget.product.id.replaceFirst('p', ''),
                  );
                  ref
                      .read(cartProvider.notifier)
                      .addItem(
                        CartItemModel(
                          productId: dbProductId,
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
