import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/stores/data/models/store_model.dart';
import 'package:untitled1/features/stores/data/repositories/stores_repository.dart';

part 'stores_event.dart';
part 'stores_state.dart';

class StoresBloc extends Bloc<StoresEvent, StoresState> {
  final StoresRepository repository;

  StoresBloc(this.repository) : super(StoresInitial()) {
    on<LoadStoresEvent>(_onLoadStores);
    on<RefreshStoresEvent>(_onRefreshStores);
  }

  Future<void> _onLoadStores(
    LoadStoresEvent event,
    Emitter<StoresState> emit,
  ) async {
    if (event.showLoading) emit(StoresLoading());
    await _fetchStores(emit);
  }

  Future<void> _onRefreshStores(
    RefreshStoresEvent event,
    Emitter<StoresState> emit,
  ) async {
    await _fetchStores(emit);
  }

  Future<void> _fetchStores(Emitter<StoresState> emit) async {
    final result = await repository.getStores();
    result.fold(
      (failure) => emit(StoresError(message: _mapFailureToMessage(failure))),
      (stores) => emit(StoresLoaded(stores: stores)),
    );
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
