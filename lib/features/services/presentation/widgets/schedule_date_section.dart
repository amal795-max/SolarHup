import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/services/data/models/schedule_service_model.dart';
import 'package:untitled1/features/services/presentation/bloc/schedule_service_bloc/schedule_service_bloc.dart';

class ScheduleDateSection extends StatelessWidget {
  final ScheduleServiceLoaded state;

  const ScheduleDateSection({super.key, required this.state});

  bool _isSameDay(DateTime a, DateTime? b) =>
      b != null && a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headingColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final days = state.calendarDays;
    final weekdayLabels = List.generate(7, (index) {
      final monday = DateTime(2024, 1, 1);
      return DateFormat('EEE').format(monday.add(Duration(days: index))).toUpperCase();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'schedule_select_date'.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: headingColor,
                ),
              ),
            ),
            _MonthNavigator(
              label: state.monthYearLabel,
              headingColor: headingColor,
              canGoBack: state.canGoToPreviousMonth,
              onPrevious: () => context.read<ScheduleServiceBloc>().add(
                    const ChangeScheduleMonthEvent(-1),
                  ),
              onNext: () => context.read<ScheduleServiceBloc>().add(
                    const ChangeScheduleMonthEvent(1),
                  ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        if (state.availabilitySummary != null) ...[
          Text(
            state.availabilitySummary!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
        ],
        Row(
          children: weekdayLabels
              .map(
                (label) => Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 8.h),
        ...List.generate(ScheduleServiceLoaded.calendarRowCount, (row) {
          final rowDays = days.sublist(row * 7, row * 7 + 7);
          return Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Row(
              children: rowDays.map((day) {
                final isSelected = _isSameDay(day.date, state.selectedDate);
                return Expanded(
                  child: _CalendarDayCell(
                    day: day,
                    isSelected: isSelected,
                    onTap: day.isSelectable
                        ? () => context
                            .read<ScheduleServiceBloc>()
                            .add(SelectScheduleDateEvent(day))
                        : null,
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}

class _MonthNavigator extends StatelessWidget {
  final String label;
  final Color headingColor;
  final bool canGoBack;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MonthNavigator({
    required this.label,
    required this.headingColor,
    required this.canGoBack,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: canGoBack ? onPrevious : null,
            icon: Icon(Icons.chevron_left_rounded, color: headingColor),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.w),
            tooltip: MaterialLocalizations.of(context).previousMonthTooltip,
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: headingColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: Icon(Icons.chevron_right_rounded, color: headingColor),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.w),
            tooltip: MaterialLocalizations.of(context).nextMonthTooltip,
          ),
        ],
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final ScheduleCalendarDayModel day;
  final bool isSelected;
  final VoidCallback? onTap;

  const _CalendarDayCell({
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = day.isSelectable;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36.w,
            height: 36.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              '${day.date.day}',
              style: AppStyle.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.white
                    : !isEnabled
                        ? AppColors.grey.withValues(alpha: 0.35)
                        : day.isCurrentMonth
                            ? theme.colorScheme.onSurface
                            : AppColors.grey.withValues(alpha: 0.5),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
