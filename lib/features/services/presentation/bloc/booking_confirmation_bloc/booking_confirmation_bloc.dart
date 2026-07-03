import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/services/data/models/booking_confirmation_model.dart';
import 'package:untitled1/features/services/data/repositories/booking_confirmation_repository.dart';

part 'booking_confirmation_event.dart';
part 'booking_confirmation_state.dart';

class BookingConfirmationBloc
    extends Bloc<BookingConfirmationEvent, BookingConfirmationState> {
  final BookingConfirmationRepository repository;

  BookingConfirmationBloc(this.repository)
      : super(BookingConfirmationInitial()) {
    on<LoadBookingConfirmationEvent>(_onLoad);
    on<DownloadBookingReceiptEvent>(_onDownloadReceipt);
  }

  Future<void> _onLoad(
    LoadBookingConfirmationEvent event,
    Emitter<BookingConfirmationState> emit,
  ) async {
    emit(BookingConfirmationLoading());
    final result = await repository.getBookingConfirmation(event.serviceId);
    result.fold(
      (failure) => emit(
        BookingConfirmationError(message: _mapFailureToMessage(failure)),
      ),
      (data) => emit(BookingConfirmationLoaded(booking: data)),
    );
  }

  Future<void> _onDownloadReceipt(
    DownloadBookingReceiptEvent event,
    Emitter<BookingConfirmationState> emit,
  ) async {
    final current = state;
    if (current is! BookingConfirmationLoaded) return;

    emit(current.copyWith(isDownloadingReceipt: true));
    final result = await repository.downloadReceipt(event.bookingId);
    result.fold(
      (failure) => emit(
        current.copyWith(
          isDownloadingReceipt: false,
          receiptMessage: _mapFailureToMessage(failure),
        ),
      ),
      (_) => emit(
        current.copyWith(
          isDownloadingReceipt: false,
          receiptMessage: 'Receipt downloaded',
        ),
      ),
    );
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
