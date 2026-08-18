/// Shared-element hero tag for product list → detail image transitions.
String? productHeroTag(Object? productId) {
  if (productId == null) return null;
  final normalized = productId.toString().trim();
  if (normalized.isEmpty || normalized == '0') return null;
  return 'product_$normalized';
}
