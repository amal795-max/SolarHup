import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/catalog/data/repositories/catalog_repository.dart';
import 'package:untitled1/features/orders/data/models/cart_pricing_summary.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';
import 'package:untitled1/features/orders/services/promotion_eligibility_service.dart';
import 'package:untitled1/features/orders/utils/cart_promotion_resolver.dart';
import '../../../../core/constants/app_url.dart';
import '../../../../core/constants/failure_success_message.dart';
import '../../../../core/helper/local_storage.dart';
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
  final PromotionEligibilityService promotionEligibility;
  OrderModel? order;
  CartPricingSummary? pricingSummary;
  CartPromotionPreview? _promotionPreview;
  Timer? _debounce;

  CartCubit(
    this.repository,
    this.catalogRepository,
    this.promotionEligibility,
  ) : super(CartInitial());

  Future<void> getCart({bool showLoading = false}) async {
    if (showLoading || order == null) {
      emit(CartLoading());
    }
    await promotionEligibility.ensureSynced();
    final result = await repository.getCart();
    result.fold((failure) => emit(CartError(failure.message)), (cart) async {
      await _emitEnrichedCart(cart);
    });
  }

  Future<void> _emitEnrichedCart(OrderModel cart) async {
    final enriched = await _enrichCart(cart);
    order = enriched.cart;
    _promotionPreview = enriched.preview;
    pricingSummary = enriched.pricing;
    emit(CartSuccess(order!, pricing: pricingSummary!));
  }

  Future<
      ({
        OrderModel cart,
        CartPromotionPreview? preview,
        CartPricingSummary pricing,
      })> _enrichCart(OrderModel cart) async {
    if (cart.businessId <= 0 || cart.items.isEmpty) {
      final pricing = CartPricingSummary.fromOrder(cart, null);
      return (cart: cart, preview: null, pricing: pricing);
    }

    var enriched = cart;
    CartPromotionPreview? preview;
    final usedPromotionIds = promotionEligibility.usedPromotionIds;

    if (!cart.hasBackendDiscount) {
      final discountsResult = await catalogRepository.getStoreDiscounts(
        cart.businessId,
      );
      discountsResult.fold((_) {}, (discounts) {
        enriched = applyEligiblePromotionPricingToCart(
          cart,
          discounts,
          usedPromotionIds: usedPromotionIds,
        );
        preview = resolveCartPromotionPreview(
          enriched,
          discounts,
          excludedPromotionIds: usedPromotionIds,
        );
      });
    }

    final pricing = CartPricingSummary.fromOrder(enriched, preview);
    return (cart: enriched, preview: preview, pricing: pricing);
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
    });
  }

  Future<void> updateCartItem(int itemId, int quantity) async {
    UpdateProductToCartParams params = UpdateProductToCartParams(
      quantity: quantity,
    );
    if (order == null || pricingSummary == null) return;
    final oldOrder = order!;
    final oldPricing = pricingSummary!;
    final updatedItems = order!.items.map((e) {
      if (e.id == itemId) {
        return e.copyWith(
          quantity: quantity,
          subtotal: (double.parse(e.effectiveUnitPrice) * quantity)
              .toStringAsFixed(2),
        );
      }
      return e;
    }).toList();

    order = order!.copyWith(items: updatedItems);
    await _emitEnrichedCart(order!);

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final result = await repository.updateCartItem(params, itemId);
      result.fold(
        (failure) {
          order = oldOrder;
          pricingSummary = oldPricing;
          emit(CartSuccess(order!, pricing: pricingSummary!));
          emit(CartError(failure.message));
        },
        (_) async {
          final freshResult = await repository.getCart();
          freshResult.fold(
            (_) {
              if (order != null && pricingSummary != null) {
                emit(CartSuccess(order!, pricing: pricingSummary!));
              }
            },
            (freshCart) async => _emitEnrichedCart(freshCart),
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
        if (order!.items.isEmpty) {
          _promotionPreview = null;
          pricingSummary = CartPricingSummary.fromOrder(order!, null);
          emit(CartSuccess(order!, pricing: pricingSummary!));
        } else {
          await _emitEnrichedCart(order!);
        }
        emit(const CartActionSuccess(deleteFromCartSuccessfully));
      }
    });
  }

  Future<void> clearCart() async {
    emit(CartActionLoading());
    final result = await repository.clearCart();
    result.fold((failure) => emit(CartError(failure.message)), (_) {
      order = OrderModel.empty();
      _promotionPreview = null;
      pricingSummary = CartPricingSummary.fromOrder(order!, null);
      emit(CartSuccess(order!, pricing: pricingSummary!));
      emit(const CartActionSuccess(cartClearedSuccessfully));
    });
  }

  Future<void> submitCart() async {
    final promotionId = _resolvePromotionIdForSubmit();

    ShippingInformationParams params = ShippingInformationParams(
      fullName: fullNameController.text.trim(),
      city: cityController.text.trim(),
      street: streetController.text.trim(),
      building: buildingController.text.trim(),
      floor: floorController.text.trim(),
      promotionId: promotionId,
    );
    emit(CartActionLoading());
    final result = await repository.submitCart(params);
    result.fold(
      (failure) async {
        final message = failure.message;
        if (_isPromotionUsageError(message) && promotionId != null) {
          promotionEligibility.markUsed(promotionId);
          _promotionPreview = null;
          if (order != null) {
            await _emitEnrichedCart(order!);
          }
        }
        emit(CartActionError(message));
      },
      (_) async {
        if (promotionId != null) {
          promotionEligibility.markUsed(promotionId);
        }
        final submittedOrderId = order?.id;
        if (submittedOrderId != null && submittedOrderId > 0) {
          await LocalStorage().saveData(
            key: ApiKeys.orderId,
            value: submittedOrderId,
          );
        }
        clearForm();
        emit(const CartActionSuccess(cartSubmittedSuccessfully));
      },
    );
  }

  int? _resolvePromotionIdForSubmit() {
    final previewId = _promotionPreview?.promotionId;
    if (previewId != null && promotionEligibility.isEligible(previewId)) {
      return previewId;
    }

    final appliedId = order?.appliedPromotionId;
    if (appliedId != null && promotionEligibility.isEligible(appliedId)) {
      return appliedId;
    }

    return null;
  }

  bool _isPromotionUsageError(String message) {
    final lower = message.toLowerCase();
    return lower.contains('promotion') &&
        (lower.contains('already used') ||
            lower.contains('maximum number of times'));
  }

  void clearForm() {
    fullNameController.clear();
    floorController.clear();
    streetController.clear();
    buildingController.clear();
    cityController.clear();
  }
}
