import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';
import 'package:untitled1/features/stores/data/repositories/product_detail_repository.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductDetailRepository repository;

  ProductDetailBloc(this.repository) : super(ProductDetailInitial()) {
    on<LoadProductDetailEvent>(_onLoadProductDetail);
    on<SelectGalleryImageEvent>(_onSelectGalleryImage);
    on<AddProductToCartEvent>(_onAddToCart);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetailEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading());

    final result = await repository.getProductDetail(event.productId);
    result.fold(
      (failure) => emit(ProductDetailError(message: _mapFailureToMessage(failure))),
      (product) => emit(
        ProductDetailLoaded(
          product: product,
          selectedImageIndex: 0,
          isAddingToCart: false,
        ),
      ),
    );
  }

  void _onSelectGalleryImage(
    SelectGalleryImageEvent event,
    Emitter<ProductDetailState> emit,
  ) {
    final current = state;
    if (current is! ProductDetailLoaded) return;

    emit(current.copyWith(selectedImageIndex: event.index));
  }

  Future<void> _onAddToCart(
    AddProductToCartEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    final current = state;
    if (current is! ProductDetailLoaded) return;

    emit(current.copyWith(isAddingToCart: true));
    // TODO: Wire up cart repository when available
    await Future<void>.delayed(const Duration(milliseconds: 400));
    emit(current.copyWith(isAddingToCart: false, addedToCart: true));
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
