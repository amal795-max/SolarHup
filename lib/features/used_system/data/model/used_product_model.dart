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
}
