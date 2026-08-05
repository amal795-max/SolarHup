class FavoriteModel {
  final int id;
  final String itemType;
  final int itemId;
  final bool isAvailable;
  final String? name;
  final String? price;
  final String? image;

  FavoriteModel({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.isAvailable,
    this.name,
    this.price,
    this.image,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      itemType: json['item_type'],
      itemId: json['item_id'],
      name: json['name'],
      price: json['price']?.toString(),
      image: json['image'],
      isAvailable: json['is_available'],
    );
  }
}
