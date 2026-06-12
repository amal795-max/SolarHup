part of 'book_consultation_bloc.dart';

@immutable
sealed class BookConsultationEvent extends Equatable {
  const BookConsultationEvent();

  @override
  List<Object?> get props => [];
}

final class LoadBookConsultationEvent extends BookConsultationEvent {
  final int weekOffset;

  const LoadBookConsultationEvent({this.weekOffset = 0});

  @override
  List<Object?> get props => [weekOffset];
}

final class SelectExpertEvent extends BookConsultationEvent {
  final String expertId;

  const SelectExpertEvent(this.expertId);

  @override
  List<Object?> get props => [expertId];
}

final class SelectConsultationTypeEvent extends BookConsultationEvent {
  final String typeId;

  const SelectConsultationTypeEvent(this.typeId);

  @override
  List<Object?> get props => [typeId];
}

final class SelectConsultationDateEvent extends BookConsultationEvent {
  final DateTime date;

  const SelectConsultationDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

final class SelectTimeSlotEvent extends BookConsultationEvent {
  final String timeSlotId;

  const SelectTimeSlotEvent(this.timeSlotId);

  @override
  List<Object?> get props => [timeSlotId];
}

final class PreviousWeekEvent extends BookConsultationEvent {
  const PreviousWeekEvent();
}

final class NextWeekEvent extends BookConsultationEvent {
  const NextWeekEvent();
}

final class UpdateFullNameEvent extends BookConsultationEvent {
  final String value;

  const UpdateFullNameEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class UpdatePhoneEvent extends BookConsultationEvent {
  final String value;

  const UpdatePhoneEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class UpdateAddressEvent extends BookConsultationEvent {
  final String value;

  const UpdateAddressEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class UpdateNotesEvent extends BookConsultationEvent {
  final String value;

  const UpdateNotesEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class ConfirmBookingEvent extends BookConsultationEvent {
  const ConfirmBookingEvent();
}

final class AddAttachmentEvent extends BookConsultationEvent {
  final ConsultationAttachmentModel attachment;

  const AddAttachmentEvent(this.attachment);

  @override
  List<Object?> get props => [attachment];
}

final class RemoveAttachmentEvent extends BookConsultationEvent {
  final String attachmentId;

  const RemoveAttachmentEvent(this.attachmentId);

  @override
  List<Object?> get props => [attachmentId];
}
