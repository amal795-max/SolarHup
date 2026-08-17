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

  bool hasSelectableTimes(DateTime forDate) {
    if (!isDateSelectable(forDate)) return false;
    final start = _minutesOfDay(shiftStartTime);
    final end = _minutesOfDay(shiftEndTime);
    if (end <= start) return false;

    for (var minutes = start; minutes < end; minutes++) {
      final hour = minutes ~/ 60;
      final minute = minutes % 60;
      if (isTimeSelectable(forDate: forDate, hour: hour, minute: minute)) {
        return true;
      }
    }
    return false;
  }

  TimeOfDay get shiftStartTime =>
      _parseTime(shiftStart) ?? const TimeOfDay(hour: 9, minute: 0);

  TimeOfDay get shiftEndTime =>
      _parseTime(shiftEnd) ?? const TimeOfDay(hour: 17, minute: 0);

  int get shiftStartMinutes => _minutesOfDay(shiftStartTime);

  int get shiftEndMinutes => _minutesOfDay(shiftEndTime);

  bool isTimeSelectable({
    required DateTime forDate,
    required int hour,
    required int minute,
  }) {
    if (!isDateSelectable(forDate)) return false;

    final selected = minute + hour * 60;
    if (selected < shiftStartMinutes || selected >= shiftEndMinutes) {
      return false;
    }

    if (_isSameDay(forDate, DateTime.now())) {
      final slotDateTime = DateTime(
        forDate.year,
        forDate.month,
        forDate.day,
        hour,
        minute,
      );
      if (!slotDateTime.isAfter(DateTime.now())) return false;
    }

    return true;
  }

  (int hour, int minute)? parseSlotId(String slotId) {
    final parts = slotId.split('-');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return (hour, minute);
  }

  String slotIdFor({required int hour, required int minute}) =>
      '${hour.toString().padLeft(2, '0')}-${minute.toString().padLeft(2, '0')}';

  ServiceTimeSlotModel createSlotModel({
    required DateTime forDate,
    required int hour,
    required int minute,
  }) {
    final id = slotIdFor(hour: hour, minute: minute);
    final label = DateFormat('hh:mm a').format(
      DateTime(forDate.year, forDate.month, forDate.day, hour, minute),
    );
    return ServiceTimeSlotModel(
      id: id,
      label: label,
    );
  }

  (int hour, int minute)? firstSelectableTime(DateTime forDate) {
    if (!isDateSelectable(forDate)) return null;
    final start = shiftStartMinutes;
    final end = shiftEndMinutes;
    for (var minutes = start; minutes < end; minutes++) {
      final hour = minutes ~/ 60;
      final minute = minutes % 60;
      if (isTimeSelectable(forDate: forDate, hour: hour, minute: minute)) {
        return (hour, minute);
      }
    }
    return null;
  }

  List<int> selectableHours(DateTime forDate) {
    final hours = <int>[];
    for (var hour = shiftStartTime.hour; hour <= shiftEndTime.hour; hour++) {
      for (var minute = 0; minute < 60; minute++) {
        if (isTimeSelectable(forDate: forDate, hour: hour, minute: minute)) {
          if (!hours.contains(hour)) hours.add(hour);
          break;
        }
      }
    }
    return hours;
  }

  List<int> selectableMinutes({
    required DateTime forDate,
    required int hour,
  }) {
    final minutes = <int>[];
    for (var minute = 0; minute < 60; minute++) {
      if (isTimeSelectable(forDate: forDate, hour: hour, minute: minute)) {
        minutes.add(minute);
      }
    }
    return minutes;
  }

  static int _minutesOfDay(TimeOfDay time) => time.hour * 60 + time.minute;

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

  String get shiftWindowLabel {
    return '${_formatTimeOfDay(shiftStartTime)} – ${_formatTimeOfDay(shiftEndTime)}';
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

  static String formatTimeOfDay(TimeOfDay time) {
    final date = DateTime(2024, 1, 1, time.hour, time.minute);
    return DateFormat('h:mm a').format(date);
  }

  static String _formatTimeOfDay(TimeOfDay time) => formatTimeOfDay(time);
}

WorkshopAvailabilityModel defaultScheduleAvailability() {
  return const WorkshopAvailabilityModel(
    businessId: 0,
    availableMonday: true,
    availableTuesday: true,
    availableWednesday: true,
    availableThursday: true,
    availableFriday: true,
    availableSaturday: true,
    availableSunday: true,
    shiftStart: '09:00',
    shiftEnd: '17:00',
  );
}
