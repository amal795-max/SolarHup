import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';

import '../../../../core/helper/extensions.dart';
import '../../../../core/theme/app_style.dart';

class BookingConfirmationHeaderSection extends StatelessWidget {
  final String? titleKey;
  final String? subtitleKey;

  const BookingConfirmationHeaderSection({
    super.key,
    this.titleKey,
    this.subtitleKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
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
              width: 60.w,
              height: 60.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryColor,
              ),
              child: Icon(
                Icons.check_rounded,
                color: AppColors.brown,
                size: 36.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          (titleKey ?? 'booking_confirmed_title').tr(),
          textAlign: TextAlign.center,
          style:AppStyle.h4.copyWith(
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
        SizedBox(height: 4.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            (subtitleKey ?? 'booking_confirmed_subtitle').tr(),
            textAlign: TextAlign.center,
            style: AppStyle.bodyMedium.copyWith(
              color: AppColors.grey,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
