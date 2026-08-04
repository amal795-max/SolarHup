class UsedProductModel {
  final int id;
  final int sellerId;
  final String sellerPhone;
  final String name;
  final String description;
  final String category;
  final String condition;
  final String price;
  final String region;
  final String status;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  UsedProductModel({
    required this.id,
    required this.sellerId,
    required this.sellerPhone,
    required this.name,
    required this.description,
    required this.category,
    required this.condition,
    required this.price,
    required this.region,
    required this.status,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UsedProductModel.fromJson(Map<String, dynamic> json) {
    return UsedProductModel(
      id: json['id'],
      sellerId: json['seller_id'],
      sellerPhone: json['seller_phone'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      condition: json['condition'],
      price: json['price'],
      region: json['region'],
      status: json['status'],
      images: List<String>.from(json['images']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  UsedProductModel copyWith({
    int? id,
    int? sellerId,
    String? sellerPhone,
    String? name,
    String? description,
    String? category,
    String? condition,
    String? price,
    String? region,
    String? status,
    List<String>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UsedProductModel(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      sellerPhone: sellerPhone ?? this.sellerPhone,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      price: price ?? this.price,
      region: region ?? this.region,
      status: status ?? this.status,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
