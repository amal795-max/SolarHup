import '../model/workshop_list_response_model.dart';

class WorkshopDetailModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String phone;
  final String region;
  final String? logoUrl;
  final String? coverImageUrl;
  final int imagePlaceholderColorValue;

  const WorkshopDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.phone,
    required this.region,
    required this.logoUrl,
    required this.coverImageUrl,
    required this.imagePlaceholderColorValue,
  });

  factory WorkshopDetailModel.fromApi(WorkshopApiModel api) {
    return WorkshopDetailModel(
      id: api.id.toString(),
      name: api.name,
      description: api.description,
      location: api.address.isNotEmpty ? api.address : api.region,
      phone: api.phone,
      region: api.region,
      logoUrl: api.logo,
      coverImageUrl: api.coverImage,
      imagePlaceholderColorValue: _placeholderColor(api.id),
    );
  }
}

int _placeholderColor(int id) {
  const palette = [
    0xFF0A2A43,
    0xFF8B6200,
    0xFF1A5C2A,
    0xFF0D2137,
    0xFF1A3A5C,
  ];
  return palette[id.abs() % palette.length];
}
