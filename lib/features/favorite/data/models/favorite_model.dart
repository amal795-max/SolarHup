class FavoriteModel {
  final int id;
  final String itemType;
  final int itemId;
  final int? businessId;
  final int? workshopId;
  final String? workshopName;
  final bool isAvailable;
  final String? name;
  final String? price;
  final String? image;

  FavoriteModel({
    required this.id,
    required this.itemType,
    required this.itemId,
    this.businessId,
    this.workshopId,
    this.workshopName,
    required this.isAvailable,
    this.name,
    this.price,
    this.image,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    final itemType = json['item_type']?.toString() ?? '';
    final workshopId = _parseOptionalInt(
      json['workshop_id'] ?? json['business_id'],
    );

    return FavoriteModel(
      id: _parseInt(json['id']),
      itemType: itemType,
      itemId: _parseInt(json['item_id']),
      businessId: _parseOptionalInt(json['business_id'] ?? json['store_id']),
      workshopId: workshopId,
      workshopName: json['workshop_name']?.toString(),
      name: json['name']?.toString(),
      price: json['price']?.toString(),
      image: json['image']?.toString(),
      isAvailable: json['is_available'] == true,
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _parseOptionalInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}
