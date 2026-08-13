import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/stores/data/models/store_model.dart';
import 'package:untitled1/features/stores/data/repositories/stores_repository.dart';

part 'stores_state.dart';

class StoresCubit extends Cubit<StoresState> {
  final StoresRepository repository;

  StoresCubit(this.repository) : super(StoresInitial());

  Future<void> loadStores({bool showLoading = false}) async {
    if (showLoading || state is StoresInitial) {
      emit(StoresLoading());
    }
    await _fetchStores();
  }

  Future<void> refreshStores() async {
    await _fetchStores();
  }

  Future<void> _fetchStores() async {
    final result = await repository.getStores();
    result.fold(
      (failure) => emit(StoresError(message: mapFailureToMessage(failure))),
      (stores) => emit(StoresLoaded(stores: stores)),
    );
  }
}
