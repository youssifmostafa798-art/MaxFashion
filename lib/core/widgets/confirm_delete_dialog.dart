import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showConfirmDeleteDialog({
  required BuildContext context,
  required String emoji,
  required String title,
  required VoidCallback onDelete,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(10.h),
              Text(
                emoji,
                style: TextStyle(fontSize: 40.w),
              ),
              Gap(16.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  fontFamily: 'Tenor_Sans',
                ),
              ),
              Gap(8.h),
              Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'Tenor_Sans',
                ),
              ),
              Gap(24.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colorScheme.onSurface,
                              fontFamily: 'Tenor_Sans',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        onDelete();
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: Colors.red.shade300,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            'DELETE',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontFamily: 'Tenor_Sans',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(10.h),
            ],
          ),
        ),
      );
    },
  );
}
