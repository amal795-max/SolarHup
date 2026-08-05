import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/stores/data/models/store_product_model.dart';
import 'package:untitled1/features/stores/data/repositories/stores_repository.dart';

part 'store_kit_cubit_state.dart';

class StoreKitCubit extends Cubit<StoreKitCubitState> {
  final StoresRepository repository;

  StoreKitCubit(this.repository) : super(StoreKitCubitInitial());

  Future<void> loadProducts(String businessId, {int? categoryId}) async {
    emit(StoreKitCubitLoading());

    final result = await repository.getStoreProducts(
      businessId,
      categoryId: categoryId,
    );
    result.fold(
      (failure) =>
          emit(StoreKitCubitError(message: mapFailureToMessage(failure))),
      (products) => emit(StoreKitCubitLoaded(products: products)),
    );
  }
}
