import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/models/address_model.dart';
import 'package:max/data/models/user_model.dart';

class CheckoutAddressSection extends StatelessWidget {
  const CheckoutAddressSection({
    super.key,
    required this.hasAddress,
    required this.defaultAddress,
    required this.user,
    required this.onTap,
  });

  final bool hasAddress;
  final AddressModel? defaultAddress;
  final UserModel? user;
  final VoidCallback onTap;

  String _joinParts(List<String?> parts) {
    return parts.where((p) => p != null && p.isNotEmpty).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    if (hasAddress && defaultAddress != null) {
      return GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user != null) ...[
                    Gap(8.h),
                    CustomText(
                      text: user!.fullName,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 15,
                    ),
                    CustomText(
                      text: user!.phoneNumber,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 13,
                    ),
                    Gap(4.h),
                  ],
                  CustomText(
                    text: defaultAddress!.street,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 14,
                  ),
                  if (defaultAddress!.apartment != null &&
                      defaultAddress!.apartment!.isNotEmpty) ...[
                    Gap(2.h),
                    CustomText(
                      text: defaultAddress!.apartment!,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 13,
                    ),
                  ],
                  Gap(2.h),
                  CustomText(
                    text: _joinParts([
                      defaultAddress!.city,
                      defaultAddress!.state,
                      defaultAddress!.zip,
                    ]),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 13,
                  ),
                  CustomText(
                    text: defaultAddress!.country,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 13,
                  ),
                ],
              ),
            ),
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.arrow_back_ios_outlined
                  : Icons.arrow_forward_ios_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
