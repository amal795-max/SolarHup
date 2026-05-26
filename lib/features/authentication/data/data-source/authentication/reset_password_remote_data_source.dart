import '../../../../../core/api/api-requests.dart';
import '../../../../../core/api/errors/exceptions.dart';
import '../../../../../core/constants/user-parameters.dart';

abstract class ResetPasswordRemoteDataSource{
  Future<void> checkEmail(String email);
  Future<void> verifyCode(VerifyCodeParams params);
}

class ResetPasswordRemoteDataSourceImpl implements ResetPasswordRemoteDataSource {
  final ApiRequest apiRequest;

  ResetPasswordRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<void> checkEmail(String email) async {
    final response = await apiRequest.post(
        '/auth/check-email', body: {'email': email});
    if (response.statusCode != 200) {
      throw ServerException(message: response.data['message']);
    }
  }

  @override
  Future<void> verifyCode(VerifyCodeParams params) async {
    final response = await apiRequest.post(
        '/auth/verify-code', body: params.toJson());

    if (response.statusCode != 200) {
      throw ServerException(message: response.data['message']);
    }
  }
}
