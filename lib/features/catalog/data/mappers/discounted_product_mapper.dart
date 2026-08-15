import 'package:untitled1/features/catalog/data/models/discount_model.dart';
import 'package:untitled1/features/catalog/data/models/discounted_product_model.dart';
import 'package:untitled1/features/home/data/models/product_model.dart';
import 'package:untitled1/features/orders/data/models/order_model.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

class DiscountProductCandidate {
  final String productId;
  final int businessId;
  final String name;
  final String category;
  final String businessName;
  final String discountType;
  final double discountValue;
  final String discountLabel;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;

  const DiscountProductCandidate({
    required this.productId,
    required this.businessId,
    required this.name,
    required this.category,
    required this.businessName,
    required this.discountType,
    required this.discountValue,
    required this.discountLabel,
    this.description,
    this.startDate,
    this.endDate,
  });
}

List<DiscountProductCandidate> flattenDiscountProducts(
  List<DiscountModel> discounts,
) {
  final bestByKey = <String, DiscountProductCandidate>{};

  for (final discount in discounts) {
    for (final product in discount.products) {
      final key = '${discount.businessId}-${product.id}';
      final candidate = DiscountProductCandidate(
        productId: product.id.toString(),
        businessId: discount.businessId,
        name: product.name,
        category: product.category,
        businessName: discount.businessName,
        discountType: discount.discountType,
        discountValue: discount.discountValue,
        discountLabel: discount.discountLabel,
        description: discount.description,
        startDate: discount.startDate,
        endDate: discount.endDate,
      );
      final existing = bestByKey[key];
      if (existing == null ||
          _effectiveDiscountPercent(
                candidate.discountType,
                candidate.discountValue,
              ) >
              _effectiveDiscountPercent(
                existing.discountType,
                existing.discountValue,
              )) {
        bestByKey[key] = candidate;
      }
    }
  }

  return bestByKey.values.toList();
}

List<DiscountProductCandidate> topDiscountCandidates(
  List<DiscountModel> discounts, {
  int? limit,
}) {
  final candidates = flattenDiscountProducts(discounts)
    ..sort(
      (a, b) => _effectiveDiscountPercent(b.discountType, b.discountValue)
          .compareTo(_effectiveDiscountPercent(a.discountType, a.discountValue)),
    );
  if (limit == null) return candidates;
  return candidates.take(limit).toList();
}

DiscountedProductModel candidateToDiscountedProductPreview(
  DiscountProductCandidate candidate,
) {
  return DiscountedProductModel(
    productId: candidate.productId,
    businessId: candidate.businessId,
    name: candidate.name,
    category: _formatCategory(candidate.category),
    businessName: candidate.businessName,
    discountLabel: candidate.discountLabel,
    price: 0,
    originalPrice: 0,
    discountPercent: _previewDiscountPercent(
      candidate.discountType,
      candidate.discountValue,
    ),
    imageUrl: null,
    imagePlaceholderColorValue: _placeholderColorForProductId(candidate.productId),
    discountDescription: candidate.description,
    discountStartDate: candidate.startDate,
    discountEndDate: candidate.endDate,
  );
}

int? _previewDiscountPercent(String discountType, double discountValue) {
  if (discountType != 'percentage') return null;
  final percent = discountValue.round();
  return percent > 0 ? percent : null;
}

int _placeholderColorForProductId(String productId) {
  const palette = [
    0xFF0A2A43,
    0xFF1A3A5C,
    0xFF2A4A6C,
    0xFF3A5A7C,
    0xFF4A6A8C,
  ];
  final id = int.tryParse(productId) ?? productId.hashCode;
  return palette[id.abs() % palette.length];
}

DiscountedProductModel mergeDiscountWithProductDetail({
  required DiscountProductCandidate candidate,
  required ProductDetailModel detail,
}) {
  final originalPrice = detail.currentPrice;
  final pricing = _applyDiscount(
    retailPrice: originalPrice,
    discountType: candidate.discountType,
    discountValue: candidate.discountValue,
  );

  return DiscountedProductModel(
    productId: candidate.productId,
    businessId: candidate.businessId,
    name: detail.title.isNotEmpty ? detail.title : candidate.name,
    category: _formatCategory(candidate.category),
    businessName: candidate.businessName,
    discountLabel: candidate.discountLabel,
    price: pricing.salePrice,
    originalPrice: originalPrice,
    discountPercent: pricing.discountPercent,
    imageUrl: detail.imageUrls.isNotEmpty ? detail.imageUrls.first : null,
    imagePlaceholderColorValue: detail.imagePlaceholderColorValue,
    discountDescription: candidate.description,
    discountStartDate: candidate.startDate,
    discountEndDate: candidate.endDate,
  );
}

ProductModel discountedProductToHomeProduct(DiscountedProductModel product) {
  return ProductModel(
    id: product.productId,
    businessId: product.businessId,
    name: product.name,
    category: product.category,
    price: product.price,
    originalPrice: product.originalPrice,
    badgeText:
        product.discountLabel.isNotEmpty ? product.discountLabel : null,
    discountPercent: product.discountPercent,
    metaText: product.businessName,
    imageUrl: product.imageUrl,
    imagePlaceholderColorValue: product.imagePlaceholderColorValue,
    iconType: _iconTypeForCategory(product.category),
  );
}

ProductDetailModel applyDiscountToProductDetail({
  required ProductDetailModel product,
  required DiscountProductCandidate candidate,
}) {
  final pricing = _applyDiscount(
    retailPrice: product.currentPrice,
    discountType: candidate.discountType,
    discountValue: candidate.discountValue,
  );

  if (pricing.discountPercent == null && pricing.salePrice >= product.currentPrice) {
    return product;
  }

  return ProductDetailModel(
    id: product.id,
    title: product.title,
    description: product.description,
    currentPrice: pricing.salePrice,
    originalPrice: product.currentPrice,
    discountPercent: pricing.discountPercent,
    discountLabel: candidate.discountLabel,
    discountDescription: candidate.description,
    discountStartDate: candidate.startDate,
    discountEndDate: candidate.endDate,
    imageUrls: product.imageUrls,
    imagePlaceholderColorValue: product.imagePlaceholderColorValue,
    isAvailable: product.isAvailable,
    stockQuantity: product.stockQuantity,
    category: product.category,
    highlightSpecs: product.highlightSpecs,
    technicalRows: product.technicalRows,
  );
}

DiscountProductCandidate? findBestDiscountForProduct({
  required List<DiscountModel> discounts,
  required int businessId,
  required String productId,
}) {
  final normalizedProductId = normalizeProductId(productId);
  final candidates = flattenDiscountProducts(discounts)
      .where(
        (candidate) =>
            candidate.businessId == businessId &&
            normalizeProductId(candidate.productId) == normalizedProductId,
      )
      .toList();
  if (candidates.isEmpty) return null;
  candidates.sort(
    (a, b) => _effectiveDiscountPercent(b.discountType, b.discountValue)
        .compareTo(_effectiveDiscountPercent(a.discountType, a.discountValue)),
  );
  return candidates.first;
}

String normalizeProductId(String id) {
  final trimmed = id.trim();
  final parsed = int.tryParse(trimmed);
  return parsed?.toString() ?? trimmed;
}

({double salePrice, int? discountPercent}) computeDiscountPricing({
  required double retailPrice,
  required String discountType,
  required double discountValue,
}) {
  final pricing = _applyDiscount(
    retailPrice: retailPrice,
    discountType: discountType,
    discountValue: discountValue,
  );
  return (
    salePrice: pricing.salePrice,
    discountPercent: pricing.discountPercent,
  );
}

Map<int, double> buildDiscountedPriceMap(List<DiscountedProductModel> products) {
  return {
    for (final product in products) int.parse(product.productId): product.price,
  };
}

OrderModel applyDiscountPricingToCart(
  OrderModel cart,
  Map<int, double> discountedPrices,
) {
  if (discountedPrices.isEmpty) return cart;

  final items = cart.items.map((item) {
    final discountedPrice = discountedPrices[item.itemId];
    if (discountedPrice == null) return item;

    final retail = double.tryParse(item.unitPrice) ?? 0;
    if (discountedPrice >= retail) return item;

    return item.copyWith(
      discountedUnitPrice: discountedPrice.toStringAsFixed(2),
    );
  }).toList();

  return cart.copyWith(items: items);
}

class _PricingResult {
  final double salePrice;
  final int? discountPercent;

  const _PricingResult({
    required this.salePrice,
    this.discountPercent,
  });
}

_PricingResult _applyDiscount({
  required double retailPrice,
  required String discountType,
  required double discountValue,
}) {
  if (retailPrice <= 0) {
    return const _PricingResult(salePrice: 0);
  }

  if (discountType == 'fixed') {
    final salePrice = (retailPrice - discountValue).clamp(0, retailPrice).toDouble();
    final percent = retailPrice == 0
        ? null
        : (((retailPrice - salePrice) / retailPrice) * 100).round();
    return _PricingResult(salePrice: salePrice, discountPercent: percent);
  }

  final percent = discountValue.round();
  final salePrice = retailPrice * (1 - (discountValue / 100));
  return _PricingResult(
    salePrice: salePrice.clamp(0, retailPrice).toDouble(),
    discountPercent: percent > 0 ? percent : null,
  );
}

double _effectiveDiscountPercent(String discountType, double discountValue) {
  if (discountType == 'fixed') return discountValue;
  return discountValue;
}

String _formatCategory(String category) {
  if (category.isEmpty) return '';
  return category
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ')
      .toUpperCase();
}

String _iconTypeForCategory(String category) {
  final normalized = category.toLowerCase();
  if (normalized.contains('invert')) return 'inverter';
  if (normalized.contains('batter')) return 'battery';
  return 'solar';
}
