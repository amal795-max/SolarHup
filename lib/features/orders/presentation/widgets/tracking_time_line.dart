// ignore_for_file: unused_element_parameter

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/data_helper.dart';

import '../../../../core/enums/order_status_enum.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../../data/models/order_model.dart';

class OrderTrackingTimeline extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingTimeline({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order.statusEnum;

    final isPending = status == OrderStatusEnum.pending;
    final isAccepted = status == OrderStatusEnum.accepted;
    final isInTransit = status == OrderStatusEnum.inTransit;
    final isDelivered = status == OrderStatusEnum.delivered;
    final isCompleted = status == OrderStatusEnum.completed;

    final hasPassedAccepted =
        isAccepted || isInTransit || isDelivered || isCompleted;
    final hasPassedInTransit = isInTransit || isDelivered || isCompleted;
    final hasPassedDelivered = isDelivered || isCompleted;

    String? formattedDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        final date = DateTime.parse(dateStr);
        return DataHelper.dateFormat(
          'MMM d, yyyy • hh:mm a',
          date,
          locale: context.locale,
        );
      } catch (_) {
        return dateStr;
      }
    }

    final items = <_TimelineStepData>[
      _TimelineStepData(
        title: 'tracking_created'.tr(),
        subtitle: 'order_placed_successfully'.tr(),
        date: formattedDate(order.createdAt),
        isCompleted: true,
        isCurrent: false,
      ),
      _TimelineStepData(
        title: 'accepted'.tr(),
        subtitle: 'order_accepted_desc'.tr(),
        isCompleted: hasPassedAccepted,
        isCurrent: isPending,
      ),
      _TimelineStepData(
        title: 'in_transit'.tr(),
        subtitle: 'order_in_transit_desc'.tr(),
        isCompleted: hasPassedInTransit,
        isCurrent: isAccepted,
      ),
      _TimelineStepData(
        title: 'tracking_delivered'.tr(),
        subtitle: 'order_delivered_desc'.tr(),
        isCompleted: hasPassedDelivered,
        isCurrent: isInTransit,
      ),
      _TimelineStepData(
        title: 'completed'.tr(),
        subtitle: 'order_completed_desc'.tr(),
        date: isCompleted ? formattedDate(order.updatedAt) : null,
        isCompleted: isCompleted,
        isCurrent: isDelivered,
        isLast: true,
      ),
    ];

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'order_tracking_title'.tr(),
            style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24.h),
          ...List.generate(items.length, (index) {
            return _TimelineItem(
              data: items[index],
              index: index,
              connectorFilled: !items[index].isLast &&
                  (items[index].isCompleted || items[index].isCurrent),
            );
          }),
        ],
      ),
    );
  }
}

class _TimelineStepData {
  final String title;
  final String subtitle;
  final String? date;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;

  const _TimelineStepData({
    required this.title,
    required this.subtitle,
    this.date,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isLast = false,
  });
}

class _TimelineItem extends StatelessWidget {
  final _TimelineStepData data;
  final int index;
  final bool connectorFilled;

  const _TimelineItem({
    required this.data,
    required this.index,
    required this.connectorFilled,
  });

  @override
  Widget build(BuildContext context) {
    final dot = _TimelineDot(
      isCompleted: data.isCompleted,
      isCurrent: data.isCurrent,
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              dot,
              if (!data.isLast)
                Expanded(
                  child: _AnimatedConnector(filled: connectorFilled),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: AppStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: data.isCompleted || data.isCurrent
                        ? null
                        : AppColors.grey,
                  ),
                ),
                Text(
                  data.subtitle,
                  style: AppStyle.bodySmall.copyWith(
                    color: AppColors.grey,
                    fontSize: 12.sp,
                  ),
                ),
                if (data.date != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      data.date!,
                      style: AppStyle.labelSmall.copyWith(
                        color: AppColors.primaryColor.withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 350.ms,
          delay: (index * 80).ms,
          curve: Curves.easeOut,
        )
        .slideX(
          begin: 0.06,
          end: 0,
          duration: 350.ms,
          delay: (index * 80).ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _TimelineDot extends StatefulWidget {
  final bool isCompleted;
  final bool isCurrent;

  const _TimelineDot({
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  State<_TimelineDot> createState() => _TimelineDotState();
}

class _TimelineDotState extends State<_TimelineDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isCurrent) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _TimelineDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrent && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isCurrent && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.value = 0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coreColor = widget.isCurrent
        ? AppColors.secondaryColor
        : widget.isCompleted
            ? AppColors.darkMode
            : AppColors.lightGrey;

    Widget dot = Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: coreColor,
        boxShadow: widget.isCurrent
            ? [
                BoxShadow(
                  color: AppColors.secondaryColor.withValues(alpha: 0.45),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: widget.isCurrent
          ? Center(
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
              ),
            )
          : widget.isCompleted
              ? Icon(Icons.check, color: Colors.white, size: 12.sp)
              : null,
    );

    if (widget.isCurrent) {
      dot = AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 + (_pulseController.value * 0.12),
            child: child,
          );
        },
        child: dot,
      );
    }

    return dot;
  }
}

class _AnimatedConnector extends StatelessWidget {
  final bool filled;

  const _AnimatedConnector({required this.filled});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        begin: AppColors.lightGrey,
        end: filled ? AppColors.darkMode : AppColors.lightGrey,
      ),
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
      builder: (context, color, child) {
        return Container(
          width: 2.w,
          color: color,
        );
      },
    );
  }
}
