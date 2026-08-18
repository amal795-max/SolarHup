class DiscountedProductModel {
  final String productId;
  final int businessId;
  final int? promotionId;
  final String name;
  final String category;
  final String businessName;
  final String discountLabel;
  final double price;
  final double originalPrice;
  final int? discountPercent;
  final String? imageUrl;
  final int imagePlaceholderColorValue;
  final String? discountDescription;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;

  const DiscountedProductModel({
    required this.productId,
    required this.businessId,
    this.promotionId,
    required this.name,
    required this.category,
    required this.businessName,
    required this.discountLabel,
    required this.price,
    required this.originalPrice,
    this.discountPercent,
    this.imageUrl,
    required this.imagePlaceholderColorValue,
    this.discountDescription,
    this.discountStartDate,
    this.discountEndDate,
  });
}
