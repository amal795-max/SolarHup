import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/services/data/models/schedule_service_model.dart';
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
    on<UpdateSchedulePriorityEvent>(_onUpdatePriority);
    on<UpdateSchedulePanelsEvent>(_onUpdatePanels);
    on<UpdateScheduleNotesEvent>(_onUpdateNotes);
  }

  Future<void> _onLoad(
    LoadScheduleServiceEvent event,
    Emitter<ScheduleServiceState> emit,
  ) async {
    emit(ScheduleServiceLoading());
    final result = await repository.getScheduleService(event.serviceId);
    result.fold(
      (failure) =>
          emit(ScheduleServiceError(message: _mapFailureToMessage(failure))),
      (data) => emit(
        ScheduleServiceLoaded(
          service: data,
          selectedDate: data.defaultSelectedDate,
          selectedTimeSlotId: data.defaultSelectedTimeSlotId,
          viewYear: data.calendarYear,
          viewMonth: data.calendarMonth,
        ),
      ),
    );
  }

  void _onSelectDate(
    SelectScheduleDateEvent event,
    Emitter<ScheduleServiceState> emit,
  ) {
    final current = state;
    if (current is! ScheduleServiceLoaded) return;
    if (!event.day.isCurrentMonth) {
      emit(
        current.copyWith(
          viewYear: event.day.date.year,
          viewMonth: event.day.date.month,
          selectedDate: event.day.date,
        ),
      );
      return;
    }
    emit(current.copyWith(selectedDate: event.day.date));
  }

  void _onSelectTimeSlot(
    SelectScheduleTimeSlotEvent event,
    Emitter<ScheduleServiceState> emit,
  ) {
    final current = state;
    if (current is! ScheduleServiceLoaded) return;
    ServiceTimeSlotModel? slot;
    for (final candidate in current.service.timeSlots) {
      if (candidate.id == event.timeSlotId) {
        slot = candidate;
        break;
      }
    }
    if (slot == null || !slot.isAvailable) return;
    emit(current.copyWith(selectedTimeSlotId: event.timeSlotId));
  }

  void _onChangeMonth(
    ChangeScheduleMonthEvent event,
    Emitter<ScheduleServiceState> emit,
  ) {
    final current = state;
    if (current is! ScheduleServiceLoaded) return;
    final anchor = DateTime(current.viewYear, current.viewMonth + event.delta);
    emit(
      current.copyWith(
        viewYear: anchor.year,
        viewMonth: anchor.month,
      ),
    );
  }

  void _onUpdatePriority(
    UpdateSchedulePriorityEvent event,
    Emitter<ScheduleServiceState> emit,
  ) {
    final current = state;
    if (current is! ScheduleServiceLoaded) return;
    emit(current.copyWith(priority: event.value));
  }

  void _onUpdatePanels(
    UpdateSchedulePanelsEvent event,
    Emitter<ScheduleServiceState> emit,
  ) {
    final current = state;
    if (current is! ScheduleServiceLoaded) return;
    emit(current.copyWith(panelsCount: event.value));
  }

  void _onUpdateNotes(
    UpdateScheduleNotesEvent event,
    Emitter<ScheduleServiceState> emit,
  ) {
    final current = state;
    if (current is! ScheduleServiceLoaded) return;
    emit(current.copyWith(notes: event.value));
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
