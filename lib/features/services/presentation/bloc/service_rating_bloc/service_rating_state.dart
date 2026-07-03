part of 'service_rating_bloc.dart';

sealed class ServiceRatingState extends Equatable {
  const ServiceRatingState();

  @override
  List<Object?> get props => [];
}

final class ServiceRatingInitial extends ServiceRatingState {}

final class ServiceRatingLoading extends ServiceRatingState {}

final class ServiceRatingLoaded extends ServiceRatingState {
  final ServiceRatingModel rating;
  final int starRating;
  final Set<String> selectedAttributes;
  final String feedback;
  final double serviceQuality;
  final double technicianBehavior;
  final double valueForMoney;
  final List<String> photoUrls;
  final bool isSubmitting;
  final bool isSubmitted;
  final String? submitError;

  const ServiceRatingLoaded({
    required this.rating,
    this.starRating = 0,
    this.selectedAttributes = const {},
    this.feedback = '',
    required this.serviceQuality,
    required this.technicianBehavior,
    required this.valueForMoney,
    required this.photoUrls,
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.submitError,
  });

  ServiceRatingLoaded copyWith({
    ServiceRatingModel? rating,
    int? starRating,
    Set<String>? selectedAttributes,
    String? feedback,
    double? serviceQuality,
    double? technicianBehavior,
    double? valueForMoney,
    List<String>? photoUrls,
    bool? isSubmitting,
    bool? isSubmitted,
    String? submitError,
  }) {
    return ServiceRatingLoaded(
      rating: rating ?? this.rating,
      starRating: starRating ?? this.starRating,
      selectedAttributes: selectedAttributes ?? this.selectedAttributes,
      feedback: feedback ?? this.feedback,
      serviceQuality: serviceQuality ?? this.serviceQuality,
      technicianBehavior: technicianBehavior ?? this.technicianBehavior,
      valueForMoney: valueForMoney ?? this.valueForMoney,
      photoUrls: photoUrls ?? this.photoUrls,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      submitError: submitError,
    );
  }

  @override
  List<Object?> get props => [
        rating,
        starRating,
        selectedAttributes,
        feedback,
        serviceQuality,
        technicianBehavior,
        valueForMoney,
        photoUrls,
        isSubmitting,
        isSubmitted,
        submitError,
      ];
}

final class ServiceRatingError extends ServiceRatingState {
  final String message;

  const ServiceRatingError({required this.message});

  @override
  List<Object?> get props => [message];
}
