import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';

class ProductDataRowItem extends StatelessWidget {
  final String label;
  final String value;
  final Color backgroundColor;
  final bool showDivider;

  const ProductDataRowItem({
    super.key,
    required this.label,
    required this.value,
    required this.backgroundColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  label,
                  style: AppStyle.bodySmall,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                flex: 5,
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: AppStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (showDivider)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Divider(
                height: 1,
                color: AppColors.borderColor
                ,
              ),
            ),
        ],
      ),
    );
  }
}
