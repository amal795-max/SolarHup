import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/features/services/data/models/booking_confirmation_model.dart';
import 'package:untitled1/features/services/data/models/service_request_create_payload.dart';

class ServiceBookingDraft {
  final int serviceId;
  final String serviceName;
  final double servicePrice;
  final DateTime? selectedDate;
  final String? selectedTimeSlotId;
  final String? selectedTimeLabel;
  final String? note;
  final String? fullName;
  final String? street;
  final String? city;
  final String? building;
  final String? floor;

  const ServiceBookingDraft({
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    this.selectedDate,
    this.selectedTimeSlotId,
    this.selectedTimeLabel,
    this.note,
    this.fullName,
    this.street,
    this.city,
    this.building,
    this.floor,
  });

  bool get hasSchedule =>
      selectedDate != null &&
      selectedTimeSlotId != null &&
      selectedTimeSlotId!.isNotEmpty;

  bool get hasRequiredAddress {
    final name = fullName?.trim() ?? '';
    final streetValue = street?.trim() ?? '';
    final cityValue = city?.trim() ?? '';
    final buildingValue = building?.trim() ?? '';
    return name.isNotEmpty &&
        streetValue.isNotEmpty &&
        cityValue.isNotEmpty &&
        buildingValue.isNotEmpty;
  }

  ServiceBookingDraft copyWith({
    int? serviceId,
    String? serviceName,
    double? servicePrice,
    DateTime? selectedDate,
    String? selectedTimeSlotId,
    String? selectedTimeLabel,
    String? note,
    String? fullName,
    String? street,
    String? city,
    String? building,
    String? floor,
  }) {
    return ServiceBookingDraft(
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      servicePrice: servicePrice ?? this.servicePrice,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlotId: selectedTimeSlotId ?? this.selectedTimeSlotId,
      selectedTimeLabel: selectedTimeLabel ?? this.selectedTimeLabel,
      note: note ?? this.note,
      fullName: fullName ?? this.fullName,
      street: street ?? this.street,
      city: city ?? this.city,
      building: building ?? this.building,
      floor: floor ?? this.floor,
    );
  }

  ServiceRequestCreatePayload toPayload() {
    return ServiceRequestCreatePayload(
      serviceId: serviceId,
      fullName: fullName!.trim(),
      city: city!.trim(),
      street: street!.trim(),
      building: building!.trim(),
      date: DataHelper.dateFormat('yyyy-MM-dd',selectedDate!,locale:const Locale('en')),
      time: _formatApiTime(selectedTimeSlotId!),
      floor: floor?.trim(),
      note: note?.trim(),
    );
  }

  Map<String, dynamic> toRequestBody() => toPayload().toJson();

  String get formattedAddress {
    final parts = <String>[
      street?.trim() ?? '',
      if ((building?.trim() ?? '').isNotEmpty) 'Bldg ${building!.trim()}',
      if ((floor?.trim() ?? '').isNotEmpty) 'Floor ${floor!.trim()}',
      city?.trim() ?? '',
    ].where((part) => part.isNotEmpty);
    return parts.join(', ');
  }

  String get formattedDateTime {
    if (selectedDate == null) return '';
    final dateLabel = DateFormat('MMM d, yyyy').format(selectedDate!);
    final timeLabel = selectedTimeLabel?.trim();
    if (timeLabel == null || timeLabel.isEmpty) return dateLabel;
    return '$dateLabel • $timeLabel';
  }

  BookingConfirmationModel toConfirmation({
    required String orderCode,
  }) {
    return BookingConfirmationModel(
      bookingId: orderCode,
      serviceId: serviceId.toString(),
      serviceType: serviceName,
      dateTimeLabel: formattedDateTime,
      technician: const BookingTechnicianModel(
        name: 'Pending assignment',
      ),
      address: formattedAddress,
    );
  }

  static String _formatApiTime(String slotId) {
    final parts = slotId.split('-');
    if (parts.length == 2) {
      final hour = parts[0].padLeft(2, '0');
      final minute = parts[1].padLeft(2, '0');
      return '$hour:$minute:00';
    }
    return '09:00:00';
  }
}
