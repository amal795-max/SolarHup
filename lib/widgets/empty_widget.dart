import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_style.dart';
import '../core/theme/app_colors.dart';

class EmptyWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData icon;
  final double iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry padding;
  final Widget? action;
  final MainAxisAlignment alignment;

  const EmptyWidget({
    super.key,
    this.title,
    this.subtitle,
    this.icon = Icons.inventory_2_outlined,
    this.iconSize = 64,
    this.iconColor,
    this.padding = const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
    this.action,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          spacing: 4,
          mainAxisAlignment: alignment,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? AppColors.lightGrey,
            ),
            Text(
              title?.tr()?? 'no_items_added'.tr(),
              textAlign: TextAlign.center,
              style: AppStyle.bodyMedium.copyWith(
                color: AppColors.grey,
              ),
            ),
            Text(
              subtitle?.tr() ?? 'add_your_first_item'.tr(),
              style: AppStyle.bodySmall.copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4,),
            if (action != null) ...[
              action!,
            ]
          ],
        ),
      ),
    );
  }
}
