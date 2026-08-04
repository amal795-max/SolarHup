import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_style.dart';

import '../../../../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor = Colors.white;

    switch (status) {
      case 'active':
        bgColor = AppColors.secondaryColor;
        textColor = AppColors.brown;
        break;
      case 'sold':
        bgColor = Colors.grey;
        textColor = AppColors.white;
        break;
      case 'removed':
        bgColor = AppColors.red;
        break;
      default:
        bgColor = AppColors.primaryColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        status.tr(),
        style:AppStyle.labelXSmall.copyWith(color: textColor),
      ),
    );
  }
}
