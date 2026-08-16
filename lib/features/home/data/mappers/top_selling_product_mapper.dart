import 'package:untitled1/features/home/data/models/product_model.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

ProductModel productDetailToHomeProduct({
  required ProductDetailModel detail,
  required int businessId,
}) {
  return ProductModel(
    id: detail.id.toString(),
    businessId: businessId,
    name: detail.title,
    category: _formatCategory(detail.category),
    price: detail.currentPrice,
    originalPrice: detail.originalPrice,
    discountPercent: detail.discountPercent,
    metaText: detail.isAvailable ? null : 'Unavailable',
    imageUrl: detail.imageUrls.isNotEmpty ? detail.imageUrls.first : null,
    imagePlaceholderColorValue: detail.imagePlaceholderColorValue,
    iconType: _iconTypeForCategory(detail.category),
  );
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
