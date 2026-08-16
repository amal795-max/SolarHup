import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/features/complaints/presentation/widget/complaint_status.dart';
import '../../../../core/helper/data_helper.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../../data/models/complaint_model.dart';

class ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;

  const ComplaintCard({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          context.push(AppRoutes.complaintDetails(complaint.id.toString())),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.lightYellow,
                  child: Icon(Icons.business_rounded, color: AppColors.brown,
                      size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        complaint.businessName,
                        style: AppStyle.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DataHelper.dateFormat(
                            'MMM dd, yyyy - hh:mm a', complaint.updatedAt,locale: context.locale),
                        style: AppStyle.bodySmall.copyWith(
                            color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
                ComplaintStatus(status: complaint.status),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Divider(
                  color: AppColors.borderColor, height: 1),
            ),
            Text(
              complaint.subject,
              style: AppStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.deepGrey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${complaint.messages.length} ${'messages'.tr()}',
                  style: AppStyle.bodySmall.copyWith(
                      color: AppColors.primaryColor),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 14.sp,
                    color: AppColors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}