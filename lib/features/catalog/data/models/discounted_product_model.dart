class DiscountedProductModel {
  final String productId;
  final String businessId;
  final String name;
  final String category;
  final String businessName;
  final String discountLabel;
  final double price;
  final double originalPrice;
  final int? discountPercent;
  final String? imageUrl;
  final int imagePlaceholderColorValue;

  const DiscountedProductModel({
    required this.productId,
    required this.businessId,
    required this.name,
    required this.category,
    required this.businessName,
    required this.discountLabel,
    required this.price,
    required this.originalPrice,
    this.discountPercent,
    this.imageUrl,
    required this.imagePlaceholderColorValue,
  });
}
