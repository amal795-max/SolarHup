part of 'learning_hub_bloc.dart';

@immutable
sealed class LearningHubEvent extends Equatable {
  const LearningHubEvent();

  @override
  List<Object?> get props => [];
}

final class LoadLearningHubEvent extends LearningHubEvent {
  const LoadLearningHubEvent();
}

final class UpdateGlossarySearchEvent extends LearningHubEvent {
  final String query;

  const UpdateGlossarySearchEvent(this.query);

  @override
  List<Object?> get props => [query];
}
