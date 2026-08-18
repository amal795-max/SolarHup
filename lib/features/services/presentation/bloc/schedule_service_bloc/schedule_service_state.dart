part of 'schedule_service_bloc.dart';

@immutable
sealed class ScheduleServiceState extends Equatable {
  const ScheduleServiceState();

  @override
  List<Object?> get props => [];
}

final class ScheduleServiceInitial extends ScheduleServiceState {}

final class ScheduleServiceLoading extends ScheduleServiceState {}

final class ScheduleServiceLoaded extends ScheduleServiceState {
  static const int calendarRowCount = 4;

  final ScheduleServiceModel service;
  final DateTime? selectedDate;
  final String? selectedTimeSlotId;
  final int viewYear;
  final int viewMonth;
  final String notes;

  const ScheduleServiceLoaded({
    required this.service,
    required this.selectedDate,
    required this.selectedTimeSlotId,
    required this.viewYear,
    required this.viewMonth,
    this.notes = '',
  });

  List<ScheduleCalendarDayModel> get calendarDays => buildMonthCalendarDays(
    viewYear,
    viewMonth,
    rowCount: calendarRowCount,
    availability: service.availability,
  );

  WorkshopAvailabilityModel get timeAvailability =>
      service.availability ?? defaultScheduleAvailability();

  bool get hasSelectableTimes {
    final date = selectedDate;
    if (date == null) return false;
    return timeAvailability.hasSelectableTimes(date);
  }

  bool get hasBookableDays {
    final availability = service.availability;
    if (availability == null) return true;
    return availability.findFirstAvailableDate() != null;
  }

  String? get availabilitySummary {
    if (!hasBookableDays) return null;
    return service.availability?.summaryLabel;
  }

  String? get shiftWindowLabel => timeAvailability.shiftWindowLabel;

  String get monthYearLabel =>
      DateFormat('MMMM yyyy').format(DateTime(viewYear, viewMonth));

  bool get canGoToPreviousMonth {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final viewedMonth = DateTime(viewYear, viewMonth);
    return viewedMonth.isAfter(currentMonth);
  }

  String get formattedSelectedDate {
    final date = selectedDate;
    if (date == null) return '—';
    return DateFormat('MMM d, yyyy').format(date);
  }

  ServiceTimeSlotModel? get selectedTimeSlot {
    final id = selectedTimeSlotId;
    final date = selectedDate;
    if (id == null || date == null) return null;

    final parsed = timeAvailability.parseSlotId(id);
    if (parsed == null) return null;
    if (!timeAvailability.isTimeSelectable(
      forDate: date,
      hour: parsed.$1,
      minute: parsed.$2,
    )) {
      return null;
    }

    return timeAvailability.createSlotModel(
      forDate: date,
      hour: parsed.$1,
      minute: parsed.$2,
    );
  }

  ScheduleServiceLoaded copyWith({
    ScheduleServiceModel? service,
    DateTime? selectedDate,
    String? selectedTimeSlotId,
    int? viewYear,
    int? viewMonth,
    String? notes,
    bool clearSelectedDate = false,
    bool clearSelectedTimeSlot = false,
  }) {
    return ScheduleServiceLoaded(
      service: service ?? this.service,
      selectedDate: clearSelectedDate
          ? null
          : (selectedDate ?? this.selectedDate),
      selectedTimeSlotId: clearSelectedTimeSlot
          ? null
          : (selectedTimeSlotId ?? this.selectedTimeSlotId),
      viewYear: viewYear ?? this.viewYear,
      viewMonth: viewMonth ?? this.viewMonth,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    service,
    selectedDate,
    selectedTimeSlotId,
    viewYear,
    viewMonth,
    notes,
  ];
}

final class ScheduleServiceError extends ScheduleServiceState {
  final String message;

  const ScheduleServiceError({required this.message});

  @override
  List<Object?> get props => [message];
}
