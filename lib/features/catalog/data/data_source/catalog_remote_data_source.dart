import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/catalog/data/model/discount_list_response_model.dart';
import 'package:untitled1/features/catalog/data/models/discount_model.dart';

abstract class CatalogRemoteDataSource {
  Future<List<DiscountModel>> getDiscounts({String? businessType});
  Future<List<DiscountModel>> getStoreDiscounts(int businessId);
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  final ApiRequest apiRequest;

  CatalogRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<List<DiscountModel>> getDiscounts({String? businessType}) async {
    try {
      final response = await apiRequest.get(
        EndPoints.discounts,
        query: businessType == null || businessType.isEmpty
            ? null
            : {'business_type': businessType},
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
      return DiscountListResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      ).discounts;
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<List<DiscountModel>> getStoreDiscounts(int businessId) async {
    try {
      final response = await apiRequest.get(EndPoints.storeDiscounts(businessId));
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
      return DiscountListResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      ).discounts;
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
