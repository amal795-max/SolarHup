import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_themes.dart';

/// Central theme entry point for the app.
/// Typography is defined in [AppThemes] — do not override fonts here.
abstract final class AppTheme {
  static ThemeData get lightTheme => AppThemes.lightTheme.copyWith(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backGroundGrey,
        appBarTheme: AppThemes.lightTheme.appBarTheme,
        textTheme: AppThemes.lightTheme.textTheme,
        colorScheme: AppThemes.lightTheme.colorScheme,
      );

  static ThemeData get darkTheme => AppThemes.darkTheme.copyWith(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.darkMode,
        appBarTheme: AppThemes.darkTheme.appBarTheme,
        textTheme: AppThemes.darkTheme.textTheme,
        colorScheme: AppThemes.darkTheme.colorScheme,
      );
}
