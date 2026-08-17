import 'package:easy_localization/easy_localization.dart';
import 'package:untitled1/core/enums/order_status_enum.dart';
import 'package:untitled1/features/services/data/models/booking_confirmation_model.dart';

class ServiceRequestModel {
  final int id;
  final String orderCode;
  final int businessId;
  final String status;
  final OrderStatusEnum statusEnum;
  final String totalAmount;
  final String serviceName;
  final DateTime createdAt;
  final String? customerName;
  final String? locationFullName;
  final String? locationCity;
  final String? locationStreet;
  final String? locationBuilding;
  final String? locationFloor;
  final String? serviceDate;
  final String? serviceTime;
  final String? serviceNote;
  final String? discountAmount;
  final String? couponCode;
  final String? unitPrice;

  const ServiceRequestModel({
    required this.id,
    required this.orderCode,
    required this.businessId,
    required this.status,
    required this.statusEnum,
    required this.totalAmount,
    required this.serviceName,
    required this.createdAt,
    this.customerName,
    this.locationFullName,
    this.locationCity,
    this.locationStreet,
    this.locationBuilding,
    this.locationFloor,
    this.serviceDate,
    this.serviceTime,
    this.serviceNote,
    this.discountAmount,
    this.couponCode,
    this.unitPrice,
  });

  double get parsedTotalAmount => double.tryParse(totalAmount) ?? 0;

  double get parsedDiscountAmount =>
      double.tryParse(discountAmount ?? '') ?? 0;

  double get originalPriceValue {
    final unit = double.tryParse(unitPrice ?? '');
    if (unit != null && unit > 0) return unit;

    final discount = parsedDiscountAmount;
    final total = parsedTotalAmount;
    if (discount > 0) return total + discount;
    return total;
  }

  double get finalPriceValue => parsedTotalAmount;

  bool get hasDiscount =>
      parsedDiscountAmount > 0 && originalPriceValue > finalPriceValue;

  bool get isPending =>
      status == 'pending_approval' || status == 'pending';

  bool get isCompleted => statusEnum == OrderStatusEnum.completed;

  bool get canCancel => isPending;

  String get displayDate {
    final date = serviceDate?.trim();
    if (date != null && date.isNotEmpty) {
      final parsed = DateTime.tryParse(date) ?? DateTime.tryParse('${date}T00:00:00');
      if (parsed != null) {
        return DateFormat('MMM d, yyyy').format(parsed);
      }
      return date;
    }
    return DateFormat('MMM d, yyyy').format(createdAt);
  }

  String get displayTime {
    final time = _formatDisplayTime(serviceTime);
    return time ?? DateFormat('hh:mm a').format(createdAt);
  }

  String get formattedAddress {
    final parts = <String>[
      if ((locationStreet?.trim() ?? '').isNotEmpty) locationStreet!.trim(),
      if ((locationBuilding?.trim() ?? '').isNotEmpty)
        'Bldg ${locationBuilding!.trim()}',
      if ((locationFloor?.trim() ?? '').isNotEmpty)
        'Floor ${locationFloor!.trim()}',
      if ((locationCity?.trim() ?? '').isNotEmpty) locationCity!.trim(),
    ];
    return parts.join(', ');
  }

  String get formattedDateTime {
    final date = serviceDate?.trim();
    if (date == null || date.isEmpty) {
      return DateFormat('MMM d, yyyy').format(createdAt);
    }

    DateTime? parsedDate = DateTime.tryParse(date);
    parsedDate ??= DateTime.tryParse('${date}T00:00:00');
    final dateLabel = parsedDate != null
        ? DateFormat('MMM d, yyyy').format(parsedDate)
        : date;

    final time = _formatDisplayTime(serviceTime);
    if (time == null) return dateLabel;
    return '$dateLabel • $time';
  }

  String get formattedStatus =>
      status.replaceAll('_', ' ').toUpperCase();

  BookingConfirmationModel toBookingConfirmation() {
    return BookingConfirmationModel(
      bookingId: orderCode,
      serviceId: id.toString(),
      serviceType: serviceName.isNotEmpty ? serviceName : orderCode,
      dateTimeLabel: formattedDateTime,
      technician: const BookingTechnicianModel(
        name: 'Pending assignment',
      ),
      address: formattedAddress.isNotEmpty
          ? formattedAddress
          : 'Address not available',
      statusLabel: formattedStatus,
      statusEnum: statusEnum,
      requestId: id,
      originalPrice: originalPriceValue,
      finalPrice: finalPriceValue,
      discountAmount: hasDiscount ? parsedDiscountAmount : null,
      couponCode: couponCode?.trim().isNotEmpty == true ? couponCode!.trim() : null,
      businessId: businessId,
    );
  }

  static String? _formatDisplayTime(String? rawTime) {
    final value = rawTime?.trim();
    if (value == null || value.isEmpty) return null;

    final parts = value.split(':');
    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      return DateFormat('hh:mm a').format(
        DateTime(2000, 1, 1, hour, minute),
      );
    }
    return value;
  }
}
