import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/data/models/expert_service_model.dart';
import 'package:untitled1/widgets/primary_button.dart';
import 'package:untitled1/widgets/text_with_icon.dart';

class ServiceCard extends StatelessWidget {
  final ExpertServiceModel service;
  final VoidCallback? onBookTap;

  const ServiceCard({super.key, required this.service, this.onBookTap});

  IconData _iconForType(String type) => switch (type) {
    'repair' => Icons.electrical_services_rounded,
    'installation' => Icons.solar_power_rounded,
    _ => Icons.engineering_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      elevation: isDark ? 0 : 1,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Column(
                children: [
                  Container(
                    width: 72.w,
                    height: 72.w,
                    color: Color(service.imagePlaceholderColorValue),
                    child: Icon(
                      _iconForType(service.iconType),
                      size: 32.sp,
                      color: AppColors.grey.withValues(alpha: 0.55),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    '\$${service.price.toStringAsFixed(0)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  TextWithIcon(
                    title: service.durationLabel,
                    icon: Icons.schedule_rounded,
                    color: AppColors.grey,
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                          height: 1.3,
                        ),
                      ),
                      TextWithIcon(
                        title: service.rating.toStringAsFixed(1),
                        icon: Icons.star_rounded,
                        color: AppColors.secondaryColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: service.badges.map((badge) {
                      final isPrimary =
                          badge.contains('NABCEP') || badge.contains('MASTER');
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: isPrimary
                              ? AppColors.blue.withValues(alpha: 0.12)
                              : (isDark
                                    ? theme.colorScheme.tertiaryContainer
                                    : AppColors.lightGrey),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          badge,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isPrimary
                                ? AppColors.primaryColor
                                : AppColors.grey,
                            letterSpacing: 0.2,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: 96.w,
                        height: 36.h,
                        child: CustomButton(
                          text: 'services_book_now'.tr(),
                          height: 36.h,
                          fontSize: 12.sp,
                          onPressed:
                              onBookTap ??
                              () => context.push(
                                AppRoutes.scheduleService(service.id),
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
