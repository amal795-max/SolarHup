import 'package:untitled1/core/api/api_response_utils.dart';
import 'package:untitled1/features/services/data/models/workshop_model.dart';

class WorkshopApiModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String region;
  final String? logo;
  final String? coverImage;

  WorkshopApiModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.region,
    required this.logo,
    required this.coverImage,
  });

  factory WorkshopApiModel.fromJson(Map<String, dynamic> json) {
    return WorkshopApiModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      region: json['region'] as String? ?? '',
      logo: json['logo'] as String?,
      coverImage: json['cover_image'] as String?,
    );
  }

  WorkshopModel toWorkshopModel() {
    return WorkshopModel(
      id: id.toString(),
      name: name,
      location: address.isNotEmpty ? address : region,
      logoUrl: logo,
      coverImageUrl: coverImage,
      iconColorValue: _placeholderColor(id),
    );
  }
}

class WorkshopListResponseModel {
  final List<WorkshopApiModel> workshops;

  WorkshopListResponseModel({required this.workshops});

  factory WorkshopListResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = unwrapApiPayload(json);
    final items = payload['workshops'] as List<dynamic>? ??
        json['workshops'] as List<dynamic>? ??
        [];
    return WorkshopListResponseModel(
      workshops: items
          .map(
            (item) => WorkshopApiModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  List<WorkshopModel> toWorkshopModels() {
    return workshops.map((workshop) => workshop.toWorkshopModel()).toList();
  }
}

int _placeholderColor(int id) {
  const palette = [
    0xFF1A3A5C,
    0xFF2D2D2D,
    0xFF1C3A2E,
    0xFF0A2A43,
    0xFF8B6200,
    0xFF1A5C2A,
    0xFF0D2137,
  ];
  return palette[id.abs() % palette.length];
}
