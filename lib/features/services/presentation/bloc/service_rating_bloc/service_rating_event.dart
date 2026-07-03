part of 'service_rating_bloc.dart';

sealed class ServiceRatingEvent extends Equatable {
  const ServiceRatingEvent();

  @override
  List<Object?> get props => [];
}

final class LoadServiceRatingEvent extends ServiceRatingEvent {
  final String serviceId;

  const LoadServiceRatingEvent(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}

final class UpdateStarRatingEvent extends ServiceRatingEvent {
  final int rating;

  const UpdateStarRatingEvent(this.rating);

  @override
  List<Object?> get props => [rating];
}

final class ToggleAttributeChipEvent extends ServiceRatingEvent {
  final String key;

  const ToggleAttributeChipEvent(this.key);

  @override
  List<Object?> get props => [key];
}

final class UpdateFeedbackEvent extends ServiceRatingEvent {
  final String value;

  const UpdateFeedbackEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class UpdateServiceQualityEvent extends ServiceRatingEvent {
  final double value;

  const UpdateServiceQualityEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class UpdateTechnicianBehaviorEvent extends ServiceRatingEvent {
  final double value;

  const UpdateTechnicianBehaviorEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class UpdateValueForMoneyEvent extends ServiceRatingEvent {
  final double value;

  const UpdateValueForMoneyEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class AddServicePhotoEvent extends ServiceRatingEvent {
  final String imageUrl;

  const AddServicePhotoEvent(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

final class SubmitServiceRatingEvent extends ServiceRatingEvent {
  const SubmitServiceRatingEvent();
}
