import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/services/data/model/service_request_response_model.dart';

void main() {
  test('parseServiceRequest maps service location and schedule fields', () {
    final request = parseServiceRequest({
      'id': 9,
      'order_code': 'SR-000009',
      'business_id': 3,
      'status': 'pending_approval',
      'total_amount': '150.00',
      'customer_name': 'Jane Doe',
      'service_location_full_name': 'Jane Doe',
      'service_location_city': 'Palo Alto',
      'service_location_street': '123 Solar Way',
      'service_location_building': '5',
      'service_location_floor': '2',
      'service_date': '2026-03-15',
      'service_time': '09:00:00',
      'service_note': 'Please call on arrival',
      'created_at': '2026-03-10T08:00:00.000Z',
      'item': {'name': 'Panel Cleaning'},
    });

    expect(request.serviceName, 'Panel Cleaning');
    expect(request.locationCity, 'Palo Alto');
    expect(request.serviceDate, '2026-03-15');
    expect(request.formattedAddress, contains('Palo Alto'));
    expect(request.toBookingConfirmation().statusLabel, 'PENDING APPROVAL');
  });
}
