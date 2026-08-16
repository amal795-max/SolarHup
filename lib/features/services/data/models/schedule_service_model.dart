import 'workshop_availability_model.dart';

class ServiceTimeSlotModel {
  final String id;
  final String label;
  final bool isAvailable;
  final String iconType;

  const ServiceTimeSlotModel({
    required this.id,
    required this.label,
    this.isAvailable = true,
    this.iconType = 'sunny',
  });
}

class ScheduleCalendarDayModel {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isSelectable;

  const ScheduleCalendarDayModel({
    required this.date,
    required this.isCurrentMonth,
    this.isSelectable = true,
  });
}

class ScheduleServiceModel {
  final String serviceId;
  final String title;
  final String subtitle;
  final int heroColorValue;
  final String appointmentSummaryTitle;
  final WorkshopAvailabilityModel? availability;
  final int calendarYear;
  final int calendarMonth;

  const ScheduleServiceModel({
    required this.serviceId,
    required this.title,
    required this.subtitle,
    required this.heroColorValue,
    required this.appointmentSummaryTitle,
    this.availability,
    required this.calendarYear,
    required this.calendarMonth,
  });
}

List<ScheduleCalendarDayModel> buildMonthCalendarDays(
  int year,
  int month, {
  int rowCount = 4,
  WorkshopAvailabilityModel? availability,
}) {
  final firstDay = DateTime(year, month, 1);
  final startDate = firstDay.subtract(Duration(days: firstDay.weekday - 1));

  return List.generate(rowCount * 7, (index) {
    final date = startDate.add(Duration(days: index));
    final isSelectable = availability?.isDateSelectable(date) ??
        !_isPastDate(date);
    return ScheduleCalendarDayModel(
      date: date,
      isCurrentMonth: date.month == month,
      isSelectable: isSelectable,
    );
  });
}

bool _isPastDate(DateTime date) {
  final today = DateTime.now();
  final todayOnly = DateTime(today.year, today.month, today.day);
  final candidate = DateTime(date.year, date.month, date.day);
  return candidate.isBefore(todayOnly);
}
