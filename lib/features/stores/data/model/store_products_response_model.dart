import '../models/store_product_model.dart';

class StoreProductApiModel {
  final int id;
  final int businessId;
  final int categoryId;
  final String name;
  final String description;
  final String price;
  final int quantity;
  final List<String> images;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoreProductApiModel({
    required this.id,
    required this.businessId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.images,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoreProductApiModel.fromJson(Map<String, dynamic> json) {
    final imageItems = json['images'] as List<dynamic>? ?? [];
    return StoreProductApiModel(
      id: json['id'] as int,
      businessId: json['business_id'] as int,
      categoryId: json['category_id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price']?.toString() ?? '0',
      quantity: json['quantity'] as int? ?? 0,
      images: imageItems.map((item) => item.toString()).toList(),
      isAvailable: json['is_available'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  StoreProductModel toStoreProductModel() {
    return StoreProductModel(
      id: id.toString(),
      businessId: businessId.toString(),
      categoryId: categoryId,
      name: name,
      description: description,
      price: _parsePrice(price),
      quantity: quantity,
      imageUrl: images.isNotEmpty ? images.first : null,
      isAvailable: isAvailable,
      imagePlaceholderColorValue: _placeholderColor(id),
    );
  }
}

class StoreProductsResponseModel {
  final List<StoreProductApiModel> products;

  StoreProductsResponseModel({required this.products});

  factory StoreProductsResponseModel.fromJson(Map<String, dynamic> json) {
    final items = json['products'] as List<dynamic>? ?? [];
    return StoreProductsResponseModel(
      products: items
          .map(
            (item) =>
                StoreProductApiModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  List<StoreProductModel> toStoreProductModels() {
    return products.map((product) => product.toStoreProductModel()).toList();
  }
}

double _parsePrice(String raw) {
  final normalized = raw.replaceAll('+', '').trim();
  return double.tryParse(normalized) ?? 0;
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
