import 'package:untitled1/features/home/data/models/product_model.dart';

class TopSellingProductModel {
  final int id;
  final int businessId;
  final int categoryId;
  final String name;
  final String description;
  final String price;
  final int quantity;
  final List<String> images;
  final bool isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TopSellingProductModel({
    required this.id,
    required this.businessId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.images,
    required this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  factory TopSellingProductModel.fromJson(Map<String, dynamic> json) {
    final imageItems = json['images'] as List<dynamic>? ?? const [];
    return TopSellingProductModel(
      id: json['id'] as int,
      businessId: json['business_id'] as int,
      categoryId: json['category_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['retail_price'] ?? json['price'])?.toString() ?? '0',
      quantity: json['quantity'] as int? ?? json['stock_quantity'] as int? ?? 0,
      images: imageItems.map((item) => item.toString()).toList(),
      isAvailable: json['is_available'] as bool? ?? true,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  ProductModel toHomeProduct() {
    return ProductModel(
      id: id.toString(),
      businessId: businessId,
      name: name,
      price: double.tryParse(price) ?? 0,
      metaText: isAvailable ? null : 'Unavailable',
      imageUrl: images.isNotEmpty ? images.first : null,
      imagePlaceholderColorValue: _placeholderColor(id),
      iconType: _iconTypeForCategoryId(categoryId),
    );
  }

  static List<TopSellingProductModel> listFromResponse(dynamic data) {
    if (data is! Map<String, dynamic>) return const [];

    final products = data['products'];
    if (products is! List) return const [];

    return products
        .whereType<Map<String, dynamic>>()
        .map(TopSellingProductModel.fromJson)
        .toList();
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  static int _placeholderColor(int seed) {
    const palette = [
      0xFF0A2A43,
      0xFF1A3A5C,
      0xFF4A7B9D,
      0xFF2E5E4E,
      0xFF5C4033,
    ];
    return palette[seed.abs() % palette.length];
  }

  static String _iconTypeForCategoryId(int categoryId) {
    return switch (categoryId % 3) {
      1 => 'inverter',
      2 => 'battery',
      _ => 'solar',
    };
  }
}
