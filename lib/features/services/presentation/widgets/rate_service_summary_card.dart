import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/orders/presentation/widgets/staus_order_service.dart';
import 'package:untitled1/features/services/data/models/service_request_model.dart';
import 'package:untitled1/widgets/text_with_icon.dart';

class RateServiceSummaryCard extends StatelessWidget {
  final ServiceRequestModel request;

  const RateServiceSummaryCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final serviceTitle = request.serviceName.isNotEmpty
        ? request.serviceName
        : request.orderCode;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (!context.brightness)
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.12),
                child: Icon(
                  Icons.home_repair_service_outlined,
                  color: AppColors.primaryColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                serviceTitle,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: titleColor,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'services_tab'.tr(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '#${request.orderCode}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    StatusOrderService(
                      text: request.statusEnum.status.tr(),
                      color: request.statusEnum,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              TextWithIcon(
                icon: Icons.calendar_today_outlined,
                title: request.displayDate,
                color: AppColors.grey,
              ),
              SizedBox(width: 20.w),
              TextWithIcon(
                icon: Icons.access_time,
                title: request.displayTime,
                color: AppColors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
