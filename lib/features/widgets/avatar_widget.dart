import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/space_xy.dart';
import 'image_widget.dart';
import 'primary_button.dart';

Widget avatarImage({required String image,double?r, Function()?onDelete, Function()?onUpload}){
  return GestureDetector(
    onTap: () {
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageWidget(
                  height: 300.h,
                  width: 300.w,
                  image: image,
                  fit: BoxFit.cover,
                ),

              12.0.spaceY,
              PrimaryButton(
                  color: Colors.transparent,
                  title: "upload image".tr,
                  icon: Icons.edit,
                  hasIcon: true,
                  onTap: onUpload
              )    ,
              image.isNotEmpty?
              PrimaryButton(
                  color: Colors.transparent,
                  title: "delete".tr,
                  icon: Icons.delete,
                  hasIcon: true,
                  onTap:onDelete
              ):SizedBox()
            ],
          ),
        ),
      );

    },
    child: CircleAvatar(
      radius: r??22.r,
      backgroundColor: AppColors.lightGray,
      child:image.isNotEmpty? ImageWidget(image: image):null,
    ),
  );
}