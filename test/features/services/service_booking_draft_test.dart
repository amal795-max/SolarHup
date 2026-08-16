import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/services/data/models/service_booking_draft.dart';

void main() {
  test('ServiceBookingDraft builds service request payload', () {
    final draft = ServiceBookingDraft(
      serviceId: 12,
      serviceName: 'Panel Cleaning',
      servicePrice: 120,
      selectedDate: DateTime(2026, 3, 15),
      selectedTimeSlotId: '09-00',
      selectedTimeLabel: '09:00 AM',
      fullName: 'Jane Doe',
      street: '123 Solar Way',
      city: 'Palo Alto',
      building: '5',
      floor: '2',
      note: 'Gate code 1234',
    );

    expect(
      draft.toPayload().toJson(),
      {
        'service_id': 12,
        'full_name': 'Jane Doe',
        'city': 'Palo Alto',
        'street': '123 Solar Way',
        'building': '5',
        'date': '2026-03-15',
        'time': '09:00:00',
        'floor': '2',
        'note': 'Gate code 1234',
      },
    );
  test('ServiceBookingDraft builds service request payload with coupon', () {
    final draft = ServiceBookingDraft(
      serviceId: 12,
      serviceName: 'Panel Cleaning',
      servicePrice: 90,
      selectedDate: DateTime(2026, 3, 15),
      selectedTimeSlotId: '09-00',
      fullName: 'Jane Doe',
      street: '123 Solar Way',
      city: 'Palo Alto',
      building: '5',
      couponCode: 'SAVE10',
    );

    expect(
      draft.toPayload().toJson(),
      {
        'service_id': 12,
        'full_name': 'Jane Doe',
        'city': 'Palo Alto',
        'street': '123 Solar Way',
        'building': '5',
        'date': '2026-03-15',
        'time': '09:00:00',
        'coupon_code': 'SAVE10',
      },
    );
  });
}
