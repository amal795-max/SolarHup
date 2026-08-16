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
        final slots = selectedDate != null
            ? _timeSlotsFor(data, selectedDate)
            : const <ServiceTimeSlotModel>[];

        emit(
          ScheduleServiceLoaded(
            service: data,
            selectedDate: selectedDate,
            selectedTimeSlotId: _pickDefaultSlotId(slots),
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
        next.copyWith(selectedTimeSlotId: _pickDefaultSlotId(next.timeSlots)),
      );
      return;
    }

    final next = current.copyWith(
      selectedDate: event.day.date,
      clearSelectedTimeSlot: true,
    );
    emit(next.copyWith(selectedTimeSlotId: _pickDefaultSlotId(next.timeSlots)));
  }

  void _onSelectTimeSlot(
    SelectScheduleTimeSlotEvent event,
    Emitter<ScheduleServiceState> emit,
  ) {
    final current = state;
    if (current is! ScheduleServiceLoaded) return;
    ServiceTimeSlotModel? slot;
    for (final candidate in current.timeSlots) {
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

  List<ServiceTimeSlotModel> _timeSlotsFor(
    ScheduleServiceModel data,
    DateTime date,
  ) {
    final availability = data.availability;
    if (availability != null) {
      if (!availability.isDateSelectable(date)) return const [];
      return availability.buildTimeSlots(forDate: date);
    }
    return defaultScheduleTimeSlots();
  }

  String? _pickDefaultSlotId(List<ServiceTimeSlotModel> slots) {
    if (slots.isEmpty) return null;
    for (final slot in slots) {
      if (slot.isAvailable) return slot.id;
    }
    return slots.first.id;
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
