import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';

class ProductSpecCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? labelColor;
  final Color? valueColor;

  const ProductSpecCard({
    super.key,
    required this.label,
    required this.value,
    this.isFullWidth = false,
    this.leadingIcon,
    this.backgroundColor,
    this.iconBackgroundColor,
    this.iconColor,
    this.labelColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surface;
    final resolvedLabelColor = labelColor ?? theme.textTheme.bodySmall?.color;
    final resolvedValueColor = valueColor ?? theme.colorScheme.onSurface;

    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        color: bg,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: theme.brightness == Brightness.dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                leadingIcon,
                color: iconColor,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: resolvedLabelColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: resolvedValueColor,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
