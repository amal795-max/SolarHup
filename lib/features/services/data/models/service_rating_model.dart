class ServiceRatingTechnicianModel {
  final String name;
  final String role;
  final String? avatarUrl;
  final int avatarColorValue;

  const ServiceRatingTechnicianModel({
    required this.name,
    required this.role,
    this.avatarUrl,
    this.avatarColorValue = 0xFF7592B0,
  });
}

class ServiceRatingPhotoModel {
  final String imageUrl;

  const ServiceRatingPhotoModel({required this.imageUrl});
}

class ServiceRatingModel {
  final String serviceId;
  final String serviceReferenceId;
  final ServiceRatingTechnicianModel technician;
  final String serviceDate;
  final String serviceTime;
  final List<ServiceRatingPhotoModel> existingPhotos;
  final int maxPhotos;
  final int defaultServiceQuality;
  final int defaultTechnicianBehavior;
  final int defaultValueForMoney;

  const ServiceRatingModel({
    required this.serviceId,
    required this.serviceReferenceId,
    required this.technician,
    required this.serviceDate,
    required this.serviceTime,
    required this.existingPhotos,
    this.maxPhotos = 3,
    this.defaultServiceQuality = 4,
    this.defaultTechnicianBehavior = 5,
    this.defaultValueForMoney = 3,
  });
}

class ServiceRatingSubmissionModel {
  final String serviceId;
  final int starRating;
  final Set<String> selectedAttributes;
  final String feedback;
  final int serviceQuality;
  final int technicianBehavior;
  final int valueForMoney;
  final List<String> photoUrls;

  const ServiceRatingSubmissionModel({
    required this.serviceId,
    required this.starRating,
    required this.selectedAttributes,
    required this.feedback,
    required this.serviceQuality,
    required this.technicianBehavior,
    required this.valueForMoney,
    required this.photoUrls,
  });
}
