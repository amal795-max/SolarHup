import '../models/package_comparison_model.dart';

abstract class PackageComparisonRemoteDataSource {
  Future<PackageComparisonModel> getPackageComparison();
}

class PackageComparisonRemoteDataSourceImpl
    implements PackageComparisonRemoteDataSource {
  const PackageComparisonRemoteDataSourceImpl();

  static const _comparison = PackageComparisonModel(
    starter: SolarPackageModel(
      id: 'pkg-starter',
      name: 'Home Starter Pack',
      tier: SolarPackageTier.basic,
      price: 4299,
      imageUrl:
          'https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=600&q=80',
      imageColorValue: 0xFF3A5F7A,
      totalOutput: '3kW',
      storage: '5kWh',
      panelsCount: '8',
      warranty: '10yr',
      efficiencyRating: 3,
    ),
    premium: SolarPackageModel(
      id: 'pkg-premium',
      name: 'Premium Energy Hub',
      tier: SolarPackageTier.premium,
      price: 12450,
      imageUrl:
          'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=600&q=80',
      imageColorValue: 0xFF1A3A5C,
      isPopular: true,
      totalOutput: '10kW',
      storage: '15kWh',
      panelsCount: '24',
      warranty: '25yr',
      efficiencyRating: 5,
    ),
  );

  @override
  Future<PackageComparisonModel> getPackageComparison() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _comparison;
  }
}
