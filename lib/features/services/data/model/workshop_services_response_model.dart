import 'package:untitled1/core/api/api_response_utils.dart';
import '../models/workshop_service_model.dart';

class WorkshopServiceApiModel {
  final int id;
  final int businessId;
  final int categoryId;
  final String name;
  final String description;
  final String price;
  final int estimatedDuration;
  final List<String> images;
  final bool isAvailable;

  WorkshopServiceApiModel({
    required this.id,
    required this.businessId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.estimatedDuration,
    required this.images,
    required this.isAvailable,
  });

  factory WorkshopServiceApiModel.fromJson(Map<String, dynamic> json) {
    final imageItems = json['images'] as List<dynamic>? ?? [];
    return WorkshopServiceApiModel(
      id: json['id'] as int,
      businessId: json['business_id'] as int,
      categoryId: json['category_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'])?.toString() ?? '0',
      estimatedDuration: json['estimated_duration'] as int? ?? 0,
      images: imageItems.map((item) => item.toString()).toList(),
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  WorkshopServiceModel toWorkshopServiceModel() {
    return WorkshopServiceModel(
      id: id.toString(),
      businessId: businessId.toString(),
      categoryId: categoryId,
      name: name,
      description: description,
      price: double.tryParse(price.replaceAll('+', '').trim()) ?? 0,
      estimatedDurationMinutes: estimatedDuration,
      imageUrl: images.isNotEmpty ? images.first : null,
      isAvailable: isAvailable,
    );
  }
}

class WorkshopServicesResponseModel {
  final List<WorkshopServiceApiModel> services;

  WorkshopServicesResponseModel({required this.services});

  factory WorkshopServicesResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = unwrapApiPayload(json);
    final items = payload['services'] as List<dynamic>? ??
        json['services'] as List<dynamic>? ??
        [];
    return WorkshopServicesResponseModel(
      services: items
          .map(
            (item) =>
                WorkshopServiceApiModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  List<WorkshopServiceModel> toWorkshopServiceModels() {
    return services.map((service) => service.toWorkshopServiceModel()).toList();
  }
}
