class ServiceRequestModel {
  final int id;
  final String orderCode;
  final int businessId;
  final String status;
  final String totalAmount;
  final String serviceName;
  final DateTime createdAt;

  const ServiceRequestModel({
    required this.id,
    required this.orderCode,
    required this.businessId,
    required this.status,
    required this.totalAmount,
    required this.serviceName,
    required this.createdAt,
  });
}
