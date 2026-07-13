import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_style.dart';

headerSection({required String title, required String subTitle}) {
  return  Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 56.h),
        Text(
          title.tr(),
          style: AppStyle.h3.copyWith(
            height: 1.2,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subTitle.tr(),
          style: AppStyle.bodySmall.copyWith(
            color: AppColors.grey,
            height: 1.4,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}