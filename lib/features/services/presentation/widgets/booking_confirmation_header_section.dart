import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';

class BookingConfirmationHeaderSection extends StatelessWidget {
  const BookingConfirmationHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return Column(
      children: [
        Container(
          width: 88.w,
          height: 88.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.secondaryColor.withValues(alpha: isDark ? 0.2 : 0.35),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondaryColor.withValues(alpha: 0.35),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 64.w,
              height: 64.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryColor,
              ),
              child: Icon(
                Icons.check_rounded,
                color: AppColors.primaryColor,
                size: 36.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'booking_confirmed_title'.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            'booking_confirmed_subtitle'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.grey,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
