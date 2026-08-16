import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum OrderStatusEnum {
  pending(
    'pending',
    AppColors.pendingBg,
    AppColors.pendingBorder,
  ),

  accepted(
    'accepted',
    AppColors.acceptedBg,
    AppColors.acceptedBorder,
  ),

  inTransit(
    'in_transit',
    AppColors.inTransitBg,
    AppColors.inTransitBorder,
  ),

  rejected(
    'rejected',
    AppColors.rejectedBg,
    AppColors.rejectedBorder,
  ),

  delivered(
    'delivered',
    AppColors.deliveredBg,
    AppColors.deliveredBorder,
  );

  final String status;
  final Color backgroundColor;
  final Color borderAndLabelColor;

  const OrderStatusEnum(
      this.status,
      this.backgroundColor,
      this.borderAndLabelColor,
      );

  static OrderStatusEnum fromString(String status) {
    switch (status.trim()) {
      case 'pending_approval':
        return OrderStatusEnum.pending;
      case 'accepted':
        return OrderStatusEnum.accepted;
      case 'in_transit':
        return OrderStatusEnum.inTransit;
      case 'delivered':
      case 'completed':
        return OrderStatusEnum.delivered;
      case 'rejected':
      case 'cancelled':
        return OrderStatusEnum.rejected;
      default:
        return OrderStatusEnum.pending;
    }
  }
}
