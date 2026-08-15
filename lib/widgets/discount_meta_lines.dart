import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/catalog/utils/discount_period_formatter.dart';

/// Reusable description + validity period for discount cards.
class DiscountMetaLines extends StatelessWidget {
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool muted;
  final bool compact;

  const DiscountMetaLines({
    super.key,
    this.description,
    this.startDate,
    this.endDate,
    this.muted = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasDiscountMeta(
      description: description,
      startDate: startDate,
      endDate: endDate,
    )) {
      return const SizedBox.shrink();
    }

    final period = formatDiscountPeriod(startDate, endDate);
    final details = description?.trim();
    final descriptionStyle = muted
        ? AppStyle.bodySmall.copyWith(
            color: AppColors.grey,
            height: 1.4,
          )
        : AppStyle.labelXSmall.copyWith(
            color: AppColors.grey,
            height: 1.25,
          );
    final periodStyle = muted
        ? AppStyle.bodySmall.copyWith(
            color: AppColors.grey.withValues(alpha: 0.85),
            fontWeight: FontWeight.w500,
          )
        : AppStyle.labelXSmall.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (details != null && details.isNotEmpty) ...[
          SizedBox(height: muted ? 0 : 2.h),
          Text(
            details,
            style: descriptionStyle,
            maxLines: compact ? 1 : (muted ? 6 : 2),
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (period.isNotEmpty) ...[
          SizedBox(height: compact ? 2.h : 4.h),
          Text(
            period,
            style: periodStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
