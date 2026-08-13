import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/settings/data/models/privacy_policy_model.dart';

abstract class SettingsRemoteDataSource {
  Future<PrivacyPolicyModel> getPrivacyPolicy();
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiRequest apiRequest;

  SettingsRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<PrivacyPolicyModel> getPrivacyPolicy() async {
    try {
      final response = await apiRequest.get(EndPoints.privacyPolicy);
      if (response.statusCode != 200) {
        throw ServerException(message: getErrorMessage(response.statusCode ?? 0));
      }
      return PrivacyPolicyModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
