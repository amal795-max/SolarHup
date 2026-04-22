
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';

decoratedContainer({required Widget child}) {
  return Container(
    padding:EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      boxShadow: const [
        BoxShadow(
          offset: Offset(0, -4),
          blurRadius: 9,
          color: Color(0x0F878787),
        ),
      ],
    ),
    child: child,
  );
}

sectionContainer({required Widget child, EdgeInsets? padding,double? top}) {
  return Container(
    margin: EdgeInsets.only(bottom: 16.h, top: top??0),
    padding: padding ?? EdgeInsets.all(20.r),
    color: AppColors.white,
    child: child,
  );
}

decoratedBox({required Widget child}){
  return DecoratedBox(
      decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16.r),
  border: Border.all(color: AppColors.lightContainer),
  ),
  child:child );
}