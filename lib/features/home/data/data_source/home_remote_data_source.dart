import '../../../../core/constants/app_images.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/blog_model.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getUsedProducts();
  Future<List<ProductModel>> getNewOffers();
  Future<List<BlogModel>> getBlogPosts();
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

  @override
  Future<List<ProductModel>> getNewOffers() async {
    return const [
      ProductModel(
        id: 'n1',
        name: 'SunPeak Ultra 450W Monocrystalline',
        category: 'SOLAR PANELS',
        price: 133.00,
        originalPrice: 149.00,
        discountPercent: 15,
        image: AppImages.batteryTest1,
        iconType: 'solar',
      ),
      ProductModel(
        id: 'n2',
        name: 'Hybrid Inverter',
        category: 'Hybrid inverter that combines solar and battery ',
        price: 500.00,
        originalPrice: 545.00,
        badgeText: 'Certified',
        badgeColorValue: AppColors.lightGrey,
        image: AppImages.batteryTest2,
        iconType: 'inverter',
      ),
      ProductModel(
        id: 'n3',
        name: 'EcoGen 300W Panel',
        price: 120.00,
        originalPrice: 149.00,
        discountPercent: 20,
        image: AppImages.batteryTest3,
        iconType: 'solar',
      ),
    ];
  }

  @override
  Future<List<BlogModel>> getBlogPosts() async {
    return const [
      BlogModel(
        id: 'blog-2',
        title: 'How to maximize your solar output in Winter',
        meta: '5 min read • Solar Tips',
        imagePlaceholderColorValue: 0xFF4A7B9D,
        iconType: 'sun',
      ),
      BlogModel(
        id: 'blog-1',
        title: 'Government Rebates: What you need to know',
        meta: '8 min read • Finance',
        imagePlaceholderColorValue: 0xFF7B6241,
        iconType: 'finance',
      ),
    ];
  }
}
