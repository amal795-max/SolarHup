import '../../../../core/constants/app_images.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getUsedProducts();
}

/// Mock implementation — replace bodies with real API calls when backend is ready.
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl();

  @override
  Future<List<ProductModel>> getUsedProducts() async {
    return const [
      ProductModel(
        id: 'u1',
        name: 'EcoGen 300W Panel',
        price: 149.00,
        badgeText: 'Refurbished',
        badgeColorValue: AppColors.secondaryColor,
        metaText: 'Used • Grade A',
        image: AppImages.batteryTest2,
        iconType: 'solar',
      ),
      ProductModel(
        id: 'u2',
        name: 'Hybrid Inv...',
        price: 680.00,
        badgeText: 'Certified',
        badgeColorValue:AppColors.lightGrey,
        image: AppImages.batteryTest1,
        iconType: 'inverter',
      ),
      ProductModel(
        id: 'u3',
        name: 'EcoGen 300W Panel',
        price: 149.00,
        badgeText: 'Refurbished',
        badgeColorValue: AppColors.secondaryColor,
        metaText: 'Used • Grade A',
        image: AppImages.batteryTest3,
        iconType: 'solar',
      ),
    ];
  }
}
