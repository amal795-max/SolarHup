class ServiceAddressModel {
  final String serviceId;
  final String defaultFullName;
  final String defaultStreetAddress;
  final String defaultCity;
  final String defaultBuilding;
  final String defaultFloor;
  final double originalTotal;
  final double grandTotal;
  final double discountAmount;
  final String? appliedCouponCode;

  const ServiceAddressModel({
    required this.serviceId,
    required this.defaultFullName,
    required this.defaultStreetAddress,
    required this.defaultCity,
    required this.defaultBuilding,
    required this.defaultFloor,
    required this.originalTotal,
    required this.grandTotal,
    this.discountAmount = 0,
    this.appliedCouponCode,
  });

  bool get hasCouponDiscount =>
      appliedCouponCode != null &&
      appliedCouponCode!.isNotEmpty &&
      discountAmount > 0;

  ServiceAddressModel copyWith({
    String? serviceId,
    String? defaultFullName,
    String? defaultStreetAddress,
    String? defaultCity,
    String? defaultBuilding,
    String? defaultFloor,
    double? originalTotal,
    double? grandTotal,
    double? discountAmount,
    String? appliedCouponCode,
    bool clearAppliedCouponCode = false,
  }) {
    return ServiceAddressModel(
      serviceId: serviceId ?? this.serviceId,
      defaultFullName: defaultFullName ?? this.defaultFullName,
      defaultStreetAddress: defaultStreetAddress ?? this.defaultStreetAddress,
      defaultCity: defaultCity ?? this.defaultCity,
      defaultBuilding: defaultBuilding ?? this.defaultBuilding,
      defaultFloor: defaultFloor ?? this.defaultFloor,
      originalTotal: originalTotal ?? this.originalTotal,
      grandTotal: grandTotal ?? this.grandTotal,
      discountAmount: discountAmount ?? this.discountAmount,
      appliedCouponCode: clearAppliedCouponCode
          ? null
          : (appliedCouponCode ?? this.appliedCouponCode),
    );
  }
}
