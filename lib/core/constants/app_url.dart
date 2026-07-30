
import 'environment_config.dart';

class EndPoints {
  static const String baseUrl = EnvironmentConfig.apiEndpoint;
  static const String _auth = '${baseUrl}auth/';
  static const String checkPhoneNumber = '${_auth}check-phone';
  static const String register = '${_auth}signup';
  static const String login='${_auth}login';
  static const String otpVerification='${_auth}send-otp';
  static const String confirmOtp='${_auth}confirm-otp';
  static const String setNewPassword = '${_auth}set-new-password';
  static const String changePassword = '${_auth}change-password';
  static const String blogArticles = '${baseUrl}blog';
  static String blogArticle(String articleId) => '${baseUrl}blog/$articleId';

  static const String stores = '${baseUrl}stores';
}

class ApiKeys {
  static const String userIsLogin = 'user_is_login';
  static const String userIsFirst = 'userIsFirst';
  static const String deviceModel = 'deviceModel';
  static const String userToken = 'user_token';
  static const String token ='token';
  static const String securityCode = 'security_code';
  static const String isVerified = 'is_verified';
  static const String phoneNumber = 'phoneNumber';

}
class StorageKeys {
  static const String mode = 'mode';
  static const String langCode = 'langCode';


}
