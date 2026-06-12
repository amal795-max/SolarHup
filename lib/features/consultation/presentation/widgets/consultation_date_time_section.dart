import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/consultation/data/models/consultation_booking_model.dart';
import 'package:untitled1/features/consultation/presentation/bloc/book_consultation_bloc/book_consultation_bloc.dart';

class ConsultationDateTimeSection extends StatelessWidget {
  final String monthYearLabel;
  final List<CalendarDayModel> calendarDays;
  final List<TimeSlotModel> timeSlots;
  final DateTime selectedDate;
  final String selectedTimeSlotId;

  const ConsultationDateTimeSection({
    super.key,
    required this.monthYearLabel,
    required this.calendarDays,
    required this.timeSlots,
    required this.selectedDate,
    required this.selectedTimeSlotId,
  });

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'consultation_date_time_title'.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            IconButton(
              onPressed: () => context
                  .read<BookConsultationBloc>()
                  .add(const PreviousWeekEvent()),
              icon: Icon(
                Icons.chevron_left_rounded,
                color: theme.colorScheme.onSurface,
                size: 24.sp,
              ),
            ),
            Expanded(
              child: Text(
                monthYearLabel,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              onPressed: () =>
                  context.read<BookConsultationBloc>().add(const NextWeekEvent()),
              icon: Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface,
                size: 24.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: calendarDays.map((day) {
            final isSelected = _isSameDay(day.date, selectedDate);
            return Expanded(
              child: _CalendarDayCell(
                day: day,
                isSelected: isSelected,
                onTap: () => context.read<BookConsultationBloc>().add(
                      SelectConsultationDateEvent(day.date),
                    ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 18.h),
        Text(
          'consultation_available_slots'.tr(),
          style: theme.textTheme.displaySmall?.copyWith(
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: timeSlots.map((slot) {
            final isSelected = slot.id == selectedTimeSlotId;
            return _TimeSlotChip(
              label: slot.label,
              isSelected: isSelected,
              onTap: () => context.read<BookConsultationBloc>().add(
                    SelectTimeSlotEvent(slot.id),
                  ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final CalendarDayModel day;
  final bool isSelected;
  final VoidCallback onTap;

  const _CalendarDayCell({
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Column(
            children: [
              Text(
                day.dayLabel,
                style: theme.textTheme.bodySmall,
              ),
              SizedBox(height: 6.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36.w,
                height: 36.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '${day.date.day}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? AppColors.white
                        : day.isCurrentMonth
                            ? theme.colorScheme.onSurface
                            : theme.textTheme.bodySmall?.color,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeSlotChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeSlotChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isSelected
          ? AppColors.secondaryColor
          : (isDark
              ? AppColors.darkGray
              : theme.colorScheme.tertiaryContainer),
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected ? AppColors.tertiaryColor : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
