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

  Future<void> getCart({bool showLoading = false}) async {
    if (showLoading || order == null) {
      emit(CartLoading());
    }
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
      (products) =>
          applyDiscountPricingToCart(cart, buildDiscountedPriceMap(products)),
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

  Future<void> updateCartItem(int itemId, int quantity) async {
    UpdateProductToCartParams params = UpdateProductToCartParams(
      quantity: quantity,
    );
    if (order == null) return;
    final oldOrder = order!;
    final updatedItems = order!.items.map((e) {
      if (e.id == itemId) {
        return e.copyWith(
          quantity: quantity,
          subtotal: (double.parse(e.effectiveUnitPrice) * quantity).toStringAsFixed(2),
        );
      }
      return e;
    }).toList();

    order = order!.copyWith(
      items: updatedItems,
      totalAmount: updatedItems.fold<double>(0, (sum, item) => sum + double.parse(item.subtotal)).toStringAsFixed(2),
    );
    emit(CartSuccess(order!));

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final result = await repository.updateCartItem(params, itemId);
      result.fold(
        (failure) {
          order = oldOrder;
          emit(CartError(failure.message));
        },
        (_) async {
          final freshResult = await repository.getCart();
          freshResult.fold(
            (_) => emit(CartSuccess(order!)),
            (freshCart) async {
              order = await _applyDiscountPricing(freshCart);
              emit(CartSuccess(order!));
            },
          );
        },
      );
    });
  }

  Future<void> deleteCartItem(int itemId) async {
    emit(CartActionLoading());
    final result = await repository.deleteCartItem(itemId);
    result.fold((failure) => emit(CartError(failure.message)), (success) async {
      order?.items.removeWhere((e) => itemId == e.id);
      if (order != null) {
        final newTotal = order!.items.fold<double>(0, (sum, item) => sum + double.parse(item.subtotal)).toStringAsFixed(2);
        order = order!.copyWith(totalAmount: newTotal);
        await _applyDiscountPricing(order!);
        emit(CartSuccess(order!));
        emit(const CartActionSuccess(deleteFromCartSuccessfully));
      }
    });
  }

  Future<void> clearCart() async {
    emit(CartActionLoading());
    final result = await repository.clearCart();
    result.fold((failure) => emit(CartError(failure.message)), (_) {
      order = OrderModel.empty();
      emit(CartSuccess(order!));
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
    result.fold((failure) => emit(CartActionError(failure.message)), (_) {
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
