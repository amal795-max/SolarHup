import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

abstract class ProductDetailRemoteDataSource {
  Future<ProductDetailModel> getProductDetail(String productId);
}

class ProductDetailRemoteDataSourceImpl implements ProductDetailRemoteDataSource {
  const ProductDetailRemoteDataSourceImpl();

  static const _mockProducts = <String, ProductDetailModel>{
    'helios-450w': ProductDetailModel(
      id: 'helios-450w',
      title: 'Helios X-Series 450W',
      description:
          'Monocrystalline High-Efficiency Solar Panel with Advanced PERC Technology.',
      currentPrice: 349.00,
      originalPrice: 420.00,
      rating: 4.9,
      reviewCount: 124,
      isBestseller: true,
      imagePlaceholderColors: [
        0xFF2D5C86,
        0xFF1E4A6E,
        0xFF3A6F9A,
        0xFF254F75,
      ],
      coreSpecs: ProductCoreSpecs(
        maxPowerOutput: '450 Watts',
        efficiency: '22.4%',
        warranty: '25 yrs',
        brand: 'Solar Power Supply',
        cellTechnology: 'N-Type Monocrystalline',
      ),
      technicalData: ProductTechnicalData(
        weight: '22.0 kg (48.5 lbs)',
        dimensions: '1903 × 1134 × 30 mm',
        connectors: 'MC4 Compatible',
        maxSystemVoltage: '1500V DC',
        operatingTemp: '-40°C to +85°C',
        material: 'plastic, canvas',
        outputType: 'MC4 port',
      ),
      reviews: [
        ProductReviewModel(
          id: 'review-1',
          userName: 'James D.',
          userInitials: 'JD',
          isVerifiedBuyer: true,
          dateAgo: '2 days ago',
          rating: 5,
          body:
              'Installed 12 of these panels last month. The build quality is exceptional and I\'m consistently seeing peak power output even on slightly hazy days.',
        ),
        ProductReviewModel(
          id: 'review-2',
          userName: 'Maria W.',
          userInitials: 'MW',
          isVerifiedBuyer: true,
          dateAgo: '1 week ago',
          rating: 5,
          body:
              'Excellent panel for residential installs. Easy to mount and the efficiency rating holds up in real-world conditions.',
        ),
      ],
    ),
  };

  @override
  Future<ProductDetailModel> getProductDetail(String productId) async {
    // TODO: Replace with real API call via Dio
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final product = _mockProducts[productId];
    if (product != null) return product;

    return _mockProducts['helios-450w']!;
  }
}
