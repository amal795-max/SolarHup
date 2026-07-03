part of 'learning_hub_bloc.dart';

@immutable
sealed class LearningHubState extends Equatable {
  const LearningHubState();

  @override
  List<Object?> get props => [];
}

final class LearningHubInitial extends LearningHubState {}

final class LearningHubLoading extends LearningHubState {}

final class LearningHubLoaded extends LearningHubState {
  final LearningHubModel hub;
  final String glossarySearchQuery;

  const LearningHubLoaded({
    required this.hub,
    this.glossarySearchQuery = '',
  });

  List<GlossaryTermModel> get filteredGlossaryTerms {
    final query = glossarySearchQuery.trim().toLowerCase();
    if (query.isEmpty) return hub.glossaryTerms;
    return hub.glossaryTerms.where((entry) {
      return entry.term.toLowerCase().contains(query) ||
          entry.definition.toLowerCase().contains(query);
    }).toList();
  }

  LearningHubLoaded copyWith({
    LearningHubModel? hub,
    String? glossarySearchQuery,
  }) {
    return LearningHubLoaded(
      hub: hub ?? this.hub,
      glossarySearchQuery: glossarySearchQuery ?? this.glossarySearchQuery,
    );
  }

  @override
  List<Object?> get props => [hub, glossarySearchQuery];
}

final class LearningHubError extends LearningHubState {
  final String message;

  const LearningHubError({required this.message});

  @override
  List<Object?> get props => [message];
}
