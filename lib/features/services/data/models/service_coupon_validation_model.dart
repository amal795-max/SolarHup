class ServiceCouponValidationModel {
  final bool valid;
  final String code;
  final double originalPrice;
  final double discountAmount;
  final double finalPrice;

  const ServiceCouponValidationModel({
    required this.valid,
    required this.code,
    required this.originalPrice,
    required this.discountAmount,
    required this.finalPrice,
  });

  factory ServiceCouponValidationModel.fromJson(Map<String, dynamic> json) {
    return ServiceCouponValidationModel(
      valid: json['valid'] as bool? ?? false,
      code: json['code']?.toString() ?? '',
      originalPrice: _parseDecimal(json['original_price']),
      discountAmount: _parseDecimal(json['discount_amount']),
      finalPrice: _parseDecimal(json['final_price']),
    );
  }
}

double _parseDecimal(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
