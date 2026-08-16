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
  final String? receiptUrl;
  final OrderStatusEnum statusEnum;
  final String? statusLabel;
  final double? originalPrice;
  final double? finalPrice;
  final double? discountAmount;
  final String? couponCode;

  const BookingConfirmationModel({
    required this.bookingId,
    required this.serviceId,
    required this.serviceType,
    required this.dateTimeLabel,
    required this.technician,
    required this.address,
    this.receiptUrl,
    this.statusLabel,
    required this.statusEnum,
    this.originalPrice,
    this.finalPrice,
    this.discountAmount,
    this.couponCode,
  });

  bool get hasCouponDiscount =>
      (discountAmount ?? 0) > 0 &&
      originalPrice != null &&
      finalPrice != null &&
      originalPrice! > finalPrice!;
}
