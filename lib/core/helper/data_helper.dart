import "dart:io";
import "package:flutter/material.dart";

class DataHelper {
  static bool get isIos => Platform.isIOS;

  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }


  static dateFormat(String newPattern,DateTime date) {
    return DateFormat(newPattern).format(date);

  }
}
