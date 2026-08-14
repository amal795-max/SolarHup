import 'package:equatable/equatable.dart';

import '../../data/models/review_model.dart';

abstract class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object?> get props => [];
}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<ReviewModel> reviews;
  const ReviewsLoaded(this.reviews);
}

class ReviewsError extends ReviewsState {
  final String message;

  const ReviewsError({required this.message});
}

class ReviewSubmitLoading extends ReviewsState {}

class ReviewSubmitSuccess extends ReviewsState {
  final String message;

  const ReviewSubmitSuccess({required this.message});

}

class ReviewSubmitError extends ReviewsState {
  final String message;

  const ReviewSubmitError({required this.message});
}
