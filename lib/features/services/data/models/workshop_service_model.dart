class WorkshopServiceModel {
  final String id;
  final String businessId;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final int estimatedDurationMinutes;
  final String? imageUrl;
  final bool isAvailable;

  const WorkshopServiceModel({
    required this.id,
    required this.businessId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.estimatedDurationMinutes,
    this.imageUrl,
    required this.isAvailable,
  });
}
