// import "package:driver_app/presentation/widgets/primary_button.dart";
// import "package:flutter/material.dart";
// import "package:flutter_screenutil/flutter_screenutil.dart";
// import "package:get/get.dart";
// import "../../core/constants/app_colors.dart";
// import "../../core/theme/app_style.dart";
// import "../../core/constants/app_images.dart" show ImagesPaths;
// import "../../core/util/helper/data_helper.dart";
// import "../../core/util/network/internet_info.dart";
// import "../core/helper/data_helper.dart";
//
// class NoInternetScreen extends StatefulWidget {
//   const NoInternetScreen({super.key});
//
//   static String route = "/NoInternetScreen";
//
//   @override
//   NoInternetScreenState createState() => NoInternetScreenState();
// }
//
// class NoInternetScreenState extends State<NoInternetScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GetBuilder<NoInternetController>(
//         init: NoInternetController(),
//         builder:
//             (NoInternetController controller) => SafeArea(
//           child: Scaffold(
//             body: Stack(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(width: 1.sw),
//                     Image.asset(
//                       ImagesPaths.noInternet,
//                       width: 0.5.sw,
//
//                     ),
//                     Padding(
//                       padding:
//                       const EdgeInsets.only(
//                         left: 20,
//                         right: 20,
//                         bottom: 40,
//                       ).r,
//                       child: Column(
//                         children: [
//                           Text(
//                             "Sorry no internet,".tr,
//                             style:
//                             DataHelper.isDarkTheme(context)
//                                 ? TextStyle(
//                               color: AppColors.white,
//                               fontSize: 18.sp,
//                             )
//                                 : AppStyle.bodyLarge,
//                             textAlign: TextAlign.center,
//                           ),
//                           Text(
//                             "Please check your connection,".tr,
//                             style:
//                             DataHelper.isDarkTheme(context)
//                                 ? TextStyle(
//                               color: AppColors.white,
//                               fontSize: 18.sp,
//                             )
//                                 : AppStyle.bodyLarge,
//                             textAlign: TextAlign.center,
//                           ),
//                           Text(
//                             "and try again.".tr,
//                             style:
//                             DataHelper.isDarkTheme(context)
//                                 ? TextStyle(
//                               color: AppColors.white,
//                               fontSize: 18.sp,
//                             )
//                                 : AppStyle.normalStyle,
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         top: 0.1.h,
//                         left: 0.03.w,
//                         right: 0.03.w,
//                       ),
//                       child: PrimaryButton(
//                         onTap: () {
//                           controller.tryAgain(context);
//                         },
//                         title: "Try again".tr,
//                         isLoading: controller.isLoading,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
