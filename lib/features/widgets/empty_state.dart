import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_style.dart';
import '../../core/constants/space_xy.dart';

Widget emptyState({title, subtitle}) {
  return Center(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 40),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: AppColors.lightContainer,
          ),
          14.0.spaceY,
          Text(
            title??'No Items Added'.tr,
            textAlign: TextAlign.center,
            style: AppStyle.bodyMedium.copyWith(
              color: AppColors.gray,
            ),
          ),
          8.0.spaceY,
          Text(
            subtitle??'Add your first item'.tr,
            style: AppStyle.bodySmall.copyWith(
              color: AppColors.greyTitle,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

