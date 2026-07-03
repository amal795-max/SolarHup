part of 'schedule_service_bloc.dart';

@immutable
sealed class ScheduleServiceEvent extends Equatable {
  const ScheduleServiceEvent();

  @override
  List<Object?> get props => [];
}

final class LoadScheduleServiceEvent extends ScheduleServiceEvent {
  final String serviceId;

  const LoadScheduleServiceEvent(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}

final class SelectScheduleDateEvent extends ScheduleServiceEvent {
  final ScheduleCalendarDayModel day;

  const SelectScheduleDateEvent(this.day);

  @override
  List<Object?> get props => [day];
}

final class SelectScheduleTimeSlotEvent extends ScheduleServiceEvent {
  final String timeSlotId;

  const SelectScheduleTimeSlotEvent(this.timeSlotId);

  @override
  List<Object?> get props => [timeSlotId];
}

final class ChangeScheduleMonthEvent extends ScheduleServiceEvent {
  final int delta;

  const ChangeScheduleMonthEvent(this.delta);

  @override
  List<Object?> get props => [delta];
}

final class UpdateSchedulePriorityEvent extends ScheduleServiceEvent {
  final String value;

  const UpdateSchedulePriorityEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class UpdateSchedulePanelsEvent extends ScheduleServiceEvent {
  final String value;

  const UpdateSchedulePanelsEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class UpdateScheduleNotesEvent extends ScheduleServiceEvent {
  final String value;

  const UpdateScheduleNotesEvent(this.value);

  @override
  List<Object?> get props => [value];
}
