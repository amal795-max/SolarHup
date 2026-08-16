import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/constants/failure_success_message.dart';
import '../../data/models/review_model.dart';
import '../../data/repositories/reviews_repository.dart';
import 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRepository repository;

  ReviewsCubit({required this.repository}) : super(ReviewsInitial());

  Future<void> getReviews(String itemType, String itemId) async {
    emit(ReviewsLoading());

    final result = await repository.getReviews(itemType, itemId);

    result.fold(
      (failure) => emit(ReviewsError(message: mapFailureToMessage(failure))),
      (reviews) => emit(ReviewsLoaded(reviews)),
    );
  }

  Future<void> addReview(CreateReviewRequest request) async {
    emit(ReviewSubmitLoading());

    final result = await repository.addReview(request);

    result.fold(
      (failure) =>
          emit(ReviewSubmitError(message: mapFailureToMessage(failure))),
      (_) => emit(const ReviewSubmitSuccess(message: submitReviewSuccessfully)),
    );
  }

  void reset() {
    emit(ReviewsInitial());
  }
}
