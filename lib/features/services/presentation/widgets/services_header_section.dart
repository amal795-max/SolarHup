import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

class ServicesHeaderSection extends StatelessWidget {
  const ServicesHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 22.h),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryColor, AppColors.deepPrimaryColor],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -12.w,
              bottom: -20.h,
              child: Icon(
                Icons.solar_power_rounded,
                size: 110.sp,
                color: AppColors.white.withValues(alpha: 0.07),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'services_professional_care'.tr(),
                    style: AppStyle.labelXSmall.copyWith(
                      color: AppColors.tertiaryColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'expert_services_title'.tr(),
                  style: AppStyle.h4.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'expert_services_description'.tr(),
                  style: AppStyle.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.82),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
