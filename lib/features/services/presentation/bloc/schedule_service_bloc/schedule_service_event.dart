part of 'schedule_service_bloc.dart';

@immutable
sealed class ScheduleServiceEvent extends Equatable {
  const ScheduleServiceEvent();

  @override
  List<Object?> get props => [];
}

final class LoadScheduleServiceEvent extends ScheduleServiceEvent {
  final String serviceId;
  final int? businessId;
  final String? serviceName;
  final String? serviceSubtitle;

  const LoadScheduleServiceEvent({
    required this.serviceId,
    this.businessId,
    this.serviceName,
    this.serviceSubtitle,
  });

  @override
  List<Object?> get props => [serviceId, businessId, serviceName, serviceSubtitle];
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

final class UpdateScheduleNotesEvent extends ScheduleServiceEvent {
  final String value;

  const UpdateScheduleNotesEvent(this.value);

  @override
  List<Object?> get props => [value];
}
