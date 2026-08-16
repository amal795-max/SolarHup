class ServiceRequestCreatePayload {
  final int serviceId;
  final String fullName;
  final String city;
  final String street;
  final String building;
  final String date;
  final String time;
  final String? floor;
  final String? note;
  final String? couponCode;

  const ServiceRequestCreatePayload({
    required this.serviceId,
    required this.fullName,
    required this.city,
    required this.street,
    required this.building,
    required this.date,
    required this.time,
    this.floor,
    this.note,
    this.couponCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'full_name': fullName,
      'city': city,
      'street': street,
      'building': building,
      'date': date,
      'time': time,
      if (floor != null && floor!.trim().isNotEmpty) 'floor': floor!.trim(),
      if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
      if (couponCode != null && couponCode!.trim().isNotEmpty)
        'coupon_code': couponCode!.trim(),
    };
  }
}
