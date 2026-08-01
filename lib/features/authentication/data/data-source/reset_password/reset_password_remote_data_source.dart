import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/constants/user-parameters.dart';

abstract class ResetPasswordRemoteDataSource {
  Future<Unit> setNewPassword(ResetPasswordParams body);
  Future<Unit> changePassword(ChangePasswordParams body);
  Future<Unit> otpVerification(OtpParams body);
  Future<Unit> confirmOtp(ConfirmOtpParams body);
}

class ResetPasswordRemoteDataSourceImpl implements ResetPasswordRemoteDataSource {
  final ApiRequest apiRequest;

  ResetPasswordRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<Unit> setNewPassword(ResetPasswordParams body) async {
    try {
      final response = await apiRequest.post(
        EndPoints.setNewPassword,
        body: body.toJson(),
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return unit;
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
  @override
  Future<Unit> changePassword(ChangePasswordParams body) async {
    try {
      final response = await apiRequest.put(
        EndPoints.changePassword,
        body: body.toJson(),
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0,message: 'incorrect_password'),
        );
      } else {
        return unit;
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<Unit> otpVerification(OtpParams body) async{
    try {
      final response = await apiRequest.post(
        EndPoints.otpVerification,
        body: body.toJson(),
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0,message: response.data['detail']),
        );
      } else {
        return unit;
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<Unit> confirmOtp(ConfirmOtpParams body) async{
    try {
      final response = await apiRequest.post(
        EndPoints.confirmOtp,
        body: body.toJson(),
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0,message: 'error_otp'),
        );
      } else {
        return unit;
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
