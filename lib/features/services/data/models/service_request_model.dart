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
  });

  bool get isPending =>
      status == 'pending_approval' || status == 'pending';

  bool get canCancel => isPending;

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
