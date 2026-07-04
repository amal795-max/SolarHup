import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

enum ButtonType { filled, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;
  final double? height;
  final double? width;
  final double borderRadius;
  final double borderWidth;
  final FontWeight fontWeight;
  final bool isLoading;
  final ButtonType type;
  final bool iconLeft;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.fontSize,
    this.height,
    this.width,
    this.borderRadius = 10,
    this.borderWidth = 1.2,
    this.fontWeight = FontWeight.w600,
    this.isLoading = false,
    this.type = ButtonType.filled,
    this.iconLeft = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolvedBg = switch (type) {
      ButtonType.filled => backgroundColor ?? AppColors.primaryColor,
      ButtonType.outlined => Colors.transparent,
      ButtonType.text => Colors.transparent,
    };

    final Color resolvedText = textColor ??
        (type == ButtonType.filled ? Colors.white : AppColors.primaryColor);

    final Color resolvedBorder = borderColor ??
        (type == ButtonType.outlined ? AppColors.primaryColor : Colors.transparent);

    return SizedBox(
      height: height ?? 48.h,
      width: width ?? double.infinity,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(resolvedBg),
          overlayColor: WidgetStateProperty.all(
            resolvedText.withOpacity(0.1),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius.r),
              side: BorderSide(
                color: resolvedBorder,
                width: borderWidth,
              ),
            ),
          ),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(horizontal: 12.w),
          ),
        ),
        child: isLoading
            ? SizedBox(
          height: 22.h,
          width: 22.h,
          child: CircularProgressIndicator(
            color: resolvedText,
            strokeWidth: 2,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null && iconLeft)
              Icon(icon, color: resolvedText, size: fontSize ?? 18.sp),

            if (icon != null && iconLeft) SizedBox(width: 8.w),

            Text(
              text.tr(),
              style: AppStyle.labelSmall.copyWith(
                color: resolvedText,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),

            if (icon != null && !iconLeft) SizedBox(width: 8.w),

            if (icon != null && !iconLeft)
              Icon(icon, color: resolvedText, size: fontSize ?? 18.sp),
          ],
        ),
      ),
    );
  }
}
