import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";

import "../../../core/constants/app_colors.dart";
import "../../../core/constants/app_style.dart";

class CustomMainTextField extends StatefulWidget {
  const CustomMainTextField({
    required this.validator,
    super.key,
    this.hintText,
    this.title,
    this.onChanged,
    this.passwordVisible = true,
    this.readOnly = false,
    this.isPasswordField = false,
    this.isBirthField = false,
    this.hasIcon = false,
    this.isNameField = false,
    this.showNumberPrefix = false,
    this.withTitle = false,
    this.initValue,
    this.controller,
    this.validatorInput,
    this.clickIcon,
    this.suffixIcon,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.onFieldSubmitted,
    this.icon,
  });

  final FormFieldValidator<String>? validatorInput;
  final String? hintText;
  final dynamic Function(String)? onChanged;
  final dynamic Function()? clickIcon;
  final bool passwordVisible;
  final bool readOnly;
  final bool isPasswordField;
  final bool isBirthField;
  final bool hasIcon;
  final bool showNumberPrefix;
  final bool isNameField;
  final bool withTitle;
  final String? initValue;
  final String? title;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final String? Function(String?) validator;
  final dynamic Function(String?)? onFieldSubmitted;
  final String? icon;
  final IconData? suffixIcon;

  @override
  State<CustomMainTextField> createState() => _CustomMainTextFieldState();
}

class _CustomMainTextFieldState extends State<CustomMainTextField> {
  bool _isPasswordField = false;

  Widget get secureWidget => IconButton(
    onPressed: () {
      setState(() {
        _isPasswordField = !_isPasswordField;
      });
    },
    icon: _isPasswordField
        ? Icon(Icons.visibility_off_outlined, color: AppColors.greyIcon)
        : Icon(Icons.visibility_outlined, color: AppColors.greyIcon),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((widget.withTitle) && (widget.title != null)) ...[
          Text(widget.title ?? "", style: AppStyle.bodySmall),
        ],
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: TextFormField(
            controller: widget.controller,
            readOnly: widget.readOnly,
            focusNode: widget.focusNode,
            initialValue: widget.initValue,
            validator: widget.validator,
            textInputAction: TextInputAction.next,

            keyboardType: widget.keyboardType,
            // textDirection: isRTL?TextDirection.ltr:TextDirection.ltr,
            obscureText: _isPasswordField,
            onFieldSubmitted: widget.onFieldSubmitted,
            onChanged: widget.onChanged,
            style: TextStyle(
              fontSize: 14.sp,
              color: widget.readOnly ? AppColors.greyTitle : null,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.grey),
              prefixIcon: widget.hasIcon
                  ? InkWell(
                      onTap: widget.clickIcon,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 14,
                          right: 14,
                          top: 6,
                          bottom: 6,
                        ).r,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              SvgPicture.asset(
                                widget.icon!,
                                height: 20.r,
                                width: 20.r,
                                colorFilter: ColorFilter.mode(
                                  widget.focusNode?.hasFocus ?? false
                                      ? AppColors.mainAppColor
                                      : AppColors.greyIcon,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                            if (widget.showNumberPrefix) ...[
                              const SizedBox(width: 10),
                              Text(
                                "0963",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.lightGray,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  : null,

              suffixIcon: widget.isPasswordField
                  ? secureWidget
                  : widget.isBirthField
                  ? IconButton(
                      icon: Text(
                        "DD/MM/YY",
                        style: TextStyle(color: AppColors.mainAppColor, fontSize: 14.sp),
                      ),
                      onPressed: widget.clickIcon,
                    )
                  : Icon(widget.suffixIcon, color: AppColors.mainAppColor),
              enabledBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)).r,
                borderSide: const BorderSide(color: AppColors.lightGray),
              ),
              border: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)).r,
                borderSide: const BorderSide(color: AppColors.lightGray),
              ),

              focusedBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.all(const Radius.circular(16.0).r),
                borderSide: const BorderSide(color: AppColors.grey),
              ),
              errorBorder: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)).r,
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter implements TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
