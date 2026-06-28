import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';

Widget whiteSectionWidget({ required Widget child,required BuildContext context,double?padding}){
  return Container(
      padding: EdgeInsets.all(padding ?? 20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow:  [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius:context.brightness?0:12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child:child);
}