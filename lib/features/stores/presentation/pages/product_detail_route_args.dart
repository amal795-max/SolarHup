class ProductDetailRouteArgs {
  final int businessId;
  final String productId;
  final String? storeName;

  const ProductDetailRouteArgs({
    required this.businessId,
    required this.productId,
    this.storeName,
  });
}
