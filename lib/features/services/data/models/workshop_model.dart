class WorkshopModel {
  final String id;
  final String name;
  final String location;
  final String? logoUrl;
  final String? coverImageUrl;
  final int iconColorValue;

  const WorkshopModel({
    required this.id,
    required this.name,
    required this.location,
    this.logoUrl,
    this.coverImageUrl,
    required this.iconColorValue,
  });
}
