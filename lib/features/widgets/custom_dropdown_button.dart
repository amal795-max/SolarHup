import 'package:driver_app/features/screens/earnings/controller/drop_down_controller.dart';
import 'package:driver_app/features/screens/earnings/controller/statistics_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_style.dart';
import '../../core/enums/date_enum.dart';

customDropDownButton() {
  final enumItems = DateEnum.values.map((item) {
    return DropdownMenuItem<String>(
      value: item.date,
      child: Center(
        child: Text(
          item.date.tr,
          style: AppStyle.buttonMedium.copyWith(color: AppColors.mainAppColor),
        ),
      ),
    );
  }).toList();

  return GetBuilder<DropDownController>(
    init: DropDownController(),
    builder: (controller) {
      return DropdownButton2(
        isExpanded: true,
        onChanged: (val) {
          controller.selectedDateValue=val! ;
          controller.update();
          Get.find<StatisticsController>().getStatistics(controller.selectedDateValue);

        },
        underline: SizedBox(),
        value: controller.selectedDateValue,
        items: enumItems,
        buttonStyleData: ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          height: 35.h,
          width: 140.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(color: AppColors.mainAppColor, width: 1.2),

          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.mainAppColor),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 170.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
      );
    },
  );
}
