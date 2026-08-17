import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/widgets/animation_widget.dart';

import '../../../../core/enums/order_status_enum.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../../data/models/order_model.dart';

class OrderTrackingTimeline extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingTimeline({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order.statusEnum;

    bool isPending = status == OrderStatusEnum.pending;
    bool isAccepted = status == OrderStatusEnum.accepted;
    bool isInTransit = status == OrderStatusEnum.inTransit;
    bool isDelivered = status == OrderStatusEnum.delivered;
    bool isCompleted = status == OrderStatusEnum.completed;

    bool hasPassedAccepted = isAccepted || isInTransit || isDelivered || isCompleted;
    bool hasPassedInTransit = isInTransit || isDelivered || isCompleted;
    bool hasPassedDelivered = isDelivered || isCompleted;

    String? formattedDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        final date = DateTime.parse(dateStr);
        return DataHelper.dateFormat('MMM d, yyyy • hh:mm a', date,locale: context.locale);
      } catch (_) {
        return dateStr;
      }
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'order_tracking_title'.tr(),
            style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24.h),
          _TimelineItem(
            title: 'tracking_created'.tr(),
            subtitle: 'order_placed_successfully'.tr(),
            date: formattedDate(order.createdAt),
            isCompleted: true,
          ),
          _TimelineItem(
            title: 'accepted'.tr(),
            subtitle: 'order_accepted_desc'.tr(),
            isCompleted: hasPassedAccepted,
            isCurrent: isPending,
          ),
          _TimelineItem(
            title: 'in_transit'.tr(),
            subtitle: 'order_in_transit_desc'.tr(),
            isCompleted: hasPassedInTransit,
            isCurrent: isAccepted,
          ),
          _TimelineItem(
            title: 'tracking_delivered'.tr(),
            subtitle: 'order_delivered_desc'.tr(),
            isCompleted: hasPassedDelivered,
            isCurrent: isInTransit,
          ),
          _TimelineItem(
            title: 'completed'.tr(),
            subtitle: 'order_completed_desc'.tr(),
            date: isCompleted ? formattedDate(order.updatedAt) : null,
            isLast: true,
            isCompleted: isCompleted,
            isCurrent: isDelivered,
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? date;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;
  final IconData? icon;
  final Color? iconColor;

  const _TimelineItem({
    required this.title,
    required this.subtitle,
    this.date,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isLast = false,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationWidget(
      child: IntrinsicHeight(
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                    iconColor ??
                        (isCurrent
                            ? AppColors.secondaryColor
                            : isCompleted
                            ? AppColors.darkMode
                            : AppColors.lightGrey),
                  ),
                  child: icon != null
                      ? Icon(icon, color: Colors.white, size: 14.sp)
                      : isCurrent
                      ? Center(
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                      : isCompleted
                      ? Icon(Icons.check, color: Colors.white, size: 12.sp)
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2.w,
                      color: isCompleted
                          ? AppColors.darkMode
                          : AppColors.lightGrey,
                    ),
                  ),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? null : AppColors.grey,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppStyle.bodySmall.copyWith(
                      color: AppColors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                  if (date != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        date!,
                        style: AppStyle.labelSmall.copyWith(
                          color: AppColors.primaryColor.withOpacity(0.6),
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
