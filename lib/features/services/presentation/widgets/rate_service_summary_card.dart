import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/data/models/service_rating_model.dart';
import 'package:untitled1/widgets/text_with_icon.dart';

class RateServiceSummaryCard extends StatelessWidget {
  final ServiceRatingModel rating;

  const RateServiceSummaryCard({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final technician = rating.technician;

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
                backgroundColor: Color(technician.avatarColorValue),
                backgroundImage: technician.avatarUrl != null
                    ? NetworkImage(technician.avatarUrl!)
                    : null,
                child: technician.avatarUrl == null
                    ? Text(
                        technician.name.isNotEmpty
                            ? technician.name[0].toUpperCase()
                            : '?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
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
                                technician.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: titleColor,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                technician.role,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          rating.serviceReferenceId,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'completed'.tr(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF16A34A),
                            fontWeight: FontWeight.w800,
                            fontSize: 9.sp,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
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
                title: rating.serviceDate,
                color: AppColors.grey,
              ),
              SizedBox(width: 20.w),
              TextWithIcon(
                icon: Icons.access_time,
                title: rating.serviceTime,
                color: AppColors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
