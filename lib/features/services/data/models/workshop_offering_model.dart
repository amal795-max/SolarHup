class WorkshopOfferingModel {
  final String workshopId;
  final String workshopName;
  final String location;
  final String? logoUrl;
  final String? coverImageUrl;
  final int iconColorValue;
  final String serviceId;
  final String serviceName;
  final String? serviceDescription;
  final double price;
  final int estimatedDurationMinutes;
  final String? imageUrl;
  final bool isAvailable;

  const WorkshopOfferingModel({
    required this.workshopId,
    required this.workshopName,
    required this.location,
    this.logoUrl,
    this.coverImageUrl,
    required this.iconColorValue,
    required this.serviceId,
    required this.serviceName,
    this.serviceDescription,
    required this.price,
    required this.estimatedDurationMinutes,
    this.imageUrl,
    required this.isAvailable,
  });
}
