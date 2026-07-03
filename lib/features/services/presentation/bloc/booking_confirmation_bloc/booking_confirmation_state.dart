part of 'booking_confirmation_bloc.dart';

sealed class BookingConfirmationState extends Equatable {
  const BookingConfirmationState();

  @override
  List<Object?> get props => [];
}

final class BookingConfirmationInitial extends BookingConfirmationState {}

final class BookingConfirmationLoading extends BookingConfirmationState {}

final class BookingConfirmationLoaded extends BookingConfirmationState {
  final BookingConfirmationModel booking;
  final bool isDownloadingReceipt;
  final String? receiptMessage;

  const BookingConfirmationLoaded({
    required this.booking,
    this.isDownloadingReceipt = false,
    this.receiptMessage,
  });

  BookingConfirmationLoaded copyWith({
    BookingConfirmationModel? booking,
    bool? isDownloadingReceipt,
    String? receiptMessage,
  }) {
    return BookingConfirmationLoaded(
      booking: booking ?? this.booking,
      isDownloadingReceipt: isDownloadingReceipt ?? this.isDownloadingReceipt,
      receiptMessage: receiptMessage,
    );
  }

  @override
  List<Object?> get props => [
        booking,
        isDownloadingReceipt,
        receiptMessage,
      ];
}

final class BookingConfirmationError extends BookingConfirmationState {
  final String message;

  const BookingConfirmationError({required this.message});

  @override
  List<Object?> get props => [message];
}
