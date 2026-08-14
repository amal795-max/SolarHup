import '../models/service_request_model.dart';

class ServiceRequestResponseModel {
  final ServiceRequestModel request;

  ServiceRequestResponseModel({required this.request});

  factory ServiceRequestResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final item = payload['request'] is Map<String, dynamic>
        ? payload['request'] as Map<String, dynamic>
        : payload;

    return ServiceRequestResponseModel(
      request: parseServiceRequest(item),
    );
  }
}

class ServiceRequestListResponseModel {
  final List<ServiceRequestModel> requests;

  ServiceRequestListResponseModel({required this.requests});

  factory ServiceRequestListResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final items = payload['requests'] as List<dynamic>? ??
        json['requests'] as List<dynamic>? ??
        [];
    return ServiceRequestListResponseModel(
      requests: items
          .whereType<Map<String, dynamic>>()
          .map(parseServiceRequest)
          .toList(),
    );
  }
}

ServiceRequestModel parseServiceRequest(Map<String, dynamic> item) {
  final nestedItem = item['item'] as Map<String, dynamic>?;

  return ServiceRequestModel(
    id: item['id'] as int,
    orderCode: item['order_code'] as String? ?? '',
    businessId: item['business_id'] as int? ?? 0,
    status: item['status'] as String? ?? 'pending_approval',
    totalAmount: item['total_amount']?.toString() ?? '0',
    serviceName: nestedItem?['name'] as String? ?? '',
    createdAt: DateTime.tryParse(item['created_at'] as String? ?? '') ??
        DateTime.now(),
    customerName: item['customer_name'] as String?,
    locationFullName: item['service_location_full_name'] as String?,
    locationCity: item['service_location_city'] as String?,
    locationStreet: item['service_location_street'] as String?,
    locationBuilding: item['service_location_building'] as String?,
    locationFloor: item['service_location_floor'] as String?,
    serviceDate: item['service_date'] as String?,
    serviceTime: item['service_time'] as String?,
    serviceNote: item['service_note'] as String?,
  );
}
