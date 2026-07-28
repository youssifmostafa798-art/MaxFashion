import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/data/models/product_model.dart';
import 'package:max/core/theme/app_colors.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({
    super.key,
    required this.products,
    required this.onChanged,
    required this.enableQty,
    required this.qty,
  });

  final ProductModel products;
  final Function(int) onChanged;
  final bool enableQty;
  final int qty;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  late int number;
  @override
  void initState() {
    number = 1;
    number = widget.qty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(widget.products.image, width: 120.w, fit: BoxFit.cover),
        Gap(8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(8.h),
            CustemText(
              text: widget.products.name.toUpperCase(),
              spacing: 5,
              color: AppColors.primary,
            ),
            Gap(10.h),
            SizedBox(
              width: 200.w,
              child: CustemText(
                text: widget.products.descrp,
                size: 15,
                color: AppColors.primary,
              ),
            ),
            Gap(15.h),
            CustemText(
              text: "\$ ${widget.products.price}",
              size: 16,
              weight: FontWeight.bold,
              color: const Color(0xffDD8560),
            ),
            Gap(20.h),
            if (widget.enableQty)
              Row(
                children: [
                  qty(() {
                    setState(() {
                      if (number > 1) number--;
                      widget.onChanged(number);
                    });
                  }, 'assets/svgs/min.svg'),
                  Gap(15.w),
                  CustemText(
                    text: number.toString(),
                    size: 15,
                    weight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  Gap(15.w),
                  qty(() {
                    setState(() {
                      number++;
                      widget.onChanged(number);
                    });
                  }, 'assets/svgs/plus.svg'),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

Widget qty(VoidCallback onTapp, String svg) {
  return GestureDetector(
    onTap: onTapp,
    child: Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400, width: 1.w),
      ),
      child: SvgPicture.asset(svg),
    ),
  );
}
