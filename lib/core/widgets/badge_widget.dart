import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({
    super.key,
    required this.child,
    required this.count,
  });

  final Widget child;
  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24.w,
      height: 24.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(child: child),
          if (count > 0)
            Positioned(
              top: -3.w,
              right: -5.w,
              child: Container(
                height: 16.w,
                constraints: BoxConstraints(minWidth: 16.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: const BoxDecoration(
                  color: Color(0xffDD8560),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
