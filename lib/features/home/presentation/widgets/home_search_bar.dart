import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

class HomeSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool enabled;

  const HomeSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.enabled = true,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(HomeSearchBar oldWidget) {
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TextField(
        controller: widget.controller,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        style: AppStyle.labelMedium.copyWith(
          color: isDark ? AppColors.white : AppColors.black,
        ),
        decoration: InputDecoration(
          hintText: 'home_search_hint'.tr(),
          hintStyle: AppStyle.labelMedium.copyWith(color: AppColors.grey),
          prefixIcon: Icon(Icons.search, color: AppColors.grey, size: 20.sp),
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(Icons.close_rounded,
                      color: AppColors.grey, size: 18.sp),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onClear?.call();
                  },
                  splashRadius: 18,
                )
              : null,
          filled: true,
          fillColor: isDark ? AppColors.darkContainer : AppColors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
                color: isDark ? AppColors.darkGray : AppColors.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
                color: isDark ? AppColors.darkGray : AppColors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(
                color: AppColors.primaryColor, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
                color: isDark ? AppColors.darkGray : AppColors.borderColor),
          ),
        ),
      ),
    );
  }
}
