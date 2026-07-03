import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/services/data/models/expert_service_model.dart';
import 'package:untitled1/features/services/data/repositories/services_repository.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesRepository repository;

  ServicesBloc(this.repository) : super(ServicesInitial()) {
    on<LoadServicesEvent>(_onLoad);
    on<UpdateServicesSearchEvent>(_onUpdateSearch);
    on<SelectServicesCategoryEvent>(_onSelectCategory);
  }

  Future<void> _onLoad(
    LoadServicesEvent event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    final result = await repository.getServicesFeed();
    result.fold(
      (failure) => emit(ServicesError(message: _mapFailureToMessage(failure))),
      (data) => emit(
        ServicesLoaded(
          allServices: data.services,
          featured: data.featured,
        ),
      ),
    );
  }

  void _onUpdateSearch(
    UpdateServicesSearchEvent event,
    Emitter<ServicesState> emit,
  ) {
    final current = state;
    if (current is! ServicesLoaded) return;
    emit(current.copyWith(searchQuery: event.query));
  }

  void _onSelectCategory(
    SelectServicesCategoryEvent event,
    Emitter<ServicesState> emit,
  ) {
    final current = state;
    if (current is! ServicesLoaded) return;
    emit(current.copyWith(selectedCategoryIndex: event.categoryIndex));
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
