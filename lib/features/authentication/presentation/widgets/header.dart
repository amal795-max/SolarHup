import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_style.dart';

import '../../../../core/theme/app_colors.dart';

Widget headerWidget({
  required IconData icon,
  required String title,
  required String subTitle,
}) => Center(
  child: Column(
    children: [
      Container(
        width: 70.r,
        height: 70.r,
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(icon, color: AppColors.tertiaryColor, size: 30.sp),
      ),
      SizedBox(height: 16.h),
      Text(
        title.tr(),
        style: AppStyle.h3.copyWith(color: AppColors.primaryColor),
      ),
       Text(
          subTitle.tr(),
          textAlign: TextAlign.center,
          style: AppStyle.bodyMedium.copyWith(color: AppColors.grey),
        ),

      SizedBox(height: 24.h),
    ],
  ),
);
