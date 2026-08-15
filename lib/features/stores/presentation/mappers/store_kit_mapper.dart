import 'package:untitled1/features/catalog/data/mappers/discounted_product_mapper.dart';
import 'package:untitled1/features/catalog/data/models/discount_model.dart';
import 'package:untitled1/features/stores/data/models/store_product_model.dart';
import 'package:untitled1/features/stores/presentation/pages/store_kit_screen.dart';

List<StoreKitProductData> storeProductsToKitData(
  List<StoreProductModel> products, {
  required int businessId,
  List<DiscountModel> discounts = const [],
}) {
  return products
      .map(
        (product) => _toKitProduct(
          product,
          businessId: businessId,
          discounts: discounts,
        ),
      )
      .toList();
}

StoreKitProductData _toKitProduct(
  StoreProductModel product, {
  required int businessId,
  required List<DiscountModel> discounts,
}) {
  var price = product.price;
  double? originalPrice;
  int? discountPercent;
  String? badgeText;

  final candidate = findBestDiscountForProduct(
    discounts: discounts,
    businessId: businessId,
    productId: product.id,
  );
  if (candidate != null) {
    final pricing = computeDiscountPricing(
      retailPrice: product.price,
      discountType: candidate.discountType,
      discountValue: candidate.discountValue,
    );
    if (pricing.discountPercent != null || pricing.salePrice < product.price) {
      price = pricing.salePrice;
      originalPrice = product.price;
      discountPercent = pricing.discountPercent;
      badgeText =
          candidate.discountLabel.isNotEmpty ? candidate.discountLabel : null;
    }
  }

  return StoreKitProductData(
    id: product.id,
    businessId: product.businessId,
    categoryId: product.categoryId,
    categoryKey: product.category,
    name: product.name,
    price: price,
    originalPrice: originalPrice,
    discountPercent: discountPercent,
    badgeText: badgeText,
    rating: 0,
    reviews: product.quantity,
    imageColorValue: product.imagePlaceholderColorValue,
    imageUrl: product.imageUrl,
  );
}
