part of 'faq_cubit.dart';

abstract class FaqState extends Equatable {
  const FaqState();

  @override
  List<Object?> get props => [];
}

class FaqInitial extends FaqState {}

class FaqLoading extends FaqState {}

class FaqSuccess extends FaqState {
  final List<FaqModel> faqs;
  final String searchQuery;

  const FaqSuccess({
    required this.faqs,
    this.searchQuery = '',
  });

  List<FaqModel> get filteredFaqs {
    if (searchQuery.isEmpty) return faqs;
    return faqs
        .where((faq) =>
            faq.question.toLowerCase().contains(searchQuery.toLowerCase()) ||
            faq.answer.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  FaqSuccess copyWith({
    List<FaqModel>? faqs,
    String? searchQuery,
  }) {
    return FaqSuccess(
      faqs: faqs ?? this.faqs,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [faqs, searchQuery];
}

class FaqError extends FaqState {
  final String message;

  const FaqError({required this.message});

  @override
  List<Object?> get props => [message];
}
