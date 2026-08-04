import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:max/data/providers/search_provider.dart';
import 'package:max/core/constants/app_constants.dart';
import 'package:max/core/theme/app_text_styles.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 14.w),
            child: Icon(Icons.search, color: colorScheme.onSurfaceVariant, size: 20.w),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: widget.autofocus,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              style: TextStyle(
                fontSize: AppTextStyles.fontSize14,
                color: colorScheme.onSurface,
                fontFamily: AppConstants.fontFamily,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: AppTextStyles.fontSize14,
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: AppConstants.fontFamily,
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
                          color: colorScheme.onSurfaceVariant,
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
