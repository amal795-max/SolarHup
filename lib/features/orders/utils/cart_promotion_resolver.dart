import 'package:untitled1/features/catalog/data/models/discount_model.dart';
import 'package:untitled1/features/orders/data/models/cart_pricing_summary.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';

CartPromotionPreview? resolveCartPromotionPreview(
  OrderModel cart,
  List<DiscountModel> discounts, {
  Set<int> excludedPromotionIds = const {},
}) {
  if (cart.items.isEmpty || discounts.isEmpty) return null;

  final retailTotal = cart.retailSubtotal;
  if (retailTotal <= 0) return null;

  CartPromotionPreview? best;

  for (final discount in discounts) {
    if (excludedPromotionIds.contains(discount.id)) continue;

    final productIds = {for (final product in discount.products) product.id};
    final hasMatchingItem =
        cart.items.any((item) => productIds.contains(item.itemId));
    if (!hasMatchingItem) continue;
    if (retailTotal + 0.001 < discount.minPurchaseAmount) continue;

    final finalTotal = _applyPromotionToTotal(
      retailTotal: retailTotal,
      discountType: discount.discountType,
      discountValue: discount.discountValue,
    );
    final discountAmount = retailTotal - finalTotal;
    if (discountAmount <= 0.01) continue;

    if (best == null || discountAmount > best.discountAmount) {
      best = CartPromotionPreview(
        promotionId: discount.id,
        promotionTitle: discount.title,
        originalTotal: retailTotal,
        discountAmount: discountAmount,
        finalTotal: finalTotal,
      );
    }
  }

  return best;
}

double _applyPromotionToTotal({
  required double retailTotal,
  required String discountType,
  required double discountValue,
}) {
  if (retailTotal <= 0) return 0;

  if (discountType == 'fixed') {
    return (retailTotal - discountValue).clamp(0, retailTotal);
  }

  return (retailTotal * (1 - (discountValue / 100))).clamp(0, retailTotal);
}
