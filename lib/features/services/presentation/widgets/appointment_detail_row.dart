import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';

class AppointmentDetailRow extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final String label;
  final String value;
  final Color valueColor;

  const AppointmentDetailRow({
    super.key,
    this.icon,
    this.leading,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconBg = context.brightness
        ? AppColors.darkGray.withValues(alpha: 0.6)
        : AppColors.lightGrey.withValues(alpha: 0.8);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        leading ??
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: AppColors.grey,
              ),
            ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.grey,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
