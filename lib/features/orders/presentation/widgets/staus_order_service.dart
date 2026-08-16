
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/enums/order_status_enum.dart';

class StatusOrderService extends StatelessWidget {
  final String text;
  final OrderStatusEnum color;

  const StatusOrderService({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.backgroundColor ,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: color.borderAndLabelColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.borderAndLabelColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}