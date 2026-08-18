import '../model/store_list_response_model.dart';

class StoreDetailModel {
  final int id;
  final String name;
  final String description;
  final String location;
  final String phone;
  final String region;
  final String? logoUrl;
  final String? coverImageUrl;
  final int imagePlaceholderColorValue;
  final String iconType;
  final double? latitude;
  final double? longitude;

  const StoreDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.phone,
    required this.region,
    required this.logoUrl,
    required this.coverImageUrl,
    required this.imagePlaceholderColorValue,
    required this.iconType,
    this.latitude,
    this.longitude,
  });

  factory StoreDetailModel.fromApi(StoreApiModel api) {
    return StoreDetailModel(
      id: api.id,
      name: api.name,
      description: api.description,
      location: api.address.isNotEmpty ? api.address : api.region,
      phone: api.phone,
      region: api.region,
      logoUrl: api.logo,
      coverImageUrl: api.coverImage,
      imagePlaceholderColorValue: _placeholderColor(api.id),
      iconType: _iconType(api.id),
      latitude: api.latitude,
      longitude: api.longitude,
    );
  }
}

String _iconType(int id) {
  const types = ['lightning', 'sun', 'eco'];
  return types[id.abs() % types.length];
}

int _placeholderColor(int id) {
  const palette = [
    0xFF0A2A43,
    0xFF8B6200,
    0xFF1A5C2A,
    0xFF0D2137,
    0xFF7A5200,
    0xFF142B1C,
    0xFF1A3A5C,
  ];
  return palette[id.abs() % palette.length];
}
