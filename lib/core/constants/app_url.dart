
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

  static const String _assistant = '${baseUrl}assistant/';
  static const String recommend = '${_assistant}recommend';
  static const String conversations = '${_assistant}conversations';
  static String conversationDetails(int id) => '${_assistant}conversations/$id';

  static const String stores = '${baseUrl}stores';
  static String store(String businessId) => '${baseUrl}stores/$businessId';
  static String storeProducts(String businessId) =>
      '${baseUrl}stores/$businessId/products';
  static String storeProduct(String businessId, String productId) =>
      '${baseUrl}stores/$businessId/products/$productId';

  static const String usedProducts = '${baseUrl}used-products';
  static const String myUsedProducts = '${baseUrl}used-products/me';
  static String updateProductStatus(int id) => '${baseUrl}used-products/me/$id/status';
  static String deleteProduct(int id) => '${baseUrl}used-products/me/$id';
  static String updateProduct(int id) => '${baseUrl}used-products/me/$id';

  static const String favorites = '${baseUrl}favorites';
  static String favoriteItem(String itemType, int itemId) => '${baseUrl}favorites/$itemType/$itemId';
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
  static const String onboardingCompleted = 'onboardingCompleted';


}
