import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/services/data/models/schedule_service_model.dart';
import 'package:untitled1/features/services/data/models/workshop_availability_model.dart';
import 'package:untitled1/features/services/data/repositories/schedule_service_repository.dart';

part 'schedule_service_event.dart';
part 'schedule_service_state.dart';

class ScheduleServiceBloc
    extends Bloc<ScheduleServiceEvent, ScheduleServiceState> {
  final ScheduleServiceRepository repository;

  ScheduleServiceBloc(this.repository) : super(ScheduleServiceInitial()) {
    on<LoadScheduleServiceEvent>(_onLoad);
    on<SelectScheduleDateEvent>(_onSelectDate);
    on<SelectScheduleTimeSlotEvent>(_onSelectTimeSlot);
    on<ChangeScheduleMonthEvent>(_onChangeMonth);
    on<UpdateScheduleNotesEvent>(_onUpdateNotes);
  }

  Future<void> _onLoad(
    LoadScheduleServiceEvent event,
    Emitter<ScheduleServiceState> emit,
  ) async {
    emit(ScheduleServiceLoading());
    final result = await repository.getScheduleService(
      serviceId: event.serviceId,
      businessId: event.businessId,
      title: event.serviceName,
      subtitle: event.serviceSubtitle,
    );
    result.fold(
      (failure) =>
          emit(ScheduleServiceError(message: _mapFailureToMessage(failure))),
      (data) {
        final now = DateTime.now();
        final selectedDate = _resolveInitialDate(data);
        final defaultSlotId = selectedDate != null
            ? _pickDefaultSlotIdForDate(data, selectedDate)
            : null;

        emit(
          ScheduleServiceLoaded(
            service: data,
            selectedDate: selectedDate,
            selectedTimeSlotId: defaultSlotId,
            viewYear: (selectedDate ?? now).year,
            viewMonth: (selectedDate ?? now).month,
          ),
        );
      },
    );
  }

  void _onSelectDate(
    SelectScheduleDateEvent event,
    Emitter<ScheduleServiceState> emit,
  ) {
    final current = state;
    if (current is! ScheduleServiceLoaded) return;
    if (!event.day.isSelectable) return;

    if (!event.day.isCurrentMonth) {
      final next = current.copyWith(
        viewYear: event.day.date.year,
        viewMonth: event.day.date.month,
        selectedDate: event.day.date,
        clearSelectedTimeSlot: true,
      );
      emit(
        next.copyWith(
          selectedTimeSlotId: _pickDefaultSlotIdForDate(
            current.service,
            event.day.date,
          ),
        ),
      );
      return;
    }

    final next = current.copyWith(
      selectedDate: event.day.date,
      clearSelectedTimeSlot: true,
    );
    emit(
      next.copyWith(
        selectedTimeSlotId: _pickDefaultSlotIdForDate(
          current.service,
          event.day.date,
        ),
      ),
    );
  }

  void _onSelectTimeSlot(
    SelectScheduleTimeSlotEvent event,
    Emitter<ScheduleServiceState> emit,
  ) {
    final current = state;
    if (current is! ScheduleServiceLoaded) return;

    final date = current.selectedDate;
    if (date == null) return;

    final parsed = current.timeAvailability.parseSlotId(event.timeSlotId);
    if (parsed == null) return;

    if (!current.timeAvailability.isTimeSelectable(
      forDate: date,
      hour: parsed.$1,
      minute: parsed.$2,
    )) {
      return;
    }

    emit(current.copyWith(selectedTimeSlotId: event.timeSlotId));
  }

  void _onChangeMonth(
    ChangeScheduleMonthEvent event,
    Emitter<ScheduleServiceState> emit,
  ) {
    final current = state;
    if (current is! ScheduleServiceLoaded) return;
    final anchor = DateTime(current.viewYear, current.viewMonth + event.delta);
    emit(current.copyWith(viewYear: anchor.year, viewMonth: anchor.month));
  }

  void _onUpdateNotes(
    UpdateScheduleNotesEvent event,
    Emitter<ScheduleServiceState> emit,
  ) {
    final current = state;
    if (current is! ScheduleServiceLoaded) return;
    emit(current.copyWith(notes: event.value));
  }

  DateTime? _resolveInitialDate(ScheduleServiceModel data) {
    final availability = data.availability;
    if (availability != null) {
      return availability.findFirstAvailableDate();
    }
    return DateTime.now();
  }

  String? _pickDefaultSlotIdForDate(
    ScheduleServiceModel data,
    DateTime date,
  ) {
    final availability = data.availability ?? defaultScheduleAvailability();
    final first = availability.firstSelectableTime(date);
    if (first == null) return null;
    return availability.slotIdFor(hour: first.$1, minute: first.$2);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (OfflineFailure):
        return 'No internet connection';
      case const (ServerFailure):
        return (failure as ServerFailure).message;
      default:
        return 'Unexpected error occurred';
    }
  }
}
