// import "dart:io";
// import "package:get/get_connect/http/src/response/response.dart";
// import "package:get/get_utils/get_utils.dart";
//
// import "../core/constants/app_url.dart";
// import "../core/util/config/environment_config.dart";
// import "application_services.dart";
// import "local_storage_services.dart";
//
//
// class RefreshAndLogoutServices {
//   static Future<void> logout() async {
//     try {
//       String token = "";
//       String refreshToken = "";
//       Map<String, dynamic>? tokenMap =
//           await localStorageServices.getUserToken();
//       if (tokenMap != null) {
//         token = tokenMap[localStorageServices.userToken];
//       }
//       String url = UrlPath.logout;
//       String udId = localStorageServices.getUdid()!;
//       final Map<String, String> queryParameters = <String, String>{
//         "access_token": token,
//         "udid": udId,
//       };
//       final Uri uri = Uri.parse(url);
//       Response response = await get(
//         uri.replace(queryParameters: queryParameters),
//         headers: {
//           "Authorization": "Bearer $refreshToken",
//           "Accept": "application/vnd.api.v1+json",
//           "Platform": Platform.isIOS ? "ios" : "android",
//           "App-Secret":
//               Platform.isIOS
//                   ? EnvironmentConfig.iosAppSecret
//                   : EnvironmentConfig.androidAppSecret,
//         },
//       );
//       if (response.statusCode == 200) {
//         ApplicationService.showAlertToastAndLogout("Logout successfully".tr);
//         return;
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
