import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {

  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get brightness =>Theme.of(this).brightness == Brightness.dark;

}