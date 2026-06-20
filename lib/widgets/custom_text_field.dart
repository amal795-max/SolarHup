import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

class CustomTextField extends StatefulWidget {
  final double? width;
  final bool  hasTitle;
  final TextEditingController? controller;
  final String? initialValue;
  final String title;
  final String? hint;
  final String? label;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isPassword;
  final bool readOnly;
  final bool isMultiline;
  final int? maxLines;
  final int? maxLength;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    this.width,
    this.hasTitle=true,
    this.controller,
    this.initialValue,
    required this.title,
    this.hint,
    this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.isPassword = false,
    this.readOnly = false,
    this.isMultiline = false,
    this.maxLines = 1,
    this.maxLength,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isPassword;

  @override
  void initState() {
    _isPassword = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
         widget.hasTitle?  Text(widget.title, style:context.textTheme.bodySmall):const SizedBox.shrink(),
          SizedBox(height: 5.h),
          TextFormField(
            onFieldSubmitted: widget.onFieldSubmitted ,
            controller: widget.controller,
            initialValue: widget.controller == null ? widget.initialValue : null,
            obscureText: _isPassword,
            validator: widget.validator,
            readOnly: widget.readOnly,
            maxLength: widget.maxLength,
            keyboardType: widget.isMultiline
                ? TextInputType.multiline
                : widget.keyboardType,
            maxLines: widget.isMultiline ? null : widget.maxLines,
            onTap: widget.onTap,
            focusNode: widget.focusNode,
            onChanged: widget.onChanged,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.h,
                horizontal: 12.w,
              ),
              hintText: widget.hint,
              filled: true,
              fillColor: context.colorScheme.tertiaryContainer,
              labelText: widget.label,
              hintStyle:  AppStyle.bodyXSmall.copyWith(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.lightGray),
              ),
              prefixIcon: widget.prefixIcon,
              prefixIconColor: AppColors.grey,
              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                  _isPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() => _isPassword = !_isPassword);
                },
              )
                  : widget.suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}
