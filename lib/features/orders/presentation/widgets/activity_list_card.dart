import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/enums/order_status_enum.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/widgets/container_style_widget.dart';

class ActivityListCard extends StatelessWidget {
  final IconData icon;
  final String code;
  final String title;
  final String price;
  final OrderStatusEnum status;

  const ActivityListCard({
    super.key,
    required this.icon,
    required this.code,
    required this.title,
    required this.price,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return container(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
              ),
              _StatusBadge(text: status.status.tr(), color: status),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            code,
            style: AppStyle.labelSmall.copyWith(color: AppColors.grey),
          ),
          Text(
            title,
            style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          Divider(color: AppColors.borderColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total_price_label'.tr(),
                style: AppStyle.labelSmall.copyWith(color: AppColors.grey),
              ),
              Text(
                '$price \$',
                style: AppStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final OrderStatusEnum color;

  const _StatusBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.backgroundColor,
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
