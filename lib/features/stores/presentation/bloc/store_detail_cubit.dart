import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/stores/data/models/store_detail_model.dart';
import 'package:untitled1/features/stores/data/repositories/stores_repository.dart';

part 'store_detail_state.dart';

class StoreDetailCubit extends Cubit<StoreDetailState> {
  final StoresRepository repository;

  StoreDetailCubit(this.repository) : super(StoreDetailInitial());

  Future<void> loadStore(String businessId) async {
    emit(StoreDetailLoading());
    final result = await repository.getStore(businessId);
    result.fold(
      (failure) =>
          emit(StoreDetailError(message: mapFailureToMessage(failure))),
      (store) => emit(StoreDetailLoaded(store: store)),
    );
  }
}
