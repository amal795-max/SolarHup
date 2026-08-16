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

  List<ScheduleCalendarDayModel> get calendarDays =>
      buildMonthCalendarDays(
        viewYear,
        viewMonth,
        rowCount: calendarRowCount,
        availability: service.availability,
      );

  List<ServiceTimeSlotModel> get timeSlots {
    final date = selectedDate;
    if (date == null) return const [];
    final availability = service.availability;
    if (availability != null) {
      if (!availability.isDateSelectable(date)) return const [];
      return availability.buildTimeSlots(forDate: date);
    }
    return defaultScheduleTimeSlots();
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

  String get monthYearLabel =>
      DateFormat('MMMM yyyy').format(DateTime(viewYear, viewMonth));

  String get formattedSelectedDate {
    final date = selectedDate;
    if (date == null) return '—';
    return DateFormat('MMM d, yyyy').format(date);
  }

  ServiceTimeSlotModel? get selectedTimeSlot {
    if (selectedTimeSlotId == null) return null;
    for (final slot in timeSlots) {
      if (slot.id == selectedTimeSlotId) return slot;
    }
    return null;
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
      selectedDate:
          clearSelectedDate ? null : (selectedDate ?? this.selectedDate),
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
