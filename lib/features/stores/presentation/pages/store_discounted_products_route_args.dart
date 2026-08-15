import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';

class StoreDiscountedProductsRouteArgs {
  final int storeId;
  final String storeName;
  final List<StoreProductItem> products;

  const StoreDiscountedProductsRouteArgs({
    required this.storeId,
    required this.storeName,
    required this.products,
  });
}
