import 'package:untitled1/core/enums/order_status_enum.dart';

class BookingTechnicianModel {
  final String name;
  final String? avatarUrl;
  final int avatarColorValue;

  const BookingTechnicianModel({
    required this.name,
    this.avatarUrl,
    this.avatarColorValue = 0xFF7592B0,
  });
}

class BookingConfirmationModel {
  final String bookingId;
  final String serviceId;
  final String serviceType;
  final String dateTimeLabel;
  final BookingTechnicianModel technician;
  final String address;
  final OrderStatusEnum statusEnum;
  final String? statusLabel;
  final double? originalPrice;
  final double? finalPrice;
  final double? discountAmount;
  final String? couponCode;
  final int? requestId;
  final int? businessId;

  const BookingConfirmationModel({
    required this.bookingId,
    required this.serviceId,
    required this.serviceType,
    required this.dateTimeLabel,
    required this.technician,
    required this.address,
    this.statusLabel,
    required this.statusEnum,
    this.originalPrice,
    this.finalPrice,
    this.discountAmount,
    this.couponCode,
    this.requestId,
    this.businessId,
  });

  bool get isCompleted => statusEnum == OrderStatusEnum.completed;

  bool get canCancel => statusEnum == OrderStatusEnum.pending;

  bool get hasDiscount =>
      (discountAmount ?? 0) > 0 &&
      resolvedOriginalPrice > resolvedFinalPrice;

  bool get hasCouponDiscount => hasDiscount;

  double get resolvedOriginalPrice =>
      originalPrice ?? finalPrice ?? 0;

  double get resolvedFinalPrice =>
      finalPrice ?? originalPrice ?? 0;
}
