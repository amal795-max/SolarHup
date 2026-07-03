class ServiceAddressModel {
  final String serviceId;
  final String defaultFullName;
  final String defaultStreetAddress;
  final String defaultCity;
  final String defaultBuilding;
  final String defaultFloor;
  final double grandTotal;

  const ServiceAddressModel({
    required this.serviceId,
    required this.defaultFullName,
    required this.defaultStreetAddress,
    required this.defaultCity,
    required this.defaultBuilding,
    required this.defaultFloor,
    required this.grandTotal,
  });
}
