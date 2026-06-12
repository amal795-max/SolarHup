import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

/// Search bar with an inline filter (tune) button for the stores screen.
///
/// The filter icon uses [InkWell] so it receives ink-splash feedback —
/// appropriate since it triggers a navigation/overlay action.
class StoresSearchBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? AppColors.darkContainer : AppColors.white;
    final borderColor = isDark ? AppColors.darkGray : AppColors.borderColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // ── Search field ───────────────────────────────────────────────
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: borderColor),
              ),
              child: TextField(
                controller: controller,
                enabled: enabled,
                onChanged: onChanged,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: hintText ?? 'stores_search_hint'.tr(),
                  hintStyle:
                      AppStyle.bodyXSmall.copyWith(color: AppColors.grey),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.grey,
                    size: 20.sp,
                  ),
                  // Clear button only appears when there is text
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: AppColors.grey,
                            size: 18.sp,
                          ),
                          onPressed: onClear,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // ── Filter button ──────────────────────────────────────────────
          // InkWell is correct here: it is a navigation-triggering action
          // (opens filter sheet/screen), not a mere label or structural widget.
          Material(
            color: containerColor,
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              onTap: onFilterTap,
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
