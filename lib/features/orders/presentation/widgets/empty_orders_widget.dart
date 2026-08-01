import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/widgets/custem_text.dart';
import 'package:max/features/main/presentation/pages/main_screen.dart';

class EmptyOrdersWidget extends StatelessWidget {
  const EmptyOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80.w,
              color: colorScheme.outline,
            ),
            SizedBox(height: 24.h),
            CustemText(
              text: "You haven't placed any orders yet",
              size: 18,
              weight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            SizedBox(height: 10.h),
            CustemText(
              text: 'Your completed purchases will appear here.',
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 32.h),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MainScreen(initialTab: 0)),
                  (route) => false,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CustemText(
                  text: 'CONTINUE SHOPPING',
                  size: 14,
                  color: colorScheme.surface,
                  spacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
