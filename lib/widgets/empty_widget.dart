import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final bool animate;

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
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Padding(
        padding: padding,
        child: SingleChildScrollView(
          child: Column(
            spacing: 4,
            mainAxisAlignment: alignment,
            children: [
              Container(
                width: (iconSize + 28).w,
                height: (iconSize + 28).w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.secondaryColor.withValues(alpha: 0.22),
                      AppColors.primaryColor.withValues(alpha: 0.04),
                    ],
                  ),
                ),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: iconColor ?? AppColors.primaryColor.withValues(alpha: 0.55),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                title?.tr() ?? 'no_items_added'.tr(),
                textAlign: TextAlign.center,
                style: AppStyle.bodyMedium.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle == null || subtitle!.isNotEmpty)
                Text(
                  subtitle?.tr() ?? 'add_your_first_item'.tr(),
                  style: AppStyle.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 8.h),
              if (action != null) action!,
            ],
          ),
        ),
      ),
    );

    if (!animate) return content;

    return content
        .animate()
        .fadeIn(duration: 450.ms, curve: Curves.easeOut)
        .slideY(begin: 0.08, end: 0, duration: 450.ms, curve: Curves.easeOutCubic);
  }
}
