import 'package:flutter/material.dart';
import 'package:untitled1/core/enums/date_enum.dart';

extension ContextExtension on BuildContext {

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get brightness =>Theme.of(this).brightness == Brightness.dark;



}
extension DateEnumExtension on DateEnum {
  static DateEnum fromDate(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time).inDays;

    if (diff == 0) return DateEnum.today;
    if (diff == 1) return DateEnum.yesterday;
    if (diff <= 7) return DateEnum.last7Days;
    if (diff <= 30) return DateEnum.lastMonth;
    return DateEnum.older;
  }
}
