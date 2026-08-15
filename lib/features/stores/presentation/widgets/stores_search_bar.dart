import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/widgets/custom_text_field.dart';

/// Search bar with an inline filter (tune) button for the stores screen.
class StoresSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;
  final String? hintText;

  const StoresSearchBar({
    super.key,
    required this.controller,
    this.enabled = true,
    this.onChanged,
    this.onClear,
    this.onFilterTap,
    this.hintText,
  });

  @override
  State<StoresSearchBar> createState() => _StoresSearchBarState();
}

class _StoresSearchBarState extends State<StoresSearchBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
    _hasText = widget.controller.text.isNotEmpty;
  }

  @override
  void didUpdateWidget(StoresSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  void _onControllerChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerColor = isDark ? AppColors.darkContainer : AppColors.white;
    final borderColor = isDark ? AppColors.darkGray : AppColors.borderColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              hasTitle: false,
              title: '',
              controller: widget.controller,
              hint: widget.hintText ?? 'stores_search_hint'.tr(),
              readOnly: !widget.enabled,
              onChanged: widget.onChanged,
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.grey,
                size: 20.sp,
              ),
              suffixIcon: _hasText
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: AppColors.grey,
                        size: 18.sp,
                      ),
                      onPressed: () {
                        widget.controller.clear();
                        widget.onClear?.call();
                      },
                    )
                  : null,
            ),
          ),
          SizedBox(width: 8.w),
          if (widget.onFilterTap != null)
            Material(
              color: containerColor,
              borderRadius: BorderRadius.circular(12.r),
              child: InkWell(
                onTap: widget.onFilterTap,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 48.h,
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: AppColors.primaryColor,
                    size: 22.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
