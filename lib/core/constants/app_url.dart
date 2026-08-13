
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
  static const String faqs = '${baseUrl}faqs';
  static const String complaints = '${baseUrl}complaints';
  static const String myComplaints = '${baseUrl}complaints/me';
  static String complaintDetails(int id) => '${baseUrl}complaints/$id';

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

  static const String storeCategories = '${baseUrl}categories';

  static const String discounts = '${baseUrl}discounts';
  static String storeDiscounts(String businessId) =>
      '${baseUrl}stores/$businessId/discounts';

  static const String workshops = '${baseUrl}workshops';
  static String workshop(String businessId) => '${baseUrl}workshops/$businessId';
  static String workshopServices(String businessId) =>
      '${baseUrl}workshops/$businessId/services';

  static const String serviceRequests = '${baseUrl}service-requests';
  static const String myServiceRequests = '${baseUrl}service-requests/me';
  static String serviceRequest(int requestId) =>
      '${baseUrl}service-requests/$requestId';

  static const String usedProducts = '${baseUrl}used-products';
  static const String myUsedProducts = '${baseUrl}used-products/me';
  static String updateProductStatus(int id) => '${baseUrl}used-products/me/$id/status';
  static String deleteProduct(int id) => '${baseUrl}used-products/me/$id';
  static String updateProduct(int id) => '${baseUrl}used-products/me/$id';

  static const String favorites = '${baseUrl}favorites';
  static const String _orders = '${baseUrl}orders';
  static const String myOrders = '${baseUrl}orders/me';
  static String orderDetails(int id) => '${baseUrl}orders/$id';
  static const String cart = '${baseUrl}orders/cart';
  static const String cartItems = '${baseUrl}orders/cart/items';
  static const String submitCart = '${baseUrl}orders/cart/submit';
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

  static const String orderId = 'orderId';

}
class StorageKeys {
  static const String mode = 'mode';
  static const String langCode = 'langCode';
  static const String onboardingCompleted = 'onboardingCompleted';


}
