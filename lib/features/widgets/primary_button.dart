import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "../../core/constants/app_colors.dart";
import "loader.dart";

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.title,
    super.key,
    this.onTap,
    this.message = "Please Wait !!",
    this.radiusLoader = 35,
    this.width,
    this.height,
    this.color = AppColors.mainAppColor,
    this.borderColor = AppColors.mainAppColor,
    this.messageColor = AppColors.mainAppColor,
    this.titleColor = AppColors.white,
    this.iconColor = AppColors.white,
    this.isLoading = false,
    this.disable = false,
    this.loaderColor = AppColors.secondaryAppColor,
    this.hasIcon,
    this.hasBorder = false,
    this.icon,
  });

  final String title;
  final String message;
  final dynamic Function()? onTap;
  final Color color;
  final Color messageColor;
  final Color borderColor;
  final Color titleColor;
  final Color iconColor;
  final bool isLoading;
  final bool disable;
  final double radiusLoader;
  final double? width;
  final double? height;
  final Color loaderColor;
  final bool? hasIcon;
  final bool? hasBorder;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
      (isLoading || disable)
          ? () {
        Get.snackbar(
          message,
          "",
          colorText: AppColors.white,
          backgroundColor: Colors.red,
        );
      }
          : onTap,
      child:
      Container(
        height: height ?? 40.h,
        width: width ?? 0.85.sw,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16).r,
          color: !disable ? color : AppColors.grey,
          border:
          hasBorder! ? Border.all(color: borderColor, width: 1.w) : null,
        ),
        child: Center(
          child:
          isLoading
              ? ImageLoader(radius: radiusLoader.r, color: loaderColor)
              : Material(
            type: MaterialType.transparency,
            child: Row(
              spacing: 6,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(color: titleColor, fontSize: 16.sp),
                ),
                hasIcon == true
                    ? Icon(icon, color: iconColor)
                    : Container(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
