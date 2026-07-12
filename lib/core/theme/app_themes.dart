import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'app_colors.dart';
import 'app_style.dart';

class AppThemes {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily:'Tajawal' ,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    secondaryHeaderColor: AppColors.secondaryColor,
    scaffoldBackgroundColor: AppColors.darkMode,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.blue,
      surface: AppColors.darkContainer,
      onSurface: AppColors.white,
      secondary: AppColors.secondaryColor,
      outline: AppColors.darkGray,
      tertiaryContainer: AppColors.darkGray,
        shadow: AppColors.grey
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.white, size: 24.sp),
      centerTitle: true,
      titleTextStyle: AppStyle.bodyLarge.copyWith(color: AppColors.white),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightGrey,
      indent: 20,
      endIndent: 20,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: AppColors.blue,
      titleTextStyle: AppStyle.bodySmall.copyWith(color: AppColors.blue),
    ),
    textTheme: TextTheme(
      headlineLarge: AppStyle.h1.copyWith(color: AppColors.white),
      headlineMedium: AppStyle.h2.copyWith(color: AppColors.white),
      headlineSmall: AppStyle.h3.copyWith(color: AppColors.white),
      titleLarge: AppStyle.h4.copyWith(color: AppColors.white),
      titleMedium: AppStyle.h5.copyWith(color: AppColors.white),
      titleSmall: AppStyle.h6.copyWith(color: AppColors.white),
      bodyLarge: AppStyle.bodyLarge.copyWith(color: AppColors.white),
      bodyMedium: AppStyle.bodyMedium.copyWith(color: AppColors.white),
      bodySmall: AppStyle.bodySmall.copyWith(color: AppColors.blue),
      labelLarge: AppStyle.labelLarge.copyWith(color: AppColors.white),
      labelMedium: AppStyle.labelMedium.copyWith(color: AppColors.white),
      labelSmall: AppStyle.labelSmall.copyWith(color: AppColors.blue),
      displaySmall: AppStyle.bodyXSmall.copyWith(color: AppColors.blue),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        minimumSize: Size(double.infinity, 50.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily:'Tajawal' ,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backGroundGrey,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      surface: AppColors.white,
      onSurface: AppColors.black,
      secondary: AppColors.secondaryColor,
      outline: AppColors.borderColor,
      tertiaryContainer: AppColors.lightGrey,
      shadow: AppColors.lightGrey
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.black, size: 24.sp),
      centerTitle: true,
      titleTextStyle: AppStyle.bodyLarge.copyWith(color: AppColors.black),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightGrey,
      indent: 20,
      endIndent: 20,
    ),

    listTileTheme: ListTileThemeData(
      iconColor: AppColors.darkGray,
      titleTextStyle: AppStyle.bodySmall.copyWith(color: AppColors.darkGray),
    ),
    textTheme: TextTheme(
      headlineSmall: AppStyle.h4.copyWith(color: AppColors.primaryColor),
      titleLarge: AppStyle.h5.copyWith(color: AppColors.black),
      titleMedium: AppStyle.h6.copyWith(color: AppColors.black),
      bodyLarge: AppStyle.bodyLarge.copyWith(color: AppColors.black),
      bodyMedium: AppStyle.bodyMedium.copyWith(color: AppColors.black),
      bodySmall: AppStyle.bodySmall.copyWith(color: AppColors.grey),
      labelLarge: AppStyle.labelLarge.copyWith(color: AppColors.white),
      labelMedium: AppStyle.labelMedium.copyWith(color: AppColors.black),
      labelSmall: AppStyle.labelSmall.copyWith(color: AppColors.grey),
      displaySmall: AppStyle.bodyXSmall.copyWith(color: AppColors.grey),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        minimumSize: Size(double.infinity, 50.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    ),
  );
  static final defaultPinTheme = PinTheme(
    width: 55,
    height: 50,
    textStyle: const TextStyle(fontSize: 16, color: AppColors.grey),
    decoration: BoxDecoration(
      color: AppColors.lightGrey,
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static final focusedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration!.copyWith(
      border: Border.all(color: AppColors.borderColor),
    ),
  );
}
