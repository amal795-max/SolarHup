import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_images.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';
import '../models/home_layout_model.dart';
import '../models/tip_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<UsedProductModel>> getUsedProducts();

  Future<List<TipModel>> getRandomTips();

  Future<List<HomeLayoutModel>> getHomeLayout();

  Future<List<UsedProductModel>> getTopSellingProducts();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiRequest apiRequest;

  const HomeRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<List<HomeLayoutModel>> getHomeLayout() async {
    try {
      final response = await apiRequest.get(EndPoints.homeLayout);
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
      final List data = response.data['sections'];
      return data.map((json) => HomeLayoutModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<List<UsedProductModel>> getUsedProducts() async {
    try {
      final response = await apiRequest.get(EndPoints.usedProducts);
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
      final List data = response.data['products'] ?? [];

      return data.map((json) => UsedProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<List<UsedProductModel>> getTopSellingProducts() async {
    final response = await apiRequest.get(
      EndPoints.topSellingProducts,
      query: {'limit': 10},
    );

    final List data = response.data['products'] ?? [];

    return data.map((json) => UsedProductModel.fromJson(json)).toList();
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
