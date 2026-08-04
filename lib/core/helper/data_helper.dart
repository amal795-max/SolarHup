import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_url.dart';
import 'local_storage.dart';

class DataHelper {
  static bool get isIos => Platform.isIOS;

  static void showSnackBar(
 {
   Color ? color ,
   required String message,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        behavior: SnackBarBehavior.floating,
        backgroundColor:color,
        content: Text(message.tr(),style:AppStyle.bodySmall),
      ),
    );
  }


  static String formatePhoneNumber(String phoneNumber) {
    String? phone = LocalStorage().getDataString(key: ApiKeys.phoneNumber);
    if (phoneNumber == '' && phone != null) {
      return phone;
    }
    String raw = phoneNumber.trim();
    if (raw.startsWith('0')) {
      raw = raw.substring(1);
    }
    return  '+963$raw';
  }

  static String dateFormat(String newPattern,DateTime date) {
    return DateFormat(newPattern).format(date);

  }

  Future<void> makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> openWhatsApp(String phoneNumber) async {
    final String url = 'https://wa.me/$phoneNumber';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
  Future<void> openTelegram(String username) async {
    final telegramApp = Uri.parse('tg://resolve?domain=$username');
    final telegramWeb = Uri.parse('https://t.me/$username');

    if (await canLaunchUrl(telegramApp)) {
      await launchUrl(telegramApp, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(telegramWeb, mode: LaunchMode.externalApplication);
    }
  }

}
