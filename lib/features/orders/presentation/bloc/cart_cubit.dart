import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/features/orders/data/models/cart_item_model.dart';
import '../../../../core/constants/failure_success_message.dart';
import '../../data/repositories/cart_repository.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository repository;
  OrderModel? order;
  Timer? _debounce;

  CartCubit(this.repository) : super(CartInitial());

  Future<void> getCart() async {
    emit(CartLoading());
    final result = await repository.getCart();
    result.fold((failure) => emit(CartError(failure.message)), (cart) {
      order = cart;
      emit(CartSuccess(cart));
    });
  }

  Future<void> addToCart(int productId, int quantity) async {
    AddProductToCartParams params = AddProductToCartParams(
      id: productId,
      quantity: quantity,
    );
    emit(CartActionLoading());
    final result = await repository.addToCart(params);
    result.fold((failure) => emit(CartError(failure.message)), (_) {
      emit(const CartActionSuccess(addToCartSuccessfully));
      getCart();
    });
  }

  Future<void> updateCartItem(int productId, int quantity) async {
    AddProductToCartParams params = AddProductToCartParams(
      id: productId,
      quantity: quantity,
    );

    final oldItems = List<OrderItemModel>.from(order?.items ?? []);
    final updatedItems = order?.items.map((e) {
      if (e.itemId == productId) {
        return e.copyWith(quantity: quantity);
      }
      return e;
    }).toList();

    if (updatedItems != null) {
      order = order!.copyWith(items: updatedItems);
      emit(CartSuccess(order!));
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      final result = await repository.updateCartItem(params);
      result.fold(
        (failure) {
          order = order!.copyWith(items: oldItems);
          emit(CartError(failure.message));
          emit(CartSuccess(order!));
        },
        (_) {
          emit(CartSuccess(order!));
        },
      );
    });
  }

  Future<void> deleteCartItem(int productId) async {
    emit(CartActionLoading());
    final result = await repository.deleteCartItem(productId);
    result.fold((failure) => emit(CartError(failure.message)), (success) {
      order?.items.removeWhere((e) => productId == e.id);
      emit(CartSuccess(order!));
      // emit(const CartActionSuccess(productDeletedSuccessfully));
    });
  }

  Future<void> clearCart() async {
    emit(CartActionLoading());
    final result = await repository.clearCart();
    result.fold((failure) => emit(CartError(failure.message)), (_) {
      order?.items.clear();
      emit(const CartActionSuccess(cartClearedSuccessfully));
    });
  }

  Future<void> submitCart() async {
    emit(CartActionLoading());
    final result = await repository.submitCart();
    result.fold((failure) => emit(CartError(failure.message)), (_) {
      order?.items.clear();
      emit(const CartActionSuccess(cartSubmittedSuccessfully));
    });
  }
}
