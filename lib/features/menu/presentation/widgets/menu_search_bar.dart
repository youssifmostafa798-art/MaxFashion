import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/utils/haptic_utils.dart';
import 'package:max/core/widgets/custom_text.dart';
import 'package:max/data/providers/search_provider.dart';
import 'package:max/features/search/presentation/pages/search_screen.dart';

class MenuSearchBar extends StatelessWidget {
  const MenuSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        HapticUtils.light();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const SearchScreen(searchContext: SearchContextType.category),
          ),
        );
      },
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 14.w),
              child: Icon(
                Icons.search,
                color: colorScheme.onSurfaceVariant,
                size: 20.w,
              ),
            ),
            SizedBox(width: 10.w),
            CustomText(
              text: 'Search categories...',
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
