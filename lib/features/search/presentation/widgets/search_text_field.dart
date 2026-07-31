import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/core/theme/app_colors.dart';
import 'package:max/data/providers/search_provider.dart';

class SearchTextField extends ConsumerStatefulWidget {
  const SearchTextField({
    super.key,
    required this.onChanged,
    this.onClear,
    this.onSubmitted,
    this.autofocus = false,
    this.hintText = 'Search....',
    this.initialValue,
    this.backgroundColor,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final String hintText;
  final String? initialValue;
  final Color? backgroundColor;

  @override
  ConsumerState<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends ConsumerState<SearchTextField> {
  late TextEditingController _controller;
  ProviderSubscription<String>? _querySubscription;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    // ref.listen is only legal inside build(). For lifecycle-driven side-effects
    // use ref.listenManual(), which returns a ProviderSubscription that must be
    // cancelled in dispose() to avoid memory leaks.
    _querySubscription = ref.listenManual<String>(
      searchProvider.select((s) => s.query),
      (previous, next) {
        if (next.isEmpty && _controller.text.isNotEmpty) {
          _controller.clear();
        }
      },
    );
  }

  @override
  void dispose() {
    _querySubscription?.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 14.w),
            child: Icon(Icons.search, color: AppColors.grey500, size: 20.w),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: widget.autofocus,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primary,
                fontFamily: 'Tenor_Sans',
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.grey400,
                  fontFamily: 'Tenor_Sans',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                suffixIcon: _controller.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _controller.clear();
                          widget.onChanged('');
                          widget.onClear?.call();
                        },
                        child: Icon(
                          Icons.close,
                          size: 18.w,
                          color: AppColors.grey500,
                        ),
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }
}
