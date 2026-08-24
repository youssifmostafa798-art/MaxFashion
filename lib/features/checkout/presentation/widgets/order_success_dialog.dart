import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/l10n/app_localizations.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/core/utils/order_display_helper.dart';
import 'package:max/core/widgets/custom_button.dart';
import 'package:max/features/checkout/presentation/widgets/order_rating_widget.dart';

enum OrderDialogResult { confirmed, cancelled }

Future<OrderDialogResult?> showOrderSuccessDialog({
  required BuildContext context,
  required String orderId,
}) {
  final l10n = AppLocalizations.of(context)!;
  return showDialog<OrderDialogResult>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          height: 520.h,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, OrderDialogResult.cancelled);
                    },
                    child: const Icon(CupertinoIcons.clear),
                  ),
                ),
                Gap(20.h),
                CustomText(
                  text: l10n.paymentSuccess,
                  spacing: 2,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 19,
                ),
                Gap(40.h),
                SvgPicture.asset("assets/pop/done.svg"),
                Gap(40.h),
                CustomText(
                  text: l10n.paymentSuccessMessage,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap(10.h),
                CustomText(
                  text: l10n.paymentIdLabel,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                Gap(6.h),
                CustomText(
                  text: OrderDisplayHelper.formatOrderId(orderId),
                  size: 18,
                  weight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap(20.h),
                Image.asset(
                  'assets/svgs/line.png',
                  width: 150.w,
                  height: 15.h,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap(20.h),
                CustomText(
                  text: l10n.ratePurchase,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                Gap(20.h),
                const OrderRatingWidget(),

                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        isSvg: false,
                        title: l10n.submit,
                        onTap: () {
                          Navigator.pop(context, OrderDialogResult.confirmed);
                        },
                      ),
                    ),
                    Gap(20.w),
                    Expanded(
                      child: CustomButton(
                        isSvg: false,
                        title: l10n.cancel,
                        onTap: () {
                          Navigator.pop(context, OrderDialogResult.cancelled);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
