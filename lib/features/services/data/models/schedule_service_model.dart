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

  const ScheduleCalendarDayModel({
    required this.date,
    required this.isCurrentMonth,
  });
}

class ScheduleServiceModel {
  final String serviceId;
  final String title;
  final String subtitle;
  final int heroColorValue;
  final String appointmentSummaryTitle;
  final List<ServiceTimeSlotModel> timeSlots;
  final DateTime defaultSelectedDate;
  final String defaultSelectedTimeSlotId;
  final int calendarYear;
  final int calendarMonth;

  const ScheduleServiceModel({
    required this.serviceId,
    required this.title,
    required this.subtitle,
    required this.heroColorValue,
    required this.appointmentSummaryTitle,
    required this.timeSlots,
    required this.defaultSelectedDate,
    required this.defaultSelectedTimeSlotId,
    required this.calendarYear,
    required this.calendarMonth,
  });
}

List<ScheduleCalendarDayModel> buildMonthCalendarDays(
  int year,
  int month, {
  int rowCount = 4,
}) {
  final firstDay = DateTime(year, month, 1);
  final startDate = firstDay.subtract(Duration(days: firstDay.weekday - 1));

  return List.generate(rowCount * 7, (index) {
    final date = startDate.add(Duration(days: index));
    return ScheduleCalendarDayModel(
      date: date,
      isCurrentMonth: date.month == month,
    );
  });
}
