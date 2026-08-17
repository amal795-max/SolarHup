import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/presentation/bloc/schedule_service_bloc/schedule_service_bloc.dart';
import 'package:untitled1/features/services/presentation/widgets/schedule_time_picker.dart';

class ScheduleTimeSection extends StatelessWidget {
  final ScheduleServiceLoaded state;

  const ScheduleTimeSection({super.key, required this.state});

  void _selectSlot(BuildContext context, String slotId) {
    context.read<ScheduleServiceBloc>().add(SelectScheduleTimeSlotEvent(slotId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headingColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final date = state.selectedDate;
    final availability = state.timeAvailability;

    if (date == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'schedule_select_time'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: headingColor,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'schedule_pick_date_first'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey),
          ),
        ],
      );
    }

    if (!state.hasSelectableTimes) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'schedule_select_time'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: headingColor,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'schedule_no_time_slots'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'schedule_select_time'.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: headingColor,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'schedule_any_minute_hint'.tr(),
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.grey),
        ),
        SizedBox(height: 14.h),
        ScheduleTimePicker(
          forDate: date,
          availability: availability,
          selectedSlotId: state.selectedTimeSlotId,
          onChanged: (slotId) => _selectSlot(context, slotId),
        ),
      ],
    );
  }
}
