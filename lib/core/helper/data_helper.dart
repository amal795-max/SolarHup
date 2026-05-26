import 'dart:io';
import 'package:flutter/material.dart';

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
        content: Text(message),
      ),
    );
  }


  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }


  // static dateFormat(String newPattern,DateTime date) {
  //   return DateFormat(newPattern).format(date);
  //
  // }
}
