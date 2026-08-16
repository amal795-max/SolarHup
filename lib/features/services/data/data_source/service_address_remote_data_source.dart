import '../models/service_address_model.dart';

abstract class ServiceAddressRemoteDataSource {
  Future<ServiceAddressModel> getServiceAddress(String serviceId);
}

class ServiceAddressRemoteDataSourceImpl
    implements ServiceAddressRemoteDataSource {
  const ServiceAddressRemoteDataSourceImpl();

  static final _byService = <String, ServiceAddressModel>{
    'svc-1': const ServiceAddressModel(
      serviceId: 'svc-1',
      defaultFullName: 'Johnathan Doe',
      defaultStreetAddress: '123 Solar Way',
      defaultCity: 'Palo Alto',
      defaultBuilding: '123',
      defaultFloor: '2',
      originalTotal: 1345.00,
      grandTotal: 1345.00,
    ),
    'svc-2': const ServiceAddressModel(
      serviceId: 'svc-2',
      defaultFullName: 'Johnathan Doe',
      defaultStreetAddress: '123 Solar Way',
      defaultCity: 'Palo Alto',
      defaultBuilding: '123',
      defaultFloor: '2',
      originalTotal: 1345.00,
      grandTotal: 1345.00,
    ),
    'svc-featured-1': const ServiceAddressModel(
      serviceId: 'svc-featured-1',
      defaultFullName: 'Johnathan Doe',
      defaultStreetAddress: '123 Solar Way',
      defaultCity: 'Palo Alto',
      defaultBuilding: '123',
      defaultFloor: '2',
      originalTotal: 1345.00,
      grandTotal: 1345.00,
    ),
  };

  static const _fallback = ServiceAddressModel(
    serviceId: 'svc-default',
    defaultFullName: 'Johnathan Doe',
    defaultStreetAddress: '123 Solar Way',
    defaultCity: 'Palo Alto',
    defaultBuilding: '123',
    defaultFloor: '2',
    originalTotal: 1345.00,
    grandTotal: 1345.00,
  );

  @override
  Future<ServiceAddressModel> getServiceAddress(String serviceId) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _byService[serviceId] ?? _fallback;
  }
}
