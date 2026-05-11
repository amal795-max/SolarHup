import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:kitch_plus/core/api/api_keys.dart';
import 'package:kitch_plus/core/constants/user-parameters.dart';

import '../../../../../core/api/api-requests.dart';
import '../../../../../core/errors/exceptions.dart';

abstract class ResetPasswordRemoteDataSource{
  Future<Unit> checkEmail(String email);
  Future<Unit> verifyCode(VerifyCodeParams params);
  Future<Unit> updatePassword(UpdatePasswordParams params);
}

class ResetPasswordRemoteDataSourceImpl implements ResetPasswordRemoteDataSource {
  final http.Client client;
  ApiRequest api = ApiRequest(client: http.Client());
  ResetPasswordRemoteDataSourceImpl({required this.client});


  @override
  Future<Unit> checkEmail(String email) async {
    final response = await api.post(EndPoint.checkEmail, {"email": email});
    return handleResponse(response);
  }

  @override
  Future<Unit> verifyCode(VerifyCodeParams params) async {
    final body = {
      "email": params.email,
      "code": params.code
    };
    final response = await api.post(EndPoint.verifyCode, body);
    return handleResponse(response);
  }


  @override
  Future<Unit> updatePassword(UpdatePasswordParams params) async {
    final body = {
      "email": params.email,
      "password": params.password
    };
    final response = await api.post(EndPoint.updatePassword, body);
    print("Error ${response.statusCode}: ${response.body}");
    return handleResponse(response);
  }



    handleResponse(http.Response response){
    if(response.statusCode == 200 || response.statusCode== 201){
      return Future.value(unit);
    }
    throw ServerException(message: getErrorMessage(response.statusCode));

}
}