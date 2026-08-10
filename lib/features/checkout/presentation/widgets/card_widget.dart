import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/product_model.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({
    super.key,
    required this.products,
    required this.onChanged,
    required this.enableQty,
    required this.qty,
    this.showDescription = true,
  });

  final ProductModel products;
  final Function(int) onChanged;
  final bool enableQty;
  final int qty;
  final bool showDescription;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  late int number;

  @override
  void initState() {
    super.initState();
    number = widget.qty;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'product-image-${widget.products.id}',
          child: Image.asset(
            widget.products.image,
            width: 120.w,
            fit: BoxFit.cover,
            cacheWidth: 120,
          ),
        ),
        Gap(8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(8.h),
              //edit
              CustomText(
                text: widget.products.name.toUpperCase(),
                spacing: 2,
                color: colorScheme.onSurface,
                overflow: TextOverflow.clip,
              ),
              if (widget.showDescription) ...[
                Gap(10.h),
                CustomText(
                  text: widget.products.description,
                  size: 15,
                  color: colorScheme.onSurface,
                  maxLines: 2,
                ),
              ],
              Gap(15.h),
              CustomText(
                text: "\$ ${widget.products.price}",
                size: 16,
                weight: FontWeight.bold,
                color: const Color(0xffDD8560),
              ),
              Gap(20.h),
              if (widget.enableQty)
                Row(
                  children: [
                    _QtyButton(
                      svg: 'assets/svgs/min.svg',
                      onTap: () {
                        setState(() {
                          if (number > 1) number--;
                          widget.onChanged(number);
                        });
                      },
                    ),
                    Gap(15.w),
                    CustomText(
                      text: number.toString(),
                      size: 15,
                      weight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    Gap(15.w),
                    _QtyButton(
                      svg: 'assets/svgs/plus.svg',
                      onTap: () {
                        setState(() {
                          number++;
                          widget.onChanged(number);
                        });
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.svg, required this.onTap});
  final String svg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colorScheme.outline, width: 1.w),
        ),
        child: SvgPicture.asset(svg),
      ),
    );
  }
}
