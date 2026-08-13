import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/features/services/data/model/workshop_list_response_model.dart';
import 'package:untitled1/features/services/data/model/workshop_services_response_model.dart';

void main() {
  test('WorkshopListResponseModel parses GET /workshops', () {
    final workshops = WorkshopListResponseModel.fromJson(const {
      'success': true,
      'data': {
        'workshops': [
          {
            'id': 5,
            'name': 'Solar Fix Workshop',
            'description': 'Repairs and maintenance.',
            'address': 'Damascus, Syria',
            'phone': '+963912345678',
            'region': 'Damascus',
            'logo': 'https://example.com/logo.png',
            'cover_image': 'https://example.com/cover.png',
            'created_at': '2026-07-30T16:05:07.201Z',
          },
        ],
      },
    }).toWorkshopModels();

    expect(workshops, hasLength(1));
    expect(workshops.first.name, 'Solar Fix Workshop');
    expect(workshops.first.logoUrl, 'https://example.com/logo.png');
  });

  test('WorkshopServicesResponseModel parses GET /workshops/{id}/services', () {
    final services = WorkshopServicesResponseModel.fromJson(const {
      'success': true,
      'data': {
        'services': [
          {
            'id': 12,
            'business_id': 5,
            'category_id': 12,
            'name': 'Inverter Repair Visit',
            'description': 'On-site inverter diagnostics.',
            'price': '200.00',
            'estimated_duration': 120,
            'service_type': 'repair',
            'pricing_model': 'fixed',
            'images': ['https://example.com/service.png'],
            'is_available': true,
            'status': 'active',
            'created_at': '2026-07-30T16:16:54.142Z',
            'updated_at': '2026-07-30T16:16:54.142Z',
          },
        ],
      },
    }).toWorkshopServiceModels();

    expect(services, hasLength(1));
    expect(services.first.name, 'Inverter Repair Visit');
    expect(services.first.price, 200);
    expect(services.first.estimatedDurationMinutes, 120);
    expect(services.first.imageUrl, 'https://example.com/service.png');
  });
}
