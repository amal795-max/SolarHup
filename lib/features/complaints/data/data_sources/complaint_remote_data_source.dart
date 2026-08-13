import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/features/complaints/data/models/complaint_model.dart';

abstract class ComplaintRemoteDataSource {
  Future<List<ComplaintModel>> getMyComplaints();
  Future<ComplaintModel> getComplaintDetails(int id);
  Future<ComplaintModel> createComplaint(AddComplaintParams params);
  Future<ComplaintModel> sendMessage({
    required int complaintId,
    required String message,
  });
}

class ComplaintRemoteDataSourceImpl implements ComplaintRemoteDataSource {
  final ApiRequest apiRequest;

  ComplaintRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<List<ComplaintModel>> getMyComplaints() async {
    try {
      final response = await apiRequest.get(EndPoints.myComplaints);
      if (response.statusCode != 200) {
        throw ServerException(message: getErrorMessage(response.statusCode ?? 0));
      }
      return ComplaintResponseModel.fromJson(response.data).complaints;
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<ComplaintModel> getComplaintDetails(int id) async {
    try {
      final response = await apiRequest.get(EndPoints.complaintDetails(id));
      if (response.statusCode != 200) {
        throw ServerException(message: getErrorMessage(response.statusCode ?? 0));
      }
      return ComplaintModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<ComplaintModel> createComplaint(AddComplaintParams params) async {
    try {
      final response = await apiRequest.post(
        EndPoints.complaints,
        body:params.toJson()
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: getErrorMessage(response.statusCode ?? 0));
      }
      return ComplaintModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<ComplaintModel> sendMessage({
    required int complaintId,
    required String message,
  }) async {
    try {
      final response = await apiRequest.post(
        '${EndPoints.complaints}/$complaintId/replies',
        body: {'message': message},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: getErrorMessage(response.statusCode ?? 0));
      }
      return ComplaintModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
