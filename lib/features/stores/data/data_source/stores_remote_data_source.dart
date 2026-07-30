import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/stores/data/model/store_list_response_model.dart';
import 'package:untitled1/features/stores/data/models/store_model.dart';

abstract class StoresRemoteDataSource {
  Future<List<StoreModel>> getStores({String? region});
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
}
