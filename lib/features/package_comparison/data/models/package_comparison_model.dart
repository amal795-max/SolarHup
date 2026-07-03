enum SolarPackageTier { basic, premium }

class SolarPackageModel {
  final String id;
  final String name;
  final SolarPackageTier tier;
  final double price;
  final String? imageUrl;
  final int imageColorValue;
  final bool isPopular;
  final String totalOutput;
  final String storage;
  final String panelsCount;
  final String warranty;
  final double efficiencyRating;

  const SolarPackageModel({
    required this.id,
    required this.name,
    required this.tier,
    required this.price,
    required this.totalOutput,
    required this.storage,
    required this.panelsCount,
    required this.warranty,
    required this.efficiencyRating,
    this.imageUrl,
    this.imageColorValue = 0xFF2D5C86,
    this.isPopular = false,
  });
}

class PackageComparisonModel {
  final SolarPackageModel starter;
  final SolarPackageModel premium;

  const PackageComparisonModel({
    required this.starter,
    required this.premium,
  });
}
