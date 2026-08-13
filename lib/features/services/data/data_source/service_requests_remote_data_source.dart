import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/services/data/model/service_request_response_model.dart';
import 'package:untitled1/features/services/data/models/service_request_model.dart';

abstract class ServiceRequestsRemoteDataSource {
  Future<ServiceRequestModel> createServiceRequest(int serviceId);
  Future<List<ServiceRequestModel>> getMyServiceRequests();
}

class ServiceRequestsRemoteDataSourceImpl
    implements ServiceRequestsRemoteDataSource {
  final ApiRequest apiRequest;

  ServiceRequestsRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<ServiceRequestModel> createServiceRequest(int serviceId) async {
    try {
      final response = await apiRequest.post(
        EndPoints.serviceRequests,
        body: {'service_id': serviceId},
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
      return ServiceRequestResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      ).request;
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<List<ServiceRequestModel>> getMyServiceRequests() async {
    try {
      final response = await apiRequest.get(EndPoints.myServiceRequests);
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
      return ServiceRequestListResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      ).requests;
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
