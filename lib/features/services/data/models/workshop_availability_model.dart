import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'schedule_service_model.dart';

class WorkshopAvailabilityModel {
  final int businessId;
  final bool availableMonday;
  final bool availableTuesday;
  final bool availableWednesday;
  final bool availableThursday;
  final bool availableFriday;
  final bool availableSaturday;
  final bool availableSunday;
  final String? shiftStart;
  final String? shiftEnd;
  final int? breakMinutes;

  const WorkshopAvailabilityModel({
    required this.businessId,
    this.availableMonday = false,
    this.availableTuesday = false,
    this.availableWednesday = false,
    this.availableThursday = false,
    this.availableFriday = false,
    this.availableSaturday = false,
    this.availableSunday = false,
    this.shiftStart,
    this.shiftEnd,
    this.breakMinutes,
  });

  factory WorkshopAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return WorkshopAvailabilityModel(
      businessId: json['business_id'] as int? ?? 0,
      availableMonday: json['available_monday'] as bool? ?? false,
      availableTuesday: json['available_tuesday'] as bool? ?? false,
      availableWednesday: json['available_wednesday'] as bool? ?? false,
      availableThursday: json['available_thursday'] as bool? ?? false,
      availableFriday: json['available_friday'] as bool? ?? false,
      availableSaturday: json['available_saturday'] as bool? ?? false,
      availableSunday: json['available_sunday'] as bool? ?? false,
      shiftStart: json['shift_start'] as String?,
      shiftEnd: json['shift_end'] as String?,
      breakMinutes: json['break_minutes'] as int?,
    );
  }

  bool get hasAnyWeekday =>
      availableMonday ||
      availableTuesday ||
      availableWednesday ||
      availableThursday ||
      availableFriday ||
      availableSaturday ||
      availableSunday;

  bool isDayAvailable(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return availableMonday;
      case DateTime.tuesday:
        return availableTuesday;
      case DateTime.wednesday:
        return availableWednesday;
      case DateTime.thursday:
        return availableThursday;
      case DateTime.friday:
        return availableFriday;
      case DateTime.saturday:
        return availableSaturday;
      case DateTime.sunday:
        return availableSunday;
      default:
        return false;
    }
  }

  bool isDateSelectable(DateTime date) {
    final today = _dateOnly(DateTime.now());
    final candidate = _dateOnly(date);
    if (candidate.isBefore(today)) return false;
    return isDayAvailable(date);
  }

  DateTime? findFirstAvailableDate({DateTime? startFrom}) {
    if (!hasAnyWeekday) return null;
    final anchor = _dateOnly(startFrom ?? DateTime.now());
    for (var offset = 0; offset < 366; offset++) {
      final date = anchor.add(Duration(days: offset));
      if (isDateSelectable(date)) return date;
    }
    return null;
  }

  List<ServiceTimeSlotModel> buildTimeSlots({
    required DateTime forDate,
    int intervalMinutes = 60,
  }) {
    final start = _parseTime(shiftStart) ?? const TimeOfDay(hour: 9, minute: 0);
    final end = _parseTime(shiftEnd) ?? const TimeOfDay(hour: 17, minute: 0);
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    if (endMinutes <= startMinutes) return const [];

    final now = DateTime.now();
    final isToday = _isSameDay(forDate, now);
    final slots = <ServiceTimeSlotModel>[];

    for (var minutes = startMinutes;
        minutes + intervalMinutes <= endMinutes;
        minutes += intervalMinutes) {
      final hour = minutes ~/ 60;
      final minute = minutes % 60;
      if (isToday) {
        final slotDateTime = DateTime(
          forDate.year,
          forDate.month,
          forDate.day,
          hour,
          minute,
        );
        if (!slotDateTime.isAfter(now)) continue;
      }

      final id = '${hour.toString().padLeft(2, '0')}-${minute.toString().padLeft(2, '0')}';
      final label = DateFormat('hh:mm a').format(
        DateTime(forDate.year, forDate.month, forDate.day, hour, minute),
      );
      slots.add(
        ServiceTimeSlotModel(
          id: id,
          label: label,
          iconType: hour >= 12 ? 'cloudy' : 'sunny',
        ),
      );
    }

    return slots;
  }

  String get summaryLabel {
    final dayLabels = <String>[];
    if (availableMonday) dayLabels.add('schedule_day_mon'.tr());
    if (availableTuesday) dayLabels.add('schedule_day_tue'.tr());
    if (availableWednesday) dayLabels.add('schedule_day_wed'.tr());
    if (availableThursday) dayLabels.add('schedule_day_thu'.tr());
    if (availableFriday) dayLabels.add('schedule_day_fri'.tr());
    if (availableSaturday) dayLabels.add('schedule_day_sat'.tr());
    if (availableSunday) dayLabels.add('schedule_day_sun'.tr());

    if (dayLabels.isEmpty) return 'schedule_no_availability'.tr();

    final start = _parseTime(shiftStart) ?? const TimeOfDay(hour: 9, minute: 0);
    final end = _parseTime(shiftEnd) ?? const TimeOfDay(hour: 17, minute: 0);
    final startLabel = _formatTimeOfDay(start);
    final endLabel = _formatTimeOfDay(end);

    return '${dayLabels.join(', ')} · $startLabel – $endLabel';
  }

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static TimeOfDay? _parseTime(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parts = value.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String _formatTimeOfDay(TimeOfDay time) {
    final date = DateTime(2024, 1, 1, time.hour, time.minute);
    return DateFormat('h:mm a').format(date);
  }
}

List<ServiceTimeSlotModel> defaultScheduleTimeSlots() {
  return const [
    ServiceTimeSlotModel(id: '09-00', label: '09:00 AM', iconType: 'sunny'),
    ServiceTimeSlotModel(id: '11-00', label: '11:00 AM', iconType: 'sunny'),
    ServiceTimeSlotModel(id: '14-00', label: '02:00 PM', iconType: 'sunny'),
    ServiceTimeSlotModel(id: '16-30', label: '04:30 PM', iconType: 'cloudy'),
  ];
}
