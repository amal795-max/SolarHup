import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_images.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import '../models/product_model.dart';
import '../models/tip_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getUsedProducts();
  Future<List<TipModel>> getRandomTips();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiRequest apiRequest;

  const HomeRemoteDataSourceImpl(this.apiRequest);

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
        badgeColorValue: AppColors.lightGrey,
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
  Future<List<TipModel>> getRandomTips() async {
    try {
      final response = await apiRequest.get(EndPoints.randomTips);
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
      return parseTipsResponse(response.data);
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
