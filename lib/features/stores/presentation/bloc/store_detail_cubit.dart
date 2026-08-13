import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/catalog/data/models/discounted_product_model.dart';
import 'package:untitled1/features/stores/data/models/store_category_model.dart';
import 'package:untitled1/features/stores/data/models/store_detail_model.dart';
import 'package:untitled1/features/stores/data/models/store_product_model.dart';
import 'package:untitled1/features/catalog/data/repositories/catalog_repository.dart';
import 'package:untitled1/features/stores/data/repositories/stores_repository.dart';

part 'store_detail_state.dart';

class StoreDetailCubit extends Cubit<StoreDetailState> {
  final StoresRepository repository;
  final CatalogRepository catalogRepository;

  StoreDetailCubit(this.repository, this.catalogRepository)
      : super(StoreDetailInitial());

  Future<void> loadStore(int businessId, {int? categoryId}) async {
    emit(StoreDetailLoading());

    final storeResult = await repository.getStore(businessId);
    await storeResult.fold(
      (failure) async {
        emit(StoreDetailError(message: mapFailureToMessage(failure)));
      },
      (store) async {
        final categoriesResult = await repository.getStoreCategories();
        final categories = categoriesResult.fold(
          (_) => <StoreCategoryModel>[],
          (items) => items,
        );

        final productsResult = await repository.getStoreProducts(
          businessId,
          categoryId: categoryId,
        );
        final products = productsResult.fold(
          (_) => <StoreProductModel>[],
          (items) => items,
        );

        final discountedResult =
            await catalogRepository.getStoreDiscountedProducts(businessId);
        final discountedProducts = discountedResult.fold(
          (_) => <DiscountedProductModel>[],
          (items) => items,
        );

        emit(
          StoreDetailLoaded(
            store: store,
            categories: categories,
            products: products,
            discountedProducts: discountedProducts,
          ),
        );
      },
    );
  }
}
