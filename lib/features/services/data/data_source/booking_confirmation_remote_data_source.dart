import '../models/booking_confirmation_model.dart';

abstract class BookingConfirmationRemoteDataSource {
  Future<BookingConfirmationModel> getBookingConfirmation(String serviceId);
  Future<void> downloadReceipt(String bookingId);
}

class BookingConfirmationRemoteDataSourceImpl
    implements BookingConfirmationRemoteDataSource {
  const BookingConfirmationRemoteDataSourceImpl();

  static const _byService = <String, BookingConfirmationModel>{
    'svc-1': BookingConfirmationModel(
      serviceId: 'svc-1',
      bookingId: '#SH-88291',
      serviceType: 'Installation',
      dateTimeLabel: 'Tuesday, Oct 24 • 09:00 AM',
      technician: BookingTechnicianModel(
        name: 'Alex Henderson',
        avatarColorValue: 0xFF5B7A99,
      ),
      address: '1248 Oakwood Avenue, Los Angeles, CA 90024',
      receiptUrl: 'https://example.com/receipts/SH-88291.pdf',
    ),
    'svc-2': BookingConfirmationModel(
      serviceId: 'svc-2',
      bookingId: '#SH-88292',
      serviceType: 'Maintenance',
      dateTimeLabel: 'Wednesday, Oct 25 • 02:00 PM',
      technician: BookingTechnicianModel(
        name: 'Alex Henderson',
        avatarColorValue: 0xFF5B7A99,
      ),
      address: '1248 Oakwood Avenue, Los Angeles, CA 90024',
      receiptUrl: 'https://example.com/receipts/SH-88292.pdf',
    ),
    'svc-featured-1': BookingConfirmationModel(
      serviceId: 'svc-featured-1',
      bookingId: '#SH-88293',
      serviceType: 'Installation',
      dateTimeLabel: 'Tuesday, Oct 24 • 09:00 AM',
      technician: BookingTechnicianModel(
        name: 'Alex Henderson',
        avatarColorValue: 0xFF5B7A99,
      ),
      address: '1248 Oakwood Avenue, Los Angeles, CA 90024',
      receiptUrl: 'https://example.com/receipts/SH-88293.pdf',
    ),
  };

  static const _fallback = BookingConfirmationModel(
    serviceId: 'svc-default',
    bookingId: '#SH-88291',
    serviceType: 'Installation',
    dateTimeLabel: 'Tuesday, Oct 24 • 09:00 AM',
    technician: BookingTechnicianModel(
      name: 'Alex Henderson',
      avatarColorValue: 0xFF5B7A99,
    ),
    address: '1248 Oakwood Avenue, Los Angeles, CA 90024',
    receiptUrl: 'https://example.com/receipts/SH-88291.pdf',
  );

  @override
  Future<BookingConfirmationModel> getBookingConfirmation(
    String serviceId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _byService[serviceId] ?? _fallback;
  }

  @override
  Future<void> downloadReceipt(String bookingId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
