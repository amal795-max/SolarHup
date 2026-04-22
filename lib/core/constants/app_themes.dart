import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "app_colors.dart";
import "app_style.dart";

class AppThemes {
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    colorScheme: ThemeData.dark().colorScheme.copyWith(
      primary: AppColors.darkContainer,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.mainAppColor,
      selectionColor: AppColors.mainAppColor,
      selectionHandleColor: AppColors.mainAppColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle:AppStyle.getFontStyle(color: AppColors.white),
      hintStyle:AppStyle.getFontStyle(color: AppColors.lightGray),
      focusColor: AppColors.mainAppColor,
      enabledBorder: const OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.textField),
      ),
    ),
    appBarTheme: AppBarTheme(
      surfaceTintColor: AppColors.darkMode,
      titleTextStyle:AppStyle.getFontStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w600,
        fontSize: 18.sp,
      ),
      iconTheme: IconThemeData(color: AppColors.white, size: 18.sp),
    ),
    scaffoldBackgroundColor: AppColors.darkMode,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBottomNav,
    ),
    cardTheme: const CardThemeData(
      surfaceTintColor: AppColors.darkMode,
      color: AppColors.darkMode,
    ),
    textTheme: TextTheme(
      bodyLarge:AppStyle.getFontStyle(color: AppColors.white),
      bodyMedium:AppStyle.getFontStyle(color: AppColors.white),
      titleMedium:AppStyle.getFontStyle(color: AppColors.white),
      titleSmall:AppStyle.getFontStyle(color: AppColors.white),
    ),
    iconTheme: const IconThemeData(color: AppColors.white),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.white,
      labelStyle:AppStyle.getFontStyle(fontSize: 16.sp, color: AppColors.white),
    ),
   // bottomAppBarTheme: const BottomAppBarThemeData(color: AppColors.darkMode),
    dialogTheme: DialogThemeData(
      contentTextStyle:AppStyle.getFontStyle(color: AppColors.white),
      backgroundColor: AppColors.darkMode,
      titleTextStyle:AppStyle.getFontStyle(color: AppColors.white),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(backgroundColor: AppColors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkContainer,
        foregroundColor: AppColors.white,
      ),
    ),
  );

  ///

  static ThemeData lightTheme = ThemeData.light().copyWith(
    cardTheme: const CardThemeData(
      surfaceTintColor: AppColors.white,
      color: AppColors.white,
    ),
    brightness: Brightness.light,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.mainAppColor,
      selectionColor: AppColors.mainAppColor,
      selectionHandleColor: AppColors.mainAppColor,
    ),

    listTileTheme: ListTileThemeData(textColor: AppColors.darkGray),
    expansionTileTheme: ExpansionTileThemeData(textColor: AppColors.darkGray),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.white,
      dividerColor: AppColors.lightMain,
      headerBackgroundColor: AppColors.mainAppColor,
      headerForegroundColor: AppColors.white,
      dayStyle: const TextStyle(color: AppColors.secondaryAppColor),
      dayForegroundColor: WidgetStateProperty.all<Color>(
        AppColors.black.withValues(alpha: 0.7),
      ),
      dayOverlayColor: WidgetStateProperty.all<Color>(
        AppColors.mainAppColor.withValues(alpha: 0.7),
      ),
      todayBackgroundColor: WidgetStateProperty.all<Color>(
        AppColors.mainAppColor.withValues(alpha: 0.7)),
      cancelButtonStyle: ButtonStyle(
        textStyle: WidgetStateProperty.all<TextStyle>(
          AppStyle.getFontStyle(
            color: AppColors.mainAppColor,
            fontSize: 14.sp,
          ),
        ),
        overlayColor: WidgetStateProperty.all<Color>(
          AppColors.mainAppColor.withValues(alpha: 0.1),
        ),
      ),
      confirmButtonStyle: ButtonStyle(
        textStyle: WidgetStateProperty.all<TextStyle>(
          AppStyle.getFontStyle(color: AppColors.mainAppColor, fontSize: 14.sp),
        ),
        overlayColor: WidgetStateProperty.all<Color>(
          AppColors.mainAppColor.withValues(alpha: 0.1),
        ),
      ),
    ),    inputDecorationTheme: InputDecorationTheme(
      focusColor: AppColors.mainAppColor,
      labelStyle:AppStyle.getFontStyle(color: AppColors.black),
      hintStyle:AppStyle.getFontStyle(color: AppColors.greyTitle),
      enabledBorder: OutlineInputBorder(
        gapPadding: 0,
        borderRadius: const BorderRadius.all(Radius.circular(12)).r,
        borderSide: const BorderSide(color: AppColors.textField),
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      titleTextStyle:AppStyle.getFontStyle(
        color: AppColors.black,
        fontWeight: FontWeight.w600,
        fontSize: 18.sp,
      ),
      iconTheme: IconThemeData(color: AppColors.mainAppColor, size: 18.sp),
    ),
    textTheme: TextTheme(
      bodyLarge:AppStyle.getFontStyle(color: AppColors.black),
      bodyMedium:AppStyle.getFontStyle(color: AppColors.black),
      titleMedium:AppStyle.getFontStyle(color: AppColors.black),
      titleSmall:AppStyle.getFontStyle(color: AppColors.black),
    ),
    iconTheme: const IconThemeData(color: AppColors.mainAppColor),
    dialogTheme: DialogThemeData(
      contentTextStyle:AppStyle.getFontStyle(color: AppColors.black),
      backgroundColor: AppColors.white,
      titleTextStyle:AppStyle.getFontStyle(
        color: AppColors.black,
        fontSize: 16.sp,
      ),
    ),
    // textButtonTheme: TextButtonThemeData(
    //   style: TextButton.styleFrom(backgroundColor: AppColors.mainAppColor),
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainAppColor,
        foregroundColor: AppColors.white,
      ),
    ),
  );
}
