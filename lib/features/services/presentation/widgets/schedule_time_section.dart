import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/presentation/bloc/schedule_service_bloc/schedule_service_bloc.dart';

class ScheduleTimeSection extends StatelessWidget {
  final ScheduleServiceLoaded state;

  const ScheduleTimeSection({super.key, required this.state});

  IconData _iconForType(String type) => switch (type) {
        'cloudy' => Icons.wb_cloudy_outlined,
        _ => Icons.wb_sunny_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headingColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final slots = state.service.timeSlots;

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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 2.4,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            final isSelected = slot.id == state.selectedTimeSlotId;
            final isAvailable = slot.isAvailable;

            return Material(
              color: isSelected
                  ? AppColors.secondaryColor
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              clipBehavior: Clip.antiAlias,
              elevation: isDark || isSelected ? 0 : 1,
              shadowColor: Colors.black.withValues(alpha: 0.06),
              child: InkWell(
                onTap: isAvailable
                    ? () => context.read<ScheduleServiceBloc>().add(
                          SelectScheduleTimeSlotEvent(slot.id),
                        )
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondaryColor
                          : theme.colorScheme.outline.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _iconForType(slot.iconType),
                        size: 18.sp,
                        color: isAvailable
                            ? (isSelected
                                ? AppColors.tertiaryColor
                                : AppColors.grey)
                            : AppColors.grey.withValues(alpha: 0.45),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        slot.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isAvailable
                              ? (isSelected
                                  ? AppColors.black
                                  : theme.colorScheme.onSurface)
                              : AppColors.grey.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
