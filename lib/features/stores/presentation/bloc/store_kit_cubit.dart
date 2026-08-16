import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/catalog/data/models/discount_model.dart';
import 'package:untitled1/features/catalog/data/repositories/catalog_repository.dart';
import 'package:untitled1/features/stores/data/models/store_category_model.dart';
import 'package:untitled1/features/stores/data/models/store_product_model.dart';
import 'package:untitled1/features/stores/data/repositories/stores_repository.dart';

part 'store_kit_cubit_state.dart';

class StoreKitCubit extends Cubit<StoreKitCubitState> {
  final StoresRepository repository;
  final CatalogRepository catalogRepository;

  StoreKitCubit(this.repository, this.catalogRepository)
    : super(StoreKitCubitInitial());

  Future<void> loadProducts(int businessId, {int? categoryId}) async {
    emit(StoreKitCubitLoading());

    final categoriesResult = await repository.getStoreCategories();
    final categories = categoriesResult.fold(
      (_) => <StoreCategoryModel>[],
      (items) => items,
    );

    final discountsResult = await catalogRepository.getStoreDiscounts(
      businessId,
    );
    final discounts = discountsResult.fold(
      (_) => <DiscountModel>[],
      (items) => items,
    );

    final result = await repository.getStoreProducts(
      businessId,
      categoryId: categoryId,
    );
    result.fold(
      (failure) =>
          emit(StoreKitCubitError(message: mapFailureToMessage(failure))),
      (products) => emit(
        StoreKitCubitLoaded(
          categories: categories,
          products: products,
          discounts: discounts,
        ),
      ),
    );
  }
}
