
import 'environment_config.dart';

class EndPoints {
  static const String baseUrl = EnvironmentConfig.apiEndpoint;
  static const String _auth = '${baseUrl}auth/';
  static const String checkPhoneNumber = '${_auth}check-phone';
  static const String register = '${_auth}signup';
  static const String login='${_auth}login';

}

class ApiKeys {
  static const String userIsLogin = 'user_is_login';
  static const String userIsFirst = 'userIsFirst';
  static const String deviceModel = 'deviceModel';
  static const String userToken = 'user_token';
  static const String token ='token';

}
class StorageKeys {
  static const String mode = 'mode';
  static const String langCode = 'langCode';


}
