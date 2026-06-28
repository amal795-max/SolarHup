
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import'app_colors.dart';

class AppStyle {

  static TextStyle getFontStyle({
    double ?fontSize,
    FontWeight? fontWeight,
    double ?height,
    Color? color,
  }) {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

    final selectedColor = color ?? (brightness == Brightness.dark ? AppColors.white : AppColors.black);
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: selectedColor,
      height: height,
    );


  }
  static TextStyle get h1 =>  getFontStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get h2 =>   getFontStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get h3 =>   getFontStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get h4 =>  getFontStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle get h5 => getFontStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,

  );
  static TextStyle get h6 => getFontStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get bodyLarge =>   getFontStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle get bodyMedium =>   getFontStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle get bodySmall => getFontStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get bodyXSmall =>   getFontStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle get labelXLarge =>  getFontStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle get labelLarge =>  getFontStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelMedium =>  getFontStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelSmall =>  getFontStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );
  static TextStyle get labelXSmall =>  getFontStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get buttonLarge =>  getFontStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );

  static TextStyle get buttonMedium =>  getFontStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static TextStyle get buttonSmall =>  getFontStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static TextStyle get buttonOutlined =>  getFontStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  // ==================== INPUT STYLES ====================
  static TextStyle get inputText =>  getFontStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle get inputLabel =>  getFontStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );



  static TextStyle get inputError =>  getFontStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.red,
    height: 1.4,
  );

  // ==================== CARD STYLES ====================
  static TextStyle get labelMediumCard =>  getFontStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelSmallCard =>  getFontStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  static TextStyle get labelXSmallCard =>  getFontStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get labelMoreStyle =>  getFontStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.primaryColor
  );


  static TextStyle get disabled => getFontStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );
}