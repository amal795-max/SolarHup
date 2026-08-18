import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/services/data/model/service_request_response_model.dart';
import 'package:untitled1/features/services/data/models/service_coupon_validation_model.dart';
import 'package:untitled1/features/services/data/models/service_request_create_payload.dart';
import 'package:untitled1/features/services/data/models/service_request_model.dart';

abstract class ServiceRequestsRemoteDataSource {
  Future<ServiceRequestModel> createServiceRequest(
    ServiceRequestCreatePayload payload,
  );
  Future<ServiceCouponValidationModel> validateCoupon({
    required int serviceId,
    required String couponCode,
  });
  Future<List<ServiceRequestModel>> getMyServiceRequests();
  Future<ServiceRequestModel> getServiceRequest(int requestId);
  Future<ServiceRequestModel> cancelServiceRequest(int requestId);
}

class ServiceRequestsRemoteDataSourceImpl
    implements ServiceRequestsRemoteDataSource {
  final ApiRequest apiRequest;

  ServiceRequestsRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<ServiceRequestModel> createServiceRequest(
    ServiceRequestCreatePayload payload,
  ) async {
    try {
      final response = await apiRequest.post(
        EndPoints.serviceRequests,
        body: payload.toJson(),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ServerException(
          message: _readErrorDetail(response) ??
              getErrorMessage(response.statusCode ?? 0),
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
  Future<ServiceCouponValidationModel> validateCoupon({
    required int serviceId,
    required String couponCode,
  }) async {
    try {
      final response = await apiRequest.post(
        EndPoints.validateCoupon,
        body: {
          'service_id': serviceId,
          'coupon_code': couponCode.trim(),
        },
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: _readErrorDetail(response) ??
              getErrorMessage(response.statusCode ?? 0),
        );
      }
      final data = response.data as Map<String, dynamic>;
      final payload = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      return ServiceCouponValidationModel.fromJson(payload);
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

  @override
  Future<ServiceRequestModel> getServiceRequest(int requestId) async {
    try {
      final response = await apiRequest.get(EndPoints.serviceRequest(requestId));
      if (response.statusCode != 200) {
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
  Future<ServiceRequestModel> cancelServiceRequest(int requestId) async {
    try {
      final response = await apiRequest.post(
        EndPoints.cancelServiceRequest(requestId),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
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
}

String? _readErrorDetail(Response<dynamic> response) {
  final data = response.data;
  if (data is Map<String, dynamic>) {
    final detail = data['detail'];
    if (detail is String && detail.trim().isNotEmpty) return detail.trim();
    if (detail is List && detail.isNotEmpty) {
      final first = detail.first;
      if (first is Map && first['msg'] != null) {
        return first['msg'].toString();
      }
    }
  }
  return null;
}
