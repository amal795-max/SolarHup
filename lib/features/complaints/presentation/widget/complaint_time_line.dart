import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../../data/models/complaint_model.dart';

Widget buildTimeline(ComplaintModel complaint) {
  return Column(
    children: [
      _TimelineTile(
        title: 'complaint_submitted'.tr(),
        date: DateFormat('MMM dd, hh:mm a').format(complaint.createdAt),
        isFirst: true,
        isActive: true,
      ),
      _TimelineTile(
        title: 'under_review'.tr(),
        date: '',
        isActive: complaint.status != 'pending',
      ),
      _TimelineTile(
        title: 'resolved'.tr(),
        date: '',
        isLast: true,
        isActive: complaint.status == 'resolved',
      ),
    ],
  );
}class _TimelineTile extends StatelessWidget {
  final String title;
  final String date;
  final bool isFirst;
  final bool isLast;
  final bool isActive;

  const _TimelineTile({required this.title, required this.date, this.isFirst = false, this.isLast = false, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(isActive ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isActive ? AppColors.primaryColor : AppColors.grey, size: 24),
            if (!isLast) Container(width: 2, height: 40, color: AppColors.borderColor),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyle.bodyMedium.copyWith(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? null : AppColors.grey,
              )),
              if (date.isNotEmpty) Text(date, style: AppStyle.bodyXSmall.copyWith(color: AppColors.grey)),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ],
    );
  }
}
