import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/catalog/data/repositories/catalog_repository.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';
import '../../../../core/constants/failure_success_message.dart';
import '../../data/repositories/cart_repository.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  final CartRepository repository;
  final CatalogRepository catalogRepository;
  OrderModel? order;
  Timer? _debounce;

  CartCubit(this.repository, this.catalogRepository) : super(CartInitial());

  Future<void> getCart() async {
    emit(CartLoading());
    final result = await repository.getCart();
    result.fold((failure) => emit(CartError(failure.message)), (cart) async {
      order = await _applyDiscountPricing(cart);
      emit(CartSuccess(order!));
    });
  }

  Future<OrderModel> _applyDiscountPricing(OrderModel cart) async {
    if (cart.businessId <= 0 || cart.items.isEmpty) return cart;

    final result = await catalogRepository.getStoreDiscountedProducts(
      cart.businessId,
    );

    return result.fold(
      (_) => cart,
      (products) => applyDiscountPricingToCart(
        cart,
        buildDiscountedPriceMap(products),
      ),
    );
  }

  Future<void> addToCart(int productId, int quantity) async {
    AddProductToCartParams params = AddProductToCartParams(
      id: productId,
      quantity: quantity,
    );
    emit(CartActionLoading());
    final result = await repository.addToCart(params);
    result.fold((failure) => emit(CartError(failure.message)), (_) async {
      emit(const CartActionSuccess(addToCartSuccessfully));
      await getCart();
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
      if (order != null) {
        emit(CartSuccess(order!));
      }
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
    ShippingInformationParams params = ShippingInformationParams(
      fullName: fullNameController.text.trim(),
      city: cityController.text.trim(),
      street: streetController.text.trim(),
      building: buildingController.text.trim(),
      floor: floorController.text.trim(),
    );
      emit(CartActionLoading());
      final result = await repository.submitCart(params);
      result.fold(
              (failure) => emit(CartActionError(failure.message)),
              (_) {
        clearForm();
        // order?.items.clear();
        emit(const CartActionSuccess(cartSubmittedSuccessfully));
      });

  }

  void clearForm() {
    fullNameController.clear();
    floorController.clear();
    streetController.clear();
    buildingController.clear();
    cityController.clear();
  }
}
