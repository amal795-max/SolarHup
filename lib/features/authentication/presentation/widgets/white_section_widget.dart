import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';

Widget whiteSectionWidget({ required Widget child,required BuildContext context,double?padding}){
  return Container(
      padding: EdgeInsets.all(padding ?? 20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow:  [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius:context.brightness?0:12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child:child) .animate()
      .fadeIn(duration: 500.ms, delay: 300.ms);
}