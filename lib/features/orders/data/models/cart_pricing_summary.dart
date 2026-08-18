import 'package:equatable/equatable.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';

/// Preview of a promotion that will be sent on cart submit.
class CartPromotionPreview extends Equatable {
  final int promotionId;
  final String? promotionTitle;
  final double originalTotal;
  final double discountAmount;
  final double finalTotal;

  const CartPromotionPreview({
    required this.promotionId,
    this.promotionTitle,
    required this.originalTotal,
    required this.discountAmount,
    required this.finalTotal,
  });

  @override
  List<Object?> get props => [
        promotionId,
        promotionTitle,
        originalTotal,
        discountAmount,
        finalTotal,
      ];
}

/// Unified cart/checkout pricing for cart and shipping screens.
class CartPricingSummary extends Equatable {
  final double originalTotal;
  final double discountAmount;
  final double finalTotal;
  final int? promotionId;
  final String? promotionTitle;

  const CartPricingSummary({
    required this.originalTotal,
    required this.discountAmount,
    required this.finalTotal,
    this.promotionId,
    this.promotionTitle,
  });

  bool get hasDiscount => discountAmount > 0.01;

  factory CartPricingSummary.fromOrder(
    OrderModel order,
    CartPromotionPreview? preview,
  ) {
    if (order.hasBackendDiscount) {
      return CartPricingSummary(
        originalTotal: order.effectiveOriginalAmount,
        discountAmount: order.effectiveDiscountAmount,
        finalTotal: order.effectiveTotalAmount,
        promotionId: order.appliedPromotionId,
        promotionTitle: order.promotionTitle,
      );
    }

    if (preview != null && preview.discountAmount > 0.01) {
      return CartPricingSummary(
        originalTotal: preview.originalTotal,
        discountAmount: preview.discountAmount,
        finalTotal: preview.finalTotal,
        promotionId: preview.promotionId,
        promotionTitle: preview.promotionTitle,
      );
    }

    final retail = order.retailSubtotal;
    return CartPricingSummary(
      originalTotal: retail,
      discountAmount: 0,
      finalTotal: double.tryParse(order.totalAmount) ?? retail,
    );
  }

  @override
  List<Object?> get props => [
        originalTotal,
        discountAmount,
        finalTotal,
        promotionId,
        promotionTitle,
      ];
}
