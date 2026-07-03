part of 'faq_hub_bloc.dart';

@immutable
sealed class FaqHubEvent extends Equatable {
  const FaqHubEvent();

  @override
  List<Object?> get props => [];
}

final class LoadFaqHubEvent extends FaqHubEvent {
  const LoadFaqHubEvent();
}

final class UpdateFaqSearchEvent extends FaqHubEvent {
  final String query;

  const UpdateFaqSearchEvent(this.query);

  @override
  List<Object?> get props => [query];
}

final class SelectFaqCategoryEvent extends FaqHubEvent {
  final int categoryIndex;

  const SelectFaqCategoryEvent(this.categoryIndex);

  @override
  List<Object?> get props => [categoryIndex];
}

final class ToggleFaqExpandedEvent extends FaqHubEvent {
  final String questionId;

  const ToggleFaqExpandedEvent(this.questionId);

  @override
  List<Object?> get props => [questionId];
}
