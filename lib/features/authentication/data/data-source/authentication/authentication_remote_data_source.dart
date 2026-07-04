import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/authentication/data/model/register_model.dart';
import '../../../../../core/api/api-requests.dart';
import '../../../../../core/api/errors/exceptions.dart';
import '../../../../../core/constants/user-parameters.dart';

abstract class AuthenticationRemoteDataSource {
  Future<bool> checkPhoneNumber(String email);

  Future<RegisterModel> register(RegisterParams body);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final ApiRequest apiRequest;

  AuthenticationRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<bool> checkPhoneNumber(String phoneNumber) async {
    final response = await apiRequest.post(
      EndPoints.checkPhoneNumber,
      body: AuthenticationParams(phoneNumber).toJson(),
    );
    if (response.statusCode != 200) {
      throw ServerException(message: getErrorMessage(response.statusCode ?? 0));
    } else {
      return response.data['exists'];
    }
  }

  @override
  Future<RegisterModel> register(RegisterParams body) async{
    final response = await apiRequest.post(
      EndPoints.register,
      body: body.toJson(),
    );
    if (response.statusCode != 200) {
      throw ServerException(message: getErrorMessage(response.statusCode ?? 0));
    } else {
      return RegisterModel.fromJson(response.data);
    }
  }
}
