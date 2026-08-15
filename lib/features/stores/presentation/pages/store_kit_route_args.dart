class StoreKitRouteArgs {
  final int storeId;
  final String storeName;
  final int? initialCategoryIndex;

  const StoreKitRouteArgs({
    required this.storeId,
    required this.storeName,
    this.initialCategoryIndex,
  });
}
