import "dart:io";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class DataHelper {
  static bool get isIos => Platform.isIOS;

  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // static dynamic showLoginDialog(
  //   BuildContext context,
  //   String? pageRoute, {
  //   int? itemId,
  // }) {
  //   showGeneralDialog(
  //     barrierLabel: "",
  //     barrierDismissible: true,
  //     transitionDuration: const Duration(milliseconds: 200),
  //     context: context,
  //     pageBuilder: (
  //       BuildContext context,
  //       Animation<double> anim1,
  //       Animation<double> anim2,
  //     ) {
  //       return  RequiredLoginDialog();
  //     },
  //     transitionBuilder: (
  //       BuildContext context,
  //       Animation<double> anim1,
  //       Animation<double> anim2,
  //       Widget child,
  //     ) {
  //       return child;
  //     },
  //   ).then((value) async {
  //     if (value != null && value == true) {
  //     //  routeController.goNamedAndRemoveUntil(authentication.route);
  //     }
  //   });
  // }

  // static dynamic dialogPrivacyPolicy(BuildContext context) {
  //   AwesomeDialog(
  //     context: context,
  //     padding: const EdgeInsets.all(4).r,
  //     dialogType: DialogType.noHeader,
  //     headerAnimationLoop: false,
  //     animType: AnimType.topSlide,
  //     title: "",
  //     desc: "",
  //     // Remove this if you're placing all content in the body
  //     body: SingleChildScrollView(
  //       padding: const EdgeInsets.all(8.0).r,
  //       // Add some padding around the text
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Center(
  //             child: Text(
  //               "Privacy Policy\n",
  //               textAlign: TextAlign.center,
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
  //             ),
  //           ),
  //           const Text(
  //             "Introduction\n",
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const Text(
  //             "This Privacy Policy explains how we collect, use, and share your personal information.\n",
  //           ),
  //           const Text(
  //             "Information Collection",
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const Text(
  //             "We collect information you provide during registration and use of our app, including name, email, and payment details.\n",
  //           ),
  //           const Text(
  //             "Use of Information",
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const Text(
  //             "Your information is used to manage gym memberships, process payments, and improve our services.\n",
  //           ),
  //           const Text(
  //             "Sharing of Information",
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const Text(
  //             "We may share information with service providers like Stripe for payment processing.\n",
  //           ),
  //           const Text(
  //             "Data Security",
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const Text(
  //             "We take reasonable measures to protect your information from unauthorized access or disclosure.\n",
  //           ),
  //           const Text(
  //             "Children's Privacy",
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const Text(
  //             "Our app is not intended for children under the age of 13.\n",
  //           ),
  //           const Text(
  //             "Changes to This Policy",
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const Text(
  //             "We may update this policy and will provide notice of significant changes.\n",
  //           ),
  //           const Text(
  //             "Your Rights",
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const Text(
  //             "You have the right to access, update, or delete your personal information.\n",
  //           ),
  //         ],
  //       ),
  //     ),
  //     btnOk: PrimaryButton(
  //       title: "OK",
  //       height: 40,
  //       onTap: () {
  //         Navigator.pop(context, true);
  //       },
  //     ),
  //   ).show();
  // }
  //
  // static Future<void> makePhoneCall(String phone) async {
  //   final Uri launchUri = Uri(scheme: "tel", path: phone);
  //   await launchUrl(launchUri);
  // }
  //
  // static Future<void> sendMail(String mail) async {
  //   final Uri launchUri = Uri(scheme: "mailto", path: mail);
  //   await launchUrl(launchUri);
  // }
  //
  // static String removeUrlPrefix(String url) {
  //   if (url.startsWith("https://")) {
  //     return url.replaceFirst("https://", "");
  //   } else if (url.startsWith("http://")) {
  //     return url.replaceFirst("http://", "");
  //   }
  //   return url;
  // }

  // static Future<void> launchInBrowser(String url) async {
  //   print(url);
  //   final Uri toLaunch = Uri(scheme: 'https', host: removeUrlPrefix(url), path: 'headers/');
  //   if (!await launchUrl(
  //     Uri.parse(url),
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  // static Future<void> launchInBrowser(String url) async {
  //   final String encodedUrl = Uri.encodeFull(url);
  //   final Uri uri = Uri.parse(encodedUrl);
  //   if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
  //     throw Exception("Could not launch $url");
  //   }
  // }
  //
  // static Future<dynamic> openWhatsapp(String phone) async {
  //   String whatsappURlAndroid = "whatsapp://send?phone=$phone";
  //   String whatsappURLIos = "whatsapp://send?phone=$phone";
  //   if (Platform.isIOS) {
  //     if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
  //       await launchUrl(Uri.parse(whatsappURLIos));
  //     } else {
  //       ApplicationService.showAlertMessage("Whatsapp no installed");
  //     }
  //   } else {
  //     if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
  //       await launchUrl(Uri.parse(whatsappURlAndroid));
  //     } else {
  //       ApplicationService.showAlertMessage("Whatsapp no installed");
  //     }
  //   }
  // }
  // static String getLocalizedText(DisplayedCategory? category) {
  //   return Get.locale?.languageCode == 'ar' ? category?.ar ?? category?.en ?? 'Unknown' : category?.en ?? category?.ar ?? 'Unknown';
  // }
  //
  // static RequiredLoginDialog() {}
  //
  static dateFormat(String newPattern,DateTime date) {
    return DateFormat(newPattern).format(date);

  }
}
