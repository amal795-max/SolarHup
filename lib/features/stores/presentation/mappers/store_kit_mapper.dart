import 'package:untitled1/features/stores/data/models/store_product_model.dart';
import 'package:untitled1/features/stores/presentation/pages/store_kit_screen.dart';

List<StoreKitProductData> storeProductsToKitData(
  List<StoreProductModel> products,
) {
  return products.map(_toKitProduct).toList();
}

StoreKitProductData _toKitProduct(StoreProductModel product) {
  return StoreKitProductData(
    id: product.id,
    businessId: product.businessId,
    categoryKey: _categoryKey(product.category, product.categoryId),
    name: product.name,
    price: product.price,
    rating: 0,
    reviews: product.quantity,
    imageColorValue: product.imagePlaceholderColorValue,
    imageUrl: product.imageUrl,
  );
}

String _categoryKey(String category, int categoryId) {
  final normalized = category.toLowerCase();
  if (normalized.contains('panel')) return 'panels';
  if (normalized.contains('batter')) return 'batteries';
  if (normalized.contains('invert')) return 'inverters';
  return switch (categoryId % 3) {
    1 => 'panels',
    2 => 'batteries',
    _ => 'panels',
  };
}
