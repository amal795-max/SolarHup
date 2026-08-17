import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/services/data/models/workshop_availability_model.dart';

class ScheduleTimePicker extends StatefulWidget {
  final DateTime forDate;
  final WorkshopAvailabilityModel availability;
  final String? selectedSlotId;
  final ValueChanged<String> onChanged;

  const ScheduleTimePicker({
    super.key,
    required this.forDate,
    required this.availability,
    required this.selectedSlotId,
    required this.onChanged,
  });

  @override
  State<ScheduleTimePicker> createState() => _ScheduleTimePickerState();
}

class _ScheduleTimePickerState extends State<ScheduleTimePicker> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  late int _hour;
  late int _minute;

  List<int> _hours = const [];
  List<int> _minutes = const [];

  @override
  void initState() {
    super.initState();
    _bootstrapSelection();
    _hourController = FixedExtentScrollController(initialItem: _hourIndex);
    _minuteController = FixedExtentScrollController(initialItem: _minuteIndex);
  }

  @override
  void didUpdateWidget(covariant ScheduleTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.forDate != widget.forDate ||
        oldWidget.selectedSlotId != widget.selectedSlotId ||
        oldWidget.availability != widget.availability) {
      _bootstrapSelection();
      _syncControllers();
    }
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _bootstrapSelection() {
    _hours = widget.availability.selectableHours(widget.forDate);
    final parsed = widget.selectedSlotId != null
        ? widget.availability.parseSlotId(widget.selectedSlotId!)
        : null;

    if (parsed != null &&
        widget.availability.isTimeSelectable(
          forDate: widget.forDate,
          hour: parsed.$1,
          minute: parsed.$2,
        )) {
      _hour = parsed.$1;
      _minute = parsed.$2;
    } else {
      final first = widget.availability.firstSelectableTime(widget.forDate);
      _hour = first?.$1 ?? widget.availability.shiftStartTime.hour;
      _minute = first?.$2 ?? widget.availability.shiftStartTime.minute;
    }

    _minutes = widget.availability.selectableMinutes(
      forDate: widget.forDate,
      hour: _hour,
    );
    if (_minutes.isNotEmpty && !_minutes.contains(_minute)) {
      _minute = _minutes.first;
    }
  }

  int get _hourIndex {
    final index = _hours.indexOf(_hour);
    return index >= 0 ? index : 0;
  }

  int get _minuteIndex {
    final index = _minutes.indexOf(_minute);
    return index >= 0 ? index : 0;
  }

  void _syncControllers() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_hourController.hasClients && _hours.isNotEmpty) {
        _hourController.jumpToItem(_hourIndex);
      }
      if (_minuteController.hasClients && _minutes.isNotEmpty) {
        _minuteController.jumpToItem(_minuteIndex);
      }
    });
  }

  void _emitSelection() {
    final id = widget.availability.slotIdFor(hour: _hour, minute: _minute);
    widget.onChanged(id);
  }

  void _onHourChanged(int index) {
    if (index < 0 || index >= _hours.length) return;
    final hour = _hours[index];
    final minutes = widget.availability.selectableMinutes(
      forDate: widget.forDate,
      hour: hour,
    );
    final minute = minutes.contains(_minute) ? _minute : minutes.first;

    setState(() {
      _hour = hour;
      _minutes = minutes;
      _minute = minute;
    });

    _syncControllers();
    HapticFeedback.selectionClick();
    _emitSelection();
  }

  void _onMinuteChanged(int index) {
    if (index < 0 || index >= _minutes.length) return;
    setState(() => _minute = _minutes[index]);
    HapticFeedback.selectionClick();
    _emitSelection();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_hours.isEmpty || _minutes.isEmpty) {
      return Text(
        'schedule_no_time_slots'.tr(),
        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey),
      );
    }

    final displayTime = DateFormat('hh:mm').format(
      DateTime(
        widget.forDate.year,
        widget.forDate.month,
        widget.forDate.day,
        _hour,
        _minute,
      ),
    );
    final period = DateFormat('a').format(
      DateTime(
        widget.forDate.year,
        widget.forDate.month,
        widget.forDate.day,
        _hour,
        _minute,
      ),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.deepPrimaryColor,
                  AppColors.darkContainer,
                ]
              : [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withValues(alpha: 0.88),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: isDark ? 0.2 : 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.schedule_rounded, color: AppColors.secondaryColor, size: 20.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    widget.availability.shiftWindowLabel,
                    style: AppStyle.labelMedium.copyWith(
                      color: AppColors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    displayTime,
                    style: TextStyle(
                      fontSize: 52.sp,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      period,
                      style: AppStyle.labelSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            NotificationListener<ScrollNotification>(
              onNotification: (_) => true,
              child: Container(
                height: 170.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkGray.withValues(alpha: 0.55)
                      : AppColors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _WheelColumn(
                        label: 'schedule_hour'.tr(),
                        controller: _hourController,
                        itemCount: _hours.length,
                        selectedIndex: _hourIndex,
                        formatter: (index) =>
                            _hours[index].toString().padLeft(2, '0'),
                        onSelectedItemChanged: _onHourChanged,
                      ),
                    ),
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    Expanded(
                      child: _WheelColumn(
                        label: 'schedule_minute'.tr(),
                        controller: _minuteController,
                        itemCount: _minutes.length,
                        selectedIndex: _minuteIndex,
                        formatter: (index) =>
                            _minutes[index].toString().padLeft(2, '0'),
                        onSelectedItemChanged: _onMinuteChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WheelColumn extends StatelessWidget {
  final String label;
  final FixedExtentScrollController controller;
  final int itemCount;
  final int selectedIndex;
  final String Function(int index) formatter;
  final ValueChanged<int> onSelectedItemChanged;

  const _WheelColumn({
    required this.label,
    required this.controller,
    required this.itemCount,
    required this.selectedIndex,
    required this.formatter,
    required this.onSelectedItemChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppStyle.labelSmall.copyWith(
            color: AppColors.white.withValues(alpha: 0.65),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.stylus,
                PointerDeviceKind.trackpad,
              },
            ),
            child: ListWheelScrollView.useDelegate(
              controller: controller,
              itemExtent: 42.h,
              physics: const FixedExtentScrollPhysics(
                parent: BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast,
                ),
              ),
              perspective: 0.003,
              diameterRatio: 1.4,
              onSelectedItemChanged: onSelectedItemChanged,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: itemCount,
                builder: (context, index) {
                  final isSelected = index == selectedIndex;
                  return Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 180),
                      style: TextStyle(
                        fontSize: isSelected ? 28.sp : 20.sp,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.white.withValues(alpha: 0.35),
                      ),
                      child: Text(formatter(index)),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
