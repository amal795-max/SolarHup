import "dart:async";
import "package:get_storage/get_storage.dart";

import "../data/models/user_models/account.dart";
import "../data/models/user_models/user_model.dart";
import "authentication_service.dart";

LocalStorageServices localStorageServices = LocalStorageServices();

class LocalStorageServices {
  final String userIsLogin = "user_is_login";
  final String userIsFirst = "userIsFirst";
  final String userConnect = "userConnect";
  final String _deviceModel = "deviceModel";

  /// token properties
  final String userToken = "user_token";
  final String userTokenType = "user_token_type";
  static const String themeMode = "theme_mode";

  /// user variable
  final String userId = "user_id";
  final String userName = "user_name";
  final String userEmail = "user_email";
  final String userPhone = "user_phone";
  final String language = "language";
  final String licence = "licence";

  //current page
  final String locationsKey = "locations";
  final String locationSelected = "locationSelected";
  final String currentPage = "current_page";
  final String itemId = "item_id";

  final GetStorage _storage = GetStorage();

  static const String _uDid = "udid";

  String? getUdid() {
    String? value = localStorageServices.read(_uDid);
    return value;
  }

  Future<void> setUdid(String uDid) async {
    await localStorageServices.write(_uDid, uDid);
  }
  Future<void> setDeviceModel(String deviceModel) async {
    await localStorageServices.write(_deviceModel, deviceModel);
  }
  String ? getDeviceModel() {
    String? model=  read(_deviceModel);
    print(model);
    return model;
  }

  Future<dynamic> write(String key, String value) async {
    return await _storage.write(key, value);
  }

  String? read(String key) {
    String? value = _storage.read(key);
    if (value != null) {
      return value;
    }
    return null;
  }

  String? getLanguage() {
    String? lang = read(language);
    return lang;
  }

  void setLanguage(String value) {
    write(language, value);
  }

  Future<void> removeCurrentPage() async {
    await _storage.remove(currentPage);
    await _storage.remove(itemId);
  }

  Future<void> setCurrentPage(String value) async {
    await localStorageServices.write(currentPage, value);
  }

  String? getCurrentPage() {
    String? value = localStorageServices.read(currentPage);
    return value;
  }

  //////////////////////////////////////////////////////////////////////////
  String? getMode() {
    String? value = localStorageServices.read(themeMode);
    return value;
  }

  Future<void> setMode(String value) async {
    await localStorageServices.write(themeMode, value);
  }

  Future<void> removeMode() async {
    await _storage.remove(themeMode);
  }

  //////////////////////////////////////////////////////////////////////////
  int? getItemId() {
    String? value = localStorageServices.read(itemId);
    if (value != null) {
      return int.parse(value);
    }
    return null;
  }

  Future<void> setItemId(int value) async {
    await localStorageServices.write(itemId, value.toString());
  }

  Future<void> setCurrentUserWithToken(AccountModel account) async {
    // await setUser(account.user);


    /// token storage
    await write(userToken, account.token);
    print("userToken===========================================================");
    print( account.token);
    print(read(userToken));
  }
  Future<void> setToken(String token) async {
    await write(userToken,token );
    print(read(userToken));
  }
  Future<void> setUser(UserModel user) async {
    UserModel currentUser = UserModel(sId: "0");
    currentUser.sId = user.sId;
    currentUser.name = user.name;
    currentUser.phone = user.phone;
    currentUser.email = user.email;
    AuthenticationService.currentUser = currentUser;
    AuthenticationService.isLogin = true;

    await write(userIsLogin, true.toString());
    await write(userId, currentUser.sId.toString());
    await write(userName, currentUser.name ?? "");
    await write(userEmail, currentUser.email ?? "");
    await write(userPhone, currentUser.phone ?? "");
  }

  Future<void> getCurrentUser() async {
    UserModel currentUser = UserModel(sId: "0");
    bool isLogin = await isUserLogin();
    if (isLogin) {
      String? id = read(userId);
      currentUser.sId = read(id!);
      currentUser.name = read(userName);
      currentUser.email = read(userEmail);
      currentUser.phone = read(userPhone);

      AuthenticationService.currentUser = currentUser;
      AuthenticationService.isLogin = true;
    } else {
      await write(userIsLogin, false.toString());
      AuthenticationService.currentUser = null;
    }
  }

  Future<Map<String, dynamic>>? getUserToken() async {
    Map<String, dynamic> tokenMap = <String, dynamic>{};
    try {
      String? accessToken = read(userToken);
      tokenMap[userToken] = accessToken;
      String? tokenType = read(userTokenType);
      tokenMap[userTokenType] = tokenType;
    } catch (e) {
      rethrow;
    }
    return tokenMap;
  }
  Future<void> setLicenceImage(image) async{
    await write(licence, image);

  }
  Future<dynamic> getLicenceImage() async{
    String? value = read(licence);
    return value;
  }

  Future<dynamic> getToken() async {
    String? value = read(userToken);
    return value;
  }
  Future<bool> isUserLogin() async {
    String? value;
    try {
      value = read(userIsLogin);
    } catch (e) {
      return false;
    }

    return value == true.toString();
  }

  //////////////////////////////////////////////////////
  Future<bool> isFirstOpen() async {
    String? value;
    try {
      value = read(userIsFirst);
    } catch (e) {
      return false;
    }

    return value == true.toString();
  }

  Future<void> setFirst(bool isFirst) async {
    await write(userIsFirst, true.toString());
  }

  //////////////////////////////////
  Future<bool> logout() async {
    AuthenticationService.currentUser = null;
    await _storage.remove(userIsLogin);

    ///remove token
    await _storage.remove(userToken);
    await _storage.remove(userTokenType);

    /// remove user
    await _storage.remove(userId);
    await _storage.remove(userName);
    await _storage.remove(userEmail);
    await _storage.remove(userPhone);
    await _storage.remove(_uDid);
    await _storage.remove(itemId);
    await _storage.remove(currentPage);

    await write("is_Login", false.toString());
    AuthenticationService.currentUser = null;
    AuthenticationService.isLogin = false;
    return true;
  }

  Future<void> deleteAll() async {
    AuthenticationService.currentUser = null;
    AuthenticationService.isLogin = false;
    await _storage.remove(userIsLogin);
    await _storage.remove(userIsFirst);
    await write("is_Login", false.toString());
    return _storage.erase();
  }

  Future<void>  setIsConnect(bool isConnect) async{
    await write(userConnect, isConnect.toString());

  }

  bool isConnect() {
    String? value;
    try {
      value = read(userConnect);
    } catch (e) {
      return false;
    }

    return value == true.toString();
  }




}
