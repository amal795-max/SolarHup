import 'package:untitled1/core/api/api_response_utils.dart';
import '../models/store_model.dart';

class StoreApiModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String region;
  final String? logo;
  final String? coverImage;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;

  StoreApiModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.region,
    required this.logo,
    required this.coverImage,
    required this.createdAt,
    this.latitude,
    this.longitude,
  });

  factory StoreApiModel.fromJson(Map<String, dynamic> json) {
    return StoreApiModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      region: json['region'] as String? ?? '',
      logo: json['logo'] as String?,
      coverImage: json['cover_image'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      latitude: (json['latitude'] as num?)?.toDouble() ?? (json['lat'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble() ?? (json['lng'] as num?)?.toDouble(),
    );
  }

  StoreModel toStoreModel() {
    final tags = <String>[];
    if (region.isNotEmpty) tags.add(region);
    if (phone.isNotEmpty) tags.add(phone);

    return StoreModel(
      id: id,
      name: name,
      location: address.isNotEmpty ? address : region,
      rating: 0,
      tags: tags,
      iconType: _iconType(id),
      iconColorValue: _placeholderColor(id),
      imagePlaceholderColorValue: _placeholderColor(id),
      logoUrl: logo,
      coverImageUrl: coverImage,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

class StoreListResponseModel {
  final List<StoreApiModel> stores;

  StoreListResponseModel({required this.stores});

  factory StoreListResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = unwrapApiPayload(json);
    final items = payload['stores'] as List<dynamic>? ??
        json['stores'] as List<dynamic>? ??
        [];
    return StoreListResponseModel(
      stores: items
          .map((item) => StoreApiModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  List<StoreModel> toStoreModels() {
    return stores.map((store) => store.toStoreModel()).toList();
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
