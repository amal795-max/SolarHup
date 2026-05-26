import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';

Widget whiteSectionWidget({ required Widget child}){
  return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.lightGrey,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child:child);
}