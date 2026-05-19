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
          mainAxisAlignment: alignment,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? AppColors.lightGrey,
            ),
            Text(
              title ?? 'No Items Added',
              textAlign: TextAlign.center,
              style: AppStyle.bodyMedium.copyWith(
                color: AppColors.grey,
              ),
            ),
            Text(
              subtitle ?? 'Add your first item',
              style: AppStyle.bodySmall.copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              action!,
            ]
          ],
        ),
      ),
    );
  }
}
