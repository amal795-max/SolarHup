import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_style.dart';
import '../core/theme/app_colors.dart';

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.withTapOnTitle = false,
  });

  final bool value;
  final String title;
  final bool withTapOnTitle;
  final dynamic Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title,style: AppStyle.labelSmall,),
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.zero,
          value: value,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: onChanged,
           activeColor: AppColors.secondaryColor,
          checkColor: AppColors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0).r,
          ),
          side: WidgetStateBorderSide.resolveWith(
            (states) => BorderSide(
              width: 1.0.w,
              color: (value) ? AppColors.primaryColor : AppColors.grey,
            ),
          ),
    );
  }
}
