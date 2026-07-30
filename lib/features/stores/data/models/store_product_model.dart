class StoreProductModel {
  final String id;
  final String businessId;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String? imageUrl;
  final bool isAvailable;
  final int imagePlaceholderColorValue;

  const StoreProductModel({
    required this.id,
    required this.businessId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.isAvailable,
    required this.imagePlaceholderColorValue,
  });
}
