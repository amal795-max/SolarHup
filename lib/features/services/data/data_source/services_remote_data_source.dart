import '../models/expert_service_model.dart';

abstract class ServicesRemoteDataSource {
  Future<ServicesFeedModel> getServicesFeed();
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  const ServicesRemoteDataSourceImpl();

  static const _services = [
    ExpertServiceModel(
      id: 'svc-1',
      title: 'Annual System Health Audit',
      rating: 4.8,
      badges: ['NABCEP', 'ELECTRICAL SAFETY'],
      price: 150,
      durationLabel: '2h est.',
      categoryKey: 'maintenance',
      imagePlaceholderColorValue: 0xFFDCE4EA,
      iconType: 'audit',
    ),
    ExpertServiceModel(
      id: 'svc-2',
      title: 'Emergency Inverter Repair',
      rating: 4.7,
      badges: ['MASTER ELECTRICIAN'],
      price: 200,
      durationLabel: '3h est.',
      categoryKey: 'maintenance',
      imagePlaceholderColorValue: 0xFFE2E8EE,
      iconType: 'repair',
    ),
  ];

  static const _featured = ExpertServiceModel(
    id: 'svc-featured-1',
    title: 'Premium Installation Kit',
    rating: 0,
    badges: [],
    price: 50,
    durationLabel: '',
    categoryKey: 'installation',
    imagePlaceholderColorValue: 0xFF0A2A43,
    iconType: 'installation',
    isFeatured: true,
    description:
        'Full system deployment including storage batteries and smart monitoring integration.',
  );

  @override
  Future<ServicesFeedModel> getServicesFeed() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const ServicesFeedModel(
      services: _services,
      featured: _featured,
    );
  }
}
