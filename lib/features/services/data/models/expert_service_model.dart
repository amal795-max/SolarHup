class ExpertServiceModel {
  final String id;
  final String title;
  final double rating;
  final List<String> badges;
  final double price;
  final String durationLabel;
  final String categoryKey;
  final int imagePlaceholderColorValue;
  final String iconType;
  final bool isFeatured;
  final String? description;

  const ExpertServiceModel({
    required this.id,
    required this.title,
    required this.rating,
    required this.badges,
    required this.price,
    required this.durationLabel,
    required this.categoryKey,
    required this.imagePlaceholderColorValue,
    this.iconType = 'maintenance',
    this.isFeatured = false,
    this.description,
  });
}

class ServicesFeedModel {
  final List<ExpertServiceModel> services;
  final ExpertServiceModel? featured;

  const ServicesFeedModel({
    required this.services,
    this.featured,
  });
}
