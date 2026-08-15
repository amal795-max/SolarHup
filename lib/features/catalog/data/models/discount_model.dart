class DiscountProductInfo {
  final int id;
  final String name;
  final String category;

  const DiscountProductInfo({
    required this.id,
    required this.name,
    required this.category,
  });

  factory DiscountProductInfo.fromJson(Map<String, dynamic> json) {
    return DiscountProductInfo(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}

class DiscountModel {
  final int id;
  final int businessId;
  final String businessName;
  final String businessType;
  final String title;
  final String? description;
  final String discountType;
  final double discountValue;
  final String discountLabel;
  final double minPurchaseAmount;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<DiscountProductInfo> products;

  const DiscountModel({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.businessType,
    required this.title,
    this.description,
    required this.discountType,
    required this.discountValue,
    required this.discountLabel,
    required this.minPurchaseAmount,
    this.startDate,
    this.endDate,
    required this.products,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    final productItems = json['products'] as List<dynamic>? ?? [];
    return DiscountModel(
      id: json['id'] as int,
      businessId: json['business_id'] as int,
      businessName: json['business_name'] as String? ?? '',
      businessType: json['business_type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      discountType: json['discount_type'] as String? ?? 'percentage',
      discountValue: _parseDecimal(json['discount_value']),
      discountLabel: json['discount_label'] as String? ?? '',
      minPurchaseAmount: _parseDecimal(json['min_purchase_amount']),
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
      products: productItems
          .map(
            (item) =>
                DiscountProductInfo.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

double _parseDecimal(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
