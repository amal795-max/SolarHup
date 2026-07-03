import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/blog/data/models/faq_hub_model.dart';
import 'package:untitled1/features/blog/data/repositories/faq_hub_repository.dart';

part 'faq_hub_event.dart';
part 'faq_hub_state.dart';

class FaqHubBloc extends Bloc<FaqHubEvent, FaqHubState> {
  final FaqHubRepository repository;

  FaqHubBloc(this.repository) : super(FaqHubInitial()) {
    on<LoadFaqHubEvent>(_onLoad);
    on<UpdateFaqSearchEvent>(_onUpdateSearch);
    on<SelectFaqCategoryEvent>(_onSelectCategory);
    on<ToggleFaqExpandedEvent>(_onToggleExpanded);
  }

  Future<void> _onLoad(LoadFaqHubEvent event, Emitter<FaqHubState> emit) async {
    emit(FaqHubLoading());
    final result = await repository.getFaqHub();
    result.fold(
      (failure) => emit(FaqHubError(message: _mapFailureToMessage(failure))),
      (hub) => emit(FaqHubLoaded(hub: hub)),
    );
  }

  void _onUpdateSearch(UpdateFaqSearchEvent event, Emitter<FaqHubState> emit) {
    final current = state;
    if (current is! FaqHubLoaded) return;
    emit(current.copyWith(searchQuery: event.query, expandedQuestionIds: {}));
  }

  void _onSelectCategory(
    SelectFaqCategoryEvent event,
    Emitter<FaqHubState> emit,
  ) {
    final current = state;
    if (current is! FaqHubLoaded) return;
    emit(
      current.copyWith(
        selectedCategoryIndex: event.categoryIndex,
        expandedQuestionIds: {},
      ),
    );
  }

  void _onToggleExpanded(
    ToggleFaqExpandedEvent event,
    Emitter<FaqHubState> emit,
  ) {
    final current = state;
    if (current is! FaqHubLoaded) return;

    final expanded = Set<String>.from(current.expandedQuestionIds);
    if (expanded.contains(event.questionId)) {
      expanded.remove(event.questionId);
    } else {
      expanded.add(event.questionId);
    }
    emit(current.copyWith(expandedQuestionIds: expanded));
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
