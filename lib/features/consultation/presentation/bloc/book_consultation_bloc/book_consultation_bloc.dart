import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/consultation/data/models/consultation_attachment_model.dart';
import 'package:untitled1/features/consultation/data/models/consultation_booking_model.dart';
import 'package:untitled1/features/consultation/data/repositories/consultation_repository.dart';

part 'book_consultation_event.dart';
part 'book_consultation_state.dart';

class BookConsultationBloc
    extends Bloc<BookConsultationEvent, BookConsultationState> {
  final ConsultationRepository repository;

  BookConsultationBloc(this.repository) : super(BookConsultationInitial()) {
    on<LoadBookConsultationEvent>(_onLoad);
    on<SelectExpertEvent>(_onSelectExpert);
    on<SelectConsultationTypeEvent>(_onSelectType);
    on<SelectConsultationDateEvent>(_onSelectDate);
    on<SelectTimeSlotEvent>(_onSelectTimeSlot);
    on<PreviousWeekEvent>(_onPreviousWeek);
    on<NextWeekEvent>(_onNextWeek);
    on<UpdateFullNameEvent>(_onUpdateFullName);
    on<UpdatePhoneEvent>(_onUpdatePhone);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<UpdateNotesEvent>(_onUpdateNotes);
    on<AddAttachmentEvent>(_onAddAttachment);
    on<RemoveAttachmentEvent>(_onRemoveAttachment);
    on<ConfirmBookingEvent>(_onConfirmBooking);
  }

  Future<void> _onLoad(
    LoadBookConsultationEvent event,
    Emitter<BookConsultationState> emit,
  ) async {
    emit(BookConsultationLoading());

    final result = await repository.getBookingData(weekOffset: event.weekOffset);
    result.fold(
      (failure) =>
          emit(BookConsultationError(message: _mapFailureToMessage(failure))),
      (data) => emit(
        BookConsultationLoaded(
          data: data,
          selectedExpertId: data.defaultSelectedExpertId,
          selectedTypeId: data.defaultSelectedTypeId,
          selectedDate: data.defaultSelectedDate,
          selectedTimeSlotId: data.defaultSelectedTimeSlotId,
          weekOffset: event.weekOffset,
          fullName: data.defaultFullName,
          phone: data.defaultPhone,
          address: data.defaultAddress,
          notes: '',
          attachments: const [],
        ),
      ),
    );
  }

  Future<void> _reloadWeek(
    int weekOffset,
    BookConsultationLoaded current,
    Emitter<BookConsultationState> emit,
  ) async {
    emit(BookConsultationLoading());
    final result = await repository.getBookingData(weekOffset: weekOffset);
    result.fold(
      (failure) =>
          emit(BookConsultationError(message: _mapFailureToMessage(failure))),
      (data) => emit(
        current.copyWith(
          data: data,
          weekOffset: weekOffset,
          selectedDate: data.calendarDays.first.date,
        ),
      ),
    );
  }

  void _onSelectExpert(
    SelectExpertEvent event,
    Emitter<BookConsultationState> emit,
  ) {
    final current = state;
    if (current is! BookConsultationLoaded) return;
    emit(current.copyWith(selectedExpertId: event.expertId));
  }

  void _onSelectType(
    SelectConsultationTypeEvent event,
    Emitter<BookConsultationState> emit,
  ) {
    final current = state;
    if (current is! BookConsultationLoaded) return;
    emit(current.copyWith(selectedTypeId: event.typeId));
  }

  void _onSelectDate(
    SelectConsultationDateEvent event,
    Emitter<BookConsultationState> emit,
  ) {
    final current = state;
    if (current is! BookConsultationLoaded) return;
    emit(current.copyWith(selectedDate: event.date));
  }

  void _onSelectTimeSlot(
    SelectTimeSlotEvent event,
    Emitter<BookConsultationState> emit,
  ) {
    final current = state;
    if (current is! BookConsultationLoaded) return;
    emit(current.copyWith(selectedTimeSlotId: event.timeSlotId));
  }

  Future<void> _onPreviousWeek(
    PreviousWeekEvent event,
    Emitter<BookConsultationState> emit,
  ) async {
    final current = state;
    if (current is! BookConsultationLoaded) return;
    await _reloadWeek(current.weekOffset - 1, current, emit);
  }

  Future<void> _onNextWeek(
    NextWeekEvent event,
    Emitter<BookConsultationState> emit,
  ) async {
    final current = state;
    if (current is! BookConsultationLoaded) return;
    await _reloadWeek(current.weekOffset + 1, current, emit);
  }

  void _onUpdateFullName(
    UpdateFullNameEvent event,
    Emitter<BookConsultationState> emit,
  ) {
    final current = state;
    if (current is! BookConsultationLoaded) return;
    emit(current.copyWith(fullName: event.value));
  }

  void _onUpdatePhone(
    UpdatePhoneEvent event,
    Emitter<BookConsultationState> emit,
  ) {
    final current = state;
    if (current is! BookConsultationLoaded) return;
    emit(current.copyWith(phone: event.value));
  }

  void _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<BookConsultationState> emit,
  ) {
    final current = state;
    if (current is! BookConsultationLoaded) return;
    emit(current.copyWith(address: event.value));
  }

  void _onUpdateNotes(
    UpdateNotesEvent event,
    Emitter<BookConsultationState> emit,
  ) {
    final current = state;
    if (current is! BookConsultationLoaded) return;
    emit(current.copyWith(notes: event.value));
  }

  void _onAddAttachment(
    AddAttachmentEvent event,
    Emitter<BookConsultationState> emit,
  ) {
    final current = state;
    if (current is! BookConsultationLoaded) return;
    emit(
      current.copyWith(
        attachments: [...current.attachments, event.attachment],
      ),
    );
  }

  void _onRemoveAttachment(
    RemoveAttachmentEvent event,
    Emitter<BookConsultationState> emit,
  ) {
    final current = state;
    if (current is! BookConsultationLoaded) return;
    emit(
      current.copyWith(
        attachments: current.attachments
            .where((a) => a.id != event.attachmentId)
            .toList(),
      ),
    );
  }

  void _onConfirmBooking(
    ConfirmBookingEvent event,
    Emitter<BookConsultationState> emit,
  ) {
    // TODO: Submit booking to API
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
