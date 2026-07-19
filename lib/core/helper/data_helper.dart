import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

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
        content: Text(message.tr(),style:AppStyle.bodySmall.copyWith(color: AppColors.white),),
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

  // static dateFormat(String newPattern,DateTime date) {
  //   return DateFormat(newPattern).format(date);
  //
  // }
}
