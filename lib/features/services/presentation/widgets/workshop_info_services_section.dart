import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/catalog/utils/discount_period_formatter.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_info_screen.dart';
import 'package:untitled1/widgets/discount_meta_lines.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/image_widget.dart';
import 'package:untitled1/widgets/workshop_service_favorite_button.dart';

class WorkshopInfoServicesSection extends StatelessWidget {
  final String workshopId;
  final String workshopName;
  final List<WorkshopServiceItem> services;
  final String? selectedServiceId;
  final ValueChanged<String> onServiceSelected;

  const WorkshopInfoServicesSection({
    super.key,
    required this.workshopId,
    required this.workshopName,
    required this.services,
    required this.selectedServiceId,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final parsedWorkshopId = int.tryParse(workshopId);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'workshop_info_services'.tr(),
            style: AppStyle.h6.copyWith(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 4.h),
          Text(
            'workshop_select_service_hint'.tr(),
            style: AppStyle.bodySmall.copyWith(color: AppColors.grey),
          ),
          SizedBox(height: 14.h),
          if (services.isEmpty)
            EmptyWidget(
              icon: Icons.handyman_outlined,
              iconSize: 48,
              iconColor: AppColors.grey,
              title: 'services_no_results'.tr(),
              subtitle: 'workshop_info_no_services_hint'.tr(),
              padding: EdgeInsets.symmetric(vertical: 24.h),
            )
          else
            ...services.map(
              (service) => _WorkshopServiceTile(
                workshopId: parsedWorkshopId,
                workshopName: workshopName,
                service: service,
                isSelected: service.id == selectedServiceId,
                isDark: isDark,
                onTap: () => onServiceSelected(service.id),
              ),
            ),
        ],
      ),
    );
  }
}

class _WorkshopServiceTile extends StatelessWidget {
  final int? workshopId;
  final String workshopName;
  final WorkshopServiceItem service;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _WorkshopServiceTile({
    required this.workshopId,
    required this.workshopName,
    required this.service,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = _isValidImageUrl(service.imageUrl);
    final parsedServiceId = int.tryParse(service.id);

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkContainer : AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.secondaryColor
                    : (isDark ? AppColors.darkGray : AppColors.lightGrey),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isDark || !isSelected
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.secondaryColor.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SizedBox(
                    width: 56.w,
                    height: 56.w,
                    child: hasImage
                        ? ImageWidget(
                            image: service.imageUrl,
                            width: 56.w,
                            height: 56.w,
                            borderRadius: 12,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Color(service.imagePlaceholderColorValue)
                                .withValues(alpha: 0.25),
                            child: Icon(
                              Icons.handyman_outlined,
                              color: AppColors.primaryColor,
                              size: 24.sp,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: AppStyle.labelMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (service.description != null) ...[
                        SizedBox(height: 3.h),
                        Text(
                          service.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyle.bodySmall.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          if (service.hasDiscount)
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    '\$${service.originalPrice!.toStringAsFixed(2)}',
                                    style: AppStyle.labelSmall.copyWith(
                                      color: AppColors.grey,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: AppColors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    '\$${service.price.toStringAsFixed(2)}',
                                    style: AppStyle.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Text(
                              '\$${service.price.toStringAsFixed(2)}',
                              style: AppStyle.bodyMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          if (service.durationMinutes > 0) ...[
                            SizedBox(width: 8.w),
                            Container(
                              width: 4.w,
                              height: 4.w,
                              decoration: const BoxDecoration(
                                color: AppColors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'services_duration_minutes'.tr(
                                namedArgs: {
                                  'minutes': '${service.durationMinutes}',
                                },
                              ),
                              style: AppStyle.labelXSmall.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (service.hasDiscount &&
                          hasDiscountMeta(
                            description: service.discountDescription,
                            startDate: service.discountStartDate,
                            endDate: service.discountEndDate,
                          )) ...[
                        SizedBox(height: 4.h),
                        DiscountMetaLines(
                          description: service.discountDescription,
                          startDate: service.discountStartDate,
                          endDate: service.discountEndDate,
                          compact: true,
                        ),
                      ],
                    ],
                  ),
                ),
                if (workshopId != null && parsedServiceId != null) ...[
                  SizedBox(width: 4.w),
                  WorkshopServiceFavoriteButton(
                    workshopId: workshopId!,
                    serviceId: parsedServiceId,
                    workshopName: workshopName,
                    iconSize: 20.sp,
                    backgroundColor: Colors.transparent,
                  ),
                ],
                SizedBox(width: 4.w),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.secondaryColor
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondaryColor
                          : AppColors.grey,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          size: 16.sp,
                          color: AppColors.tertiaryColor,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool _isValidImageUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  final uri = Uri.tryParse(url);
  return uri != null && uri.isAbsolute;
}
