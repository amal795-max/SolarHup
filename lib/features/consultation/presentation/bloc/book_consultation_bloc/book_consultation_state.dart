part of 'book_consultation_bloc.dart';

@immutable
sealed class BookConsultationState extends Equatable {
  const BookConsultationState();

  @override
  List<Object?> get props => [];
}

final class BookConsultationInitial extends BookConsultationState {}

final class BookConsultationLoading extends BookConsultationState {}

final class BookConsultationLoaded extends BookConsultationState {
  final ConsultationBookingModel data;
  final String selectedExpertId;
  final String selectedTypeId;
  final DateTime selectedDate;
  final String selectedTimeSlotId;
  final int weekOffset;
  final String fullName;
  final String phone;
  final String address;
  final String notes;
  final List<ConsultationAttachmentModel> attachments;

  const BookConsultationLoaded({
    required this.data,
    required this.selectedExpertId,
    required this.selectedTypeId,
    required this.selectedDate,
    required this.selectedTimeSlotId,
    required this.weekOffset,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.notes,
    this.attachments = const [],
  });

  BookConsultationLoaded copyWith({
    ConsultationBookingModel? data,
    String? selectedExpertId,
    String? selectedTypeId,
    DateTime? selectedDate,
    String? selectedTimeSlotId,
    int? weekOffset,
    String? fullName,
    String? phone,
    String? address,
    String? notes,
    List<ConsultationAttachmentModel>? attachments,
  }) {
    return BookConsultationLoaded(
      data: data ?? this.data,
      selectedExpertId: selectedExpertId ?? this.selectedExpertId,
      selectedTypeId: selectedTypeId ?? this.selectedTypeId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlotId: selectedTimeSlotId ?? this.selectedTimeSlotId,
      weekOffset: weekOffset ?? this.weekOffset,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
    );
  }

  @override
  List<Object?> get props => [
        data,
        selectedExpertId,
        selectedTypeId,
        selectedDate,
        selectedTimeSlotId,
        weekOffset,
        fullName,
        phone,
        address,
        notes,
        attachments,
      ];
}

final class BookConsultationError extends BookConsultationState {
  final String message;

  const BookConsultationError({required this.message});

  @override
  List<Object?> get props => [message];
}
