part of 'faq_hub_bloc.dart';

@immutable
sealed class FaqHubState extends Equatable {
  const FaqHubState();

  @override
  List<Object?> get props => [];
}

final class FaqHubInitial extends FaqHubState {}

final class FaqHubLoading extends FaqHubState {}

final class FaqHubLoaded extends FaqHubState {
  final FaqHubModel hub;
  final String searchQuery;
  final int selectedCategoryIndex;
  final Set<String> expandedQuestionIds;

  const FaqHubLoaded({
    required this.hub,
    this.searchQuery = '',
    this.selectedCategoryIndex = 0,
    this.expandedQuestionIds = const {},
  });

  List<FaqQuestionModel> get _filteredQuestions {
    final query = searchQuery.trim().toLowerCase();
    final categoryKey = selectedCategoryIndex == 0
        ? null
        : hub.categories[selectedCategoryIndex - 1].key;

    return hub.questions.where((q) {
      final matchesCategory =
          categoryKey == null || q.categoryKey == categoryKey;
      if (!matchesCategory) return false;
      if (query.isEmpty) return true;
      return q.question.toLowerCase().contains(query) ||
          q.answer.toLowerCase().contains(query);
    }).toList();
  }

  List<FaqQuestionModel> get popularTopics =>
      _filteredQuestions.where((q) => q.isPopular).toList();

  List<FaqQuestionModel> get frequentQuestions =>
      _filteredQuestions.where((q) => !q.isPopular).toList();

  FaqHubLoaded copyWith({
    FaqHubModel? hub,
    String? searchQuery,
    int? selectedCategoryIndex,
    Set<String>? expandedQuestionIds,
  }) {
    return FaqHubLoaded(
      hub: hub ?? this.hub,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      expandedQuestionIds:
          expandedQuestionIds ?? this.expandedQuestionIds,
    );
  }

  @override
  List<Object?> get props => [
        hub,
        searchQuery,
        selectedCategoryIndex,
        expandedQuestionIds,
      ];
}

final class FaqHubError extends FaqHubState {
  final String message;

  const FaqHubError({required this.message});

  @override
  List<Object?> get props => [message];
}
