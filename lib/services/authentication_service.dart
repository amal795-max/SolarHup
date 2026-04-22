import "dart:convert";

import "package:dio/dio.dart";
import "package:get/get_utils/get_utils.dart";
import "package:jwt_decode/jwt_decode.dart";
import "../core/constants/app_colors.dart";
import "../core/constants/app_url.dart";
import "../core/constants/constant.dart";
import "../data/data_sources/api_provider.dart";
import "../data/models/mobile_pages_model.dart";
import "../data/models/refresh_token_exception.dart";
import "../data/models/request_model/request_otp_request_model.dart";
import "../data/models/request_model/request_verify_otp_model.dart";
import "../data/models/request_model/sign_in_request_model.dart";
import "../data/models/user_models/account.dart";
import "../data/models/user_models/user_model.dart";
import "application_services.dart";
import "local_storage_services.dart";


class AuthenticationService {
  static UserModel? currentUser;
  static bool isLogin = false;

  static Future<UserModel?> getProfile() async {
    var response = await ApiProvider.get(UrlPath.profile, headers: needAuthMap);
    if (response.statusCode == 200) {
      UserModel user = UserModel.fromJson(response.data["data"]);
      return user;
    }
    return null;
  }

  static Future<bool> logInWithEmail(LogInRequestModel logInRequestModel) async {
    Response<dynamic> response = await ApiProvider.post(
      UrlPath.login,
      jsonEncode(logInRequestModel),
    );

    if (response.statusCode == 200) {
      try {
        AccountModel account = AccountModel.fromJson(response.data);
          Map<String, dynamic> payload = Jwt.parseJwt(account.token);
        localStorageServices.setToken(account.token);
        localStorageServices.setFirst(true);
        print('jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');
        print(account.token);
        localStorageServices.setUdid(payload['sub']);
      }catch(e){
        print(e);
      }
      ApplicationService.showAlertMessage(
        "Welcome Again".tr,
        background: AppColors.mainAppColor,
      );
      return true;
    }
    print(response.statusMessage);
    print(response.statusCode);
    print("=====================================error ${response.data}");
    return false;
  }

////////////////////////////////////////////////////////////////////////////////////
  static Future<bool> logout() async {
    try {
      // String token = "";
      // Map<String, dynamic>? tokenMap =
      //     await localStorageServices.getUserToken();
      // if (tokenMap != null) {
      //   token = tokenMap[localStorageServices.userToken];
      // }
      // String udId = await DataHelper.getUdId();
      // final Map<String, String> queryParameters = <String, String>{
      //   "access_token": token,
      //   "udid": udId,
      // };
      // Response<dynamic> response = await ApiProvider.get(
      //   UrlPath.logout,
      // queryParameters: queryParameters,
      // headers: {
      //   "Authorization": "Bearer $token",
      //   "Accept": "application/vnd.api.v1+json",
      //   "Platform": Platform.isIOS ? "ios" : "android",
      //   "App-Secret":
      //       Platform.isIOS
      //           ? EnvironmentConfig.iosAppSecret
      //           : EnvironmentConfig.androidAppSecret,
      // },
      // );
      // if (response.statusCode == 200) {
      ApplicationService.showAlertToastAndLogout("Logout successfully".tr);
      return true;
      // }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> requestOtp(RequestOtpRequestModel requestModel) async {
    FormData data = FormData.fromMap(requestModel.toJson());
    Response<dynamic> response = await ApiProvider.post(
      UrlPath.requestOtp,
      data,
    );
    if (response.statusCode == 200) {
      String message = response.data["message"];
      ApplicationService.showAlertMessage(
        message,
        background: AppColors.mainAppColor,
      );
      return true;
    }
    return false;
  }

  static Future<bool> requestOtpEmail(RequestOtpEmailModel requestModel) async {
    FormData data = FormData.fromMap(requestModel.toJson());
    Response<dynamic> response = await ApiProvider.post(
      UrlPath.requestOtpEmail,
      data,
    );
    if (response.statusCode == 200) {
      String message = response.data["message"];
      ApplicationService.showAlertMessage(
        message,
        background: AppColors.mainAppColor,
      );
      return true;
    }
    return false;
  }

  static Future<bool> requestOtpByPhone(
      RequestVerifyOtpModel requestModel,
      ) async {
    FormData data = FormData.fromMap(requestModel.toJson());
    Response<dynamic> response = await ApiProvider.post(
      UrlPath.requestOtp,
      data,
      headers: needAuthMap,
    );
    if (response.statusCode == 200) {
      String message = response.data["message"];
      ApplicationService.showAlertMessage(
        message,
        background: AppColors.mainAppColor,
      );
      return true;
    }
    return false;
  }




  static Future<String?> getToken() async {
    try {
      String? accessToken;
      Map<String, dynamic>? tokenMap =
      await localStorageServices.getUserToken();
      if (tokenMap != null) {
        accessToken = tokenMap[localStorageServices.userToken];
      }
      return accessToken;
    } on RefreshTokenException {
      throw RefreshTokenException("Your session expired".tr);
    } catch (e) {
      throw RefreshTokenException("Your session expired".tr);
    }
  }

  static Future<bool> updateProfile(dynamic formData) async {
    try {
      Response<dynamic> response = await ApiProvider.put(
        UrlPath.updateProfile,
        formData,
        headers: needAuthMap,
      );
      if (response.statusCode == 200) {
        UserModel userModel = UserModel.fromJson(response.data["data"]);
        await localStorageServices.setUser(userModel);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> deleteAccount(Map<String, String> data) async {
    Response<dynamic> response = await ApiProvider.delete(
      UrlPath.deleteAccount,
      data: data,
      headers: needAuthMap,
    );
    if (response.statusCode == 200) {
      localStorageServices.deleteAll();
      String message = response.data["message"];
      ApplicationService.showAlertToastAndLogout(message);
      return true;
    } else if (response.statusCode != 403 && response.statusCode != 422) {
      String message = response.data["message"];
      ApplicationService.showAlertMessage(message, textColor: AppColors.errorRed);
    }
    return false;
  }

  ////////////////// Contact US //////////////////////////////////////////

  static Future<MobilePagesModel?> getMobilePages() async {
    try {
      Response<dynamic> response = await ApiProvider.get(
        UrlPath.mobileMainPages,
      );
      if (response.statusCode == 200) {
        return MobilePagesModel.fromJson(response.data["data"]);
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}



