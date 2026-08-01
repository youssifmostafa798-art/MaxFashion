import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_bottom.dart';
import 'package:max/core/widgets/custem_text.dart';

class EmptyAddresses extends StatelessWidget {
  const EmptyAddresses({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\ud83d\udccd',
              style: TextStyle(fontSize: 64.w),
            ),
            Gap(24.h),
            CustemText(
              text: 'No saved addresses.',
              size: 18,
              weight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
            Gap(10.h),
            CustemText(
              text: 'Add your first delivery address.',
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            Gap(40.h),
            Button(
              isSvgg: false,
              title: 'Add Address',
              onTap: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}
