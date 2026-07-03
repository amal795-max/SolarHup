import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/blog/data/models/learning_hub_model.dart';
import 'package:untitled1/features/blog/data/repositories/learning_hub_repository.dart';

part 'learning_hub_event.dart';
part 'learning_hub_state.dart';

class LearningHubBloc extends Bloc<LearningHubEvent, LearningHubState> {
  final LearningHubRepository repository;

  LearningHubBloc(this.repository) : super(LearningHubInitial()) {
    on<LoadLearningHubEvent>(_onLoad);
    on<UpdateGlossarySearchEvent>(_onUpdateGlossarySearch);
  }

  Future<void> _onLoad(
    LoadLearningHubEvent event,
    Emitter<LearningHubState> emit,
  ) async {
    emit(LearningHubLoading());
    final result = await repository.getLearningHub();
    result.fold(
      (failure) =>
          emit(LearningHubError(message: _mapFailureToMessage(failure))),
      (hub) => emit(LearningHubLoaded(hub: hub)),
    );
  }

  void _onUpdateGlossarySearch(
    UpdateGlossarySearchEvent event,
    Emitter<LearningHubState> emit,
  ) {
    final current = state;
    if (current is! LearningHubLoaded) return;
    emit(current.copyWith(glossarySearchQuery: event.query));
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
