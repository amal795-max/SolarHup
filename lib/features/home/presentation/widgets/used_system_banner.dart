import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

class UsedSystemBanner extends StatelessWidget {
  const UsedSystemBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'home_used_system_label'.tr(),
              style: AppStyle.labelXSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: AppStyle.bodyLarge.fontSize,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                'home_used_system_desc'.tr(),
                style: AppStyle.bodySmall.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: AppStyle.bodyLarge.fontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
