import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/stores/data/model/store_categories_response_model.dart';
import 'package:untitled1/features/stores/data/model/store_list_response_model.dart';
import 'package:untitled1/features/stores/data/model/store_products_response_model.dart';
import 'package:untitled1/features/stores/data/models/store_category_model.dart';
import 'package:untitled1/features/stores/data/models/store_detail_model.dart';
import 'package:untitled1/features/stores/data/models/store_model.dart';
import 'package:untitled1/features/stores/data/models/store_product_model.dart';

abstract class StoresRemoteDataSource {
  Future<List<StoreModel>> getStores({String? region});
  Future<StoreDetailModel> getStore(int businessId);
  Future<List<StoreCategoryModel>> getStoreCategories();
  Future<List<StoreProductModel>> getStoreProducts(
    int businessId, {
    int? categoryId,
  });
}

class StoresRemoteDataSourceImpl implements StoresRemoteDataSource {
  final ApiRequest apiRequest;

  StoresRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<List<StoreModel>> getStores({String? region}) async {
    try {
      final response = await apiRequest.get(
        EndPoints.stores,
        query: region == null || region.isEmpty ? null : {'region': region},
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return StoreListResponseModel.fromJson(response.data).toStoreModels();
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<StoreDetailModel> getStore(int businessId) async {
    try {
      final response = await apiRequest.get(EndPoints.store(businessId));
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return StoreDetailModel.fromApi(
          StoreApiModel.fromJson(response.data as Map<String, dynamic>),
        );
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<List<StoreCategoryModel>> getStoreCategories() async {
    try {
      final response = await apiRequest.get(
        EndPoints.storeCategories,
        query: const {'type': 'store'},
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return StoreCategoriesResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        ).toStoreCategoryModels();
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<List<StoreProductModel>> getStoreProducts(
    int businessId, {
    int? categoryId,
  }) async {
    try {
      final response = await apiRequest.get(
        EndPoints.storeProducts(businessId),
        query: categoryId == null ? null : {'category_id': categoryId},
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return StoreProductsResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        ).toStoreProductModels();
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
