import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/api/api_response_utils.dart';
import 'package:untitled1/features/stores/data/model/store_products_response_model.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';

abstract class ProductDetailRemoteDataSource {
  Future<ProductDetailModel> getProductDetail({
    required String businessId,
    required String productId,
  });
}

class ProductDetailRemoteDataSourceImpl implements ProductDetailRemoteDataSource {
  final ApiRequest apiRequest;

  ProductDetailRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<ProductDetailModel> getProductDetail({
    required String businessId,
    required String productId,
  }) async {
    try {
      final response = await apiRequest.get(
        EndPoints.storeProduct(businessId, productId),
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return StoreProductApiModel.fromJson(
          unwrapProductPayload(response.data as Map<String, dynamic>),
        ).toProductDetailModel();
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
