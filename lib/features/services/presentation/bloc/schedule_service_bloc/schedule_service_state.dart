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
  final DateTime selectedDate;
  final String selectedTimeSlotId;
  final int viewYear;
  final int viewMonth;
  final String priority;
  final String panelsCount;
  final String notes;

  const ScheduleServiceLoaded({
    required this.service,
    required this.selectedDate,
    required this.selectedTimeSlotId,
    required this.viewYear,
    required this.viewMonth,
    this.priority = '',
    this.panelsCount = '',
    this.notes = '',
  });

  List<ScheduleCalendarDayModel> get calendarDays =>
      buildMonthCalendarDays(viewYear, viewMonth, rowCount: calendarRowCount);

  String get monthYearLabel =>
      DateFormat('MMMM yyyy').format(DateTime(viewYear, viewMonth));

  String get formattedSelectedDate =>
      DateFormat('MMM d, yyyy').format(selectedDate);

  ServiceTimeSlotModel? get selectedTimeSlot {
    for (final slot in service.timeSlots) {
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
    String? priority,
    String? panelsCount,
    String? notes,
  }) {
    return ScheduleServiceLoaded(
      service: service ?? this.service,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlotId: selectedTimeSlotId ?? this.selectedTimeSlotId,
      viewYear: viewYear ?? this.viewYear,
      viewMonth: viewMonth ?? this.viewMonth,
      priority: priority ?? this.priority,
      panelsCount: panelsCount ?? this.panelsCount,
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
        priority,
        panelsCount,
        notes,
      ];
}

final class ScheduleServiceError extends ScheduleServiceState {
  final String message;

  const ScheduleServiceError({required this.message});

  @override
  List<Object?> get props => [message];
}
