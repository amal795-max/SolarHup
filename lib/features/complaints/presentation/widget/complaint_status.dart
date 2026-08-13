
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

class ComplaintStatus extends StatelessWidget {
  final String status;
  const ComplaintStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status.toLowerCase() == 'resolved' ? AppColors.green : AppColors.blue;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r)),
      child: Text(status.tr(), style: TextStyle(color: color, fontSize: 10.sp, fontWeight: FontWeight.bold)),
    );
  }
}