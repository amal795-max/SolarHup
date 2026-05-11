
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "../helper/data_helper.dart";
import "app_colors.dart";

class AppStyle {

  static TextStyle getFontStyle({
     double ?fontSize,
     FontWeight? fontWeight,
    double ?height,
    Color? color,
  }) {
    final isArabic = Get.locale?.languageCode == 'ar';
    final selectedColor = color ?? (DataHelper.isDarkTheme(Get.context!) ? AppColors.white : AppColors.black);

    return isArabic
        ? GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: selectedColor,
      height: height,
    )
        : GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: selectedColor,
      height: height,
    );
  }
  static TextStyle get h1 =>  getFontStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle get h2 =>   getFontStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static TextStyle get h3 =>   getFontStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static TextStyle get h4 =>  getFontStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );
  static TextStyle get h5 => getFontStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle get h6 => getFontStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    height: 1.4,
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

  // ==================== LABEL STYLES ====================
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

  // ==================== BUTTON STYLES ====================
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
    color: AppColors.errorRed,
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


  static TextStyle get chartTitle =>  getFontStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  // ==================== LEGACY STYLES (for backward compatibility) ====================
  static TextStyle get labelStyle => getFontStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );
  static TextStyle get labelMoreStyle => getFontStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.mainAppColor,
  );
  static TextStyle get normalStyle => getFontStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get navTitle => getFontStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.mainAppColor,
  );




  static TextStyle get tapBarUnSelected =>  getFontStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w300,
    color: AppColors.black,
  );


  static TextStyle get underLineStyle => GoogleFonts.inter(
    fontSize: 14.sp,
    decoration: TextDecoration.underline,
  );


  // ==================== ADDED MISSING STYLES ====================
  static TextStyle get regularText =>  getFontStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
    color: AppColors.black,
  );



  static TextStyle get disabled => getFontStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );
}
