part of 'booking_confirmation_bloc.dart';

sealed class BookingConfirmationEvent extends Equatable {
  const BookingConfirmationEvent();

  @override
  List<Object?> get props => [];
}

final class LoadBookingConfirmationEvent extends BookingConfirmationEvent {
  final String serviceId;

  const LoadBookingConfirmationEvent(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}

final class DownloadBookingReceiptEvent extends BookingConfirmationEvent {
  final String bookingId;

  const DownloadBookingReceiptEvent(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}
