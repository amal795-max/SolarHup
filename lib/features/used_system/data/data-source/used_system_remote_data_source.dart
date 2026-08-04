import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';

abstract class UsedSystemRemoteDataSource {
  Future<UsedProductModel> addUsedProduct(AddUsedProductParams params);

  Future<List<UsedProductModel>> getUsedProducts(Map<String, dynamic> query);

  Future<List<UsedProductModel>> getMyUsedProducts();

  Future<void> updateProductStatus(int id, String status);

  Future<void> updateProduct(int id, AddUsedProductParams params);

  Future<void> deleteProduct(int id);
}

class UsedSystemRemoteDataSourceImpl implements UsedSystemRemoteDataSource {
  final ApiRequest apiRequest;

  UsedSystemRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<UsedProductModel> addUsedProduct(AddUsedProductParams params) async {
    try {
      final response = await apiRequest.post(
        EndPoints.usedProducts,
        body: params.toJson(),
      );
      if (response.statusCode != 201) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return UsedProductModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<List<UsedProductModel>> getUsedProducts(
    Map<String, dynamic> query,
  ) async {
    try {
      final response = await apiRequest.get(
        EndPoints.usedProducts,
        query: query,
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return (response.data['products'] as List)
            .map((item) => UsedProductModel.fromJson(item))
            .toList();
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<List<UsedProductModel>> getMyUsedProducts() async {
    try {
      final response = await apiRequest.get(EndPoints.myUsedProducts);
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return (response.data['products'] as List)
            .map((item) => UsedProductModel.fromJson(item))
            .toList();
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<void> updateProductStatus(int id, String status) async {
    try {
      final response = await apiRequest.patch(
        EndPoints.updateProductStatus(id),
        body: {'status': status},
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<void> updateProduct(int id, AddUsedProductParams params) async {
    try {
      final response = await apiRequest.patch(
        EndPoints.updateProduct(id),
        body: params.toJson(),
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      final response = await apiRequest.delete(
        EndPoints.deleteProduct(id),
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
