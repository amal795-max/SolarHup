import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
enum DeliveryStatusEnum {
  pending("Pending", AppColors.lightGray, AppColors.grey, true, "Accept"),
  assigned("Accepted", AppColors.orange, AppColors.lightOrange, true, "Start"),
  pickedUp("Head to pickup", AppColors.blue, AppColors.lightBlue, true,"Picked up"),
  dropOff("Head to drop-off", AppColors.orange, AppColors.lightOrange, true,"Delivered");

  final String status;
  final Color backgroundColor;
  final Color borderAndLabelColor;
  final bool hasButton;
  final String? nextStatus;

  const DeliveryStatusEnum(
      this.status,
      this.backgroundColor,
      this.borderAndLabelColor,
      this.hasButton, [
        this.nextStatus,
      ]);
}