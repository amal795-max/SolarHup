import 'package:dio/dio.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/authentication/data/model/login_model.dart';
import 'package:untitled1/features/authentication/data/model/register_model.dart';
import '../../../../../core/api/api-requests.dart';
import '../../../../../core/api/errors/exceptions.dart';
import '../../../../../core/constants/user-parameters.dart';

abstract class AuthenticationRemoteDataSource {
  Future<bool> checkPhoneNumber(String email);
  Future<RegisterModel> register(RegisterParams body);
  Future<LoginModel> login(LoginParams body);
}

class AuthenticationRemoteDataSourceImpl implements AuthenticationRemoteDataSource {
  final ApiRequest apiRequest;

  AuthenticationRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<bool> checkPhoneNumber(String phoneNumber) async {
    try {
      final response = await apiRequest.post(
        EndPoints.checkPhoneNumber,
        body: AuthenticationParams(phoneNumber).toJson(),
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return response.data['exists'];
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<RegisterModel> register(RegisterParams body) async {
    try {
      final response = await apiRequest.post(
        EndPoints.register,
        body: body.toJson(),
      );
      if (response.statusCode != 201) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return RegisterModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<LoginModel> login(LoginParams body) async{
    try {
      final response = await apiRequest.post(
        EndPoints.login,
        body: body.toJson(),
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return LoginModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

}
