
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';

void showHelpGuide(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Row(
        children: [
          Icon(Icons.menu_book, color: AppColors.primaryColor, size: 24.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              tr('how_to_verify_title'),
              style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          spacing: 16.h,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGuideStep(
              '1',
              tr('guide_step_1_title'),
              tr('guide_step_1_desc'),
            ),
            _buildGuideStep(
              '2',
              tr('guide_step_2_title'),
              tr('guide_step_2_desc'),
            ),
            _buildGuideStep(
              '3',
              tr('guide_step_3_title'),
              tr('guide_step_3_desc'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            tr('got_it'),
            style: AppStyle.bodySmall.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

Widget _buildGuideStep(String number, String title, String desc) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 12.r,
        backgroundColor: AppColors.secondaryColor,
        child: Text(
          number,
          style: AppStyle.bodyXSmall.copyWith(
            color: AppColors.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(width: 12.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppStyle.bodySmall.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Text(
              desc,
              style: AppStyle.bodyXSmall.copyWith(
                color: AppColors.grey,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}