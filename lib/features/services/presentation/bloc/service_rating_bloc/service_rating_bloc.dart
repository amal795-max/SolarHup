import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/services/data/models/service_rating_model.dart';
import 'package:untitled1/features/services/data/repositories/service_rating_repository.dart';

part 'service_rating_event.dart';
part 'service_rating_state.dart';

class ServiceRatingBloc extends Bloc<ServiceRatingEvent, ServiceRatingState> {
  final ServiceRatingRepository repository;

  static const attributeKeys = [
    'chip_professional',
    'on_time',
    'helpful',
    'chip_high_quality',
    'needs_improvement',
    'not_satisfied',
  ];

  ServiceRatingBloc(this.repository) : super(ServiceRatingInitial()) {
    on<LoadServiceRatingEvent>(_onLoad);
    on<UpdateStarRatingEvent>(_onUpdateStarRating);
    on<ToggleAttributeChipEvent>(_onToggleChip);
    on<UpdateFeedbackEvent>(_onUpdateFeedback);
    on<UpdateServiceQualityEvent>(_onUpdateServiceQuality);
    on<UpdateTechnicianBehaviorEvent>(_onUpdateTechnicianBehavior);
    on<UpdateValueForMoneyEvent>(_onUpdateValueForMoney);
    on<AddServicePhotoEvent>(_onAddPhoto);
    on<SubmitServiceRatingEvent>(_onSubmit);
  }

  Future<void> _onLoad(
    LoadServiceRatingEvent event,
    Emitter<ServiceRatingState> emit,
  ) async {
    emit(ServiceRatingLoading());
    final result = await repository.getServiceRating(event.serviceId);
    result.fold(
      (failure) =>
          emit(ServiceRatingError(message: _mapFailureToMessage(failure))),
      (data) => emit(
        ServiceRatingLoaded(
          rating: data,
          serviceQuality: data.defaultServiceQuality.toDouble(),
          technicianBehavior: data.defaultTechnicianBehavior.toDouble(),
          valueForMoney: data.defaultValueForMoney.toDouble(),
          photoUrls: data.existingPhotos.map((p) => p.imageUrl).toList(),
        ),
      ),
    );
  }

  void _onUpdateStarRating(
    UpdateStarRatingEvent event,
    Emitter<ServiceRatingState> emit,
  ) {
    final current = state;
    if (current is! ServiceRatingLoaded) return;
    emit(current.copyWith(starRating: event.rating));
  }

  void _onToggleChip(
    ToggleAttributeChipEvent event,
    Emitter<ServiceRatingState> emit,
  ) {
    final current = state;
    if (current is! ServiceRatingLoaded) return;
    final updated = Set<String>.from(current.selectedAttributes);
    if (updated.contains(event.key)) {
      updated.remove(event.key);
    } else {
      updated.add(event.key);
    }
    emit(current.copyWith(selectedAttributes: updated));
  }

  void _onUpdateFeedback(
    UpdateFeedbackEvent event,
    Emitter<ServiceRatingState> emit,
  ) {
    final current = state;
    if (current is! ServiceRatingLoaded) return;
    emit(current.copyWith(feedback: event.value));
  }

  void _onUpdateServiceQuality(
    UpdateServiceQualityEvent event,
    Emitter<ServiceRatingState> emit,
  ) {
    final current = state;
    if (current is! ServiceRatingLoaded) return;
    emit(current.copyWith(serviceQuality: event.value));
  }

  void _onUpdateTechnicianBehavior(
    UpdateTechnicianBehaviorEvent event,
    Emitter<ServiceRatingState> emit,
  ) {
    final current = state;
    if (current is! ServiceRatingLoaded) return;
    emit(current.copyWith(technicianBehavior: event.value));
  }

  void _onUpdateValueForMoney(
    UpdateValueForMoneyEvent event,
    Emitter<ServiceRatingState> emit,
  ) {
    final current = state;
    if (current is! ServiceRatingLoaded) return;
    emit(current.copyWith(valueForMoney: event.value));
  }

  void _onAddPhoto(
    AddServicePhotoEvent event,
    Emitter<ServiceRatingState> emit,
  ) {
    final current = state;
    if (current is! ServiceRatingLoaded) return;
    if (current.photoUrls.length >= current.rating.maxPhotos) return;
    final updated = List<String>.from(current.photoUrls)
      ..add(event.imageUrl);
    emit(current.copyWith(photoUrls: updated));
  }

  Future<void> _onSubmit(
    SubmitServiceRatingEvent event,
    Emitter<ServiceRatingState> emit,
  ) async {
    final current = state;
    if (current is! ServiceRatingLoaded) return;

    emit(current.copyWith(isSubmitting: true));
    final submission = ServiceRatingSubmissionModel(
      serviceId: current.rating.serviceId,
      starRating: current.starRating,
      selectedAttributes: current.selectedAttributes,
      feedback: current.feedback,
      serviceQuality: current.serviceQuality.round(),
      technicianBehavior: current.technicianBehavior.round(),
      valueForMoney: current.valueForMoney.round(),
      photoUrls: current.photoUrls,
    );

    final result = await repository.submitServiceRating(submission);
    result.fold(
      (failure) => emit(
        current.copyWith(
          isSubmitting: false,
          submitError: _mapFailureToMessage(failure),
        ),
      ),
      (_) => emit(current.copyWith(isSubmitting: false, isSubmitted: true)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (OfflineFailure):
        return 'No internet connection';
      case const (ServerFailure):
        return (failure as ServerFailure).message;
      default:
        return 'Unexpected error occurred';
    }
  }
}
