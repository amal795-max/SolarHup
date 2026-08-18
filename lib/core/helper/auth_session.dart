import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/helper/local_storage.dart';

class AuthSession {
  static bool get isLoggedIn {
    final loggedIn = LocalStorage().getData(
      key: ApiKeys.userIsLogin,
      defaultValue: false,
    ) as bool;
    final token = LocalStorage().getDataString(key: ApiKeys.token);
    return loggedIn && token != null && token.isNotEmpty;
  }

  static Future<void> clear() async {
    await LocalStorage().removeData(key: ApiKeys.userIsLogin);
    await LocalStorage().removeData(key: ApiKeys.token);
    await LocalStorage().removeData(key: ApiKeys.securityCode);
    await LocalStorage().removeData(key: ApiKeys.isVerified);
    await LocalStorage().removeData(key: ApiKeys.usedPromotionIds);
  }
}
