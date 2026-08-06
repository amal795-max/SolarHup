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
    categoryId: product.categoryId,
    categoryKey: product.category,
    name: product.name,
    price: product.price,
    rating: 0,
    reviews: product.quantity,
    imageColorValue: product.imagePlaceholderColorValue,
    imageUrl: product.imageUrl,
  );
}
