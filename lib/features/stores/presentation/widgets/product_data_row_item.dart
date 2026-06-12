import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDataRowItem extends StatelessWidget {
  final String label;
  final String value;
  final Color backgroundColor;
  final bool showDivider;

  const ProductDataRowItem({
    super.key,
    required this.label,
    required this.value,
    required this.backgroundColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                flex: 5,
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (showDivider)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Divider(
                height: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.35),
              ),
            ),
        ],
      ),
    );
  }
}
