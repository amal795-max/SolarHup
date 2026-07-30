import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';

import '../../../../core/theme/app_style.dart';

Widget buildBotMessage(BuildContext context, String text) {
  return InkWell(
    onLongPress: (){
      Clipboard.setData(ClipboardData(text: text));
    },
    child: Container(
      width: 0.80.sw,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color:context.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(text, style: AppStyle.bodySmall),
    ),
  );
}
