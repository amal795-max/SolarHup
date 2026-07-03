import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/presentation/bloc/schedule_service_bloc/schedule_service_bloc.dart';
import 'package:untitled1/widgets/text_with_icon.dart';

class ScheduleAppointmentSummary extends StatelessWidget {
  final ScheduleServiceLoaded state;

  const ScheduleAppointmentSummary({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.deepPrimaryColor : AppColors.primaryColor;
    final selectedTime = state.selectedTimeSlot?.label ?? '';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
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
                      'schedule_appointment_label'.tr(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      state.service.appointmentSummaryTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.bolt_rounded,
                  color: AppColors.primaryColor,
                  size: 22.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: TextWithIcon(
                  title: state.formattedSelectedDate,
                  icon: Icons.calendar_today_outlined,
                  color: AppColors.blue,
                ),
              ),
              if (selectedTime.isNotEmpty)
                Expanded(
                  child: TextWithIcon(
                    title: selectedTime,
                    icon: Icons.schedule_rounded,
                    color: AppColors.blue,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
