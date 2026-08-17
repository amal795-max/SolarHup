import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/image_url_utils.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/reviews/presentation/utils/reviews_navigation.dart';
import 'package:untitled1/features/reviews/presentation/widgets/review_summary_indicator.dart';
import 'package:untitled1/features/services/presentation/mappers/workshop_picker_mapper.dart';
import 'package:untitled1/widgets/image_widget.dart';

class WorkshopPickerCard extends StatelessWidget {
  final WorkshopPickerGroup group;
  final VoidCallback? onTap;

  const WorkshopPickerCard({super.key, required this.group, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasCover = isDisplayableImageUrl(group.coverImageUrl);
    final hasLogo = isDisplayableImageUrl(group.logoUrl);
    final workshopId = int.tryParse(group.workshopId) ?? 0;
    final base = Color(group.iconColorValue);
    final darker = Color.fromARGB(
      255,
      (base.r * 0.35).round(),
      (base.g * 0.35).round(),
      (base.b * 0.35).round(),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          child: Ink(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkContainer : AppColors.white,
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 120.h,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (hasCover)
                          ImageWidget(
                            image: group.coverImageUrl,
                            fit: BoxFit.cover,
                            borderRadius: 0,
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [darker, base],
                              ),
                            ),
                          ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.05),
                                Colors.black.withValues(alpha: 0.45),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10.h,
                          right: 10.w,
                          child: ReviewSummaryIndicator(
                            itemType: 'workshop',
                            itemId: workshopId,
                            variant: ReviewSummaryVariant.workshopBanner,
                            onTap: () {
                              openReviewsScreen(
                                context,
                                itemType: 'workshop',
                                itemId: workshopId,
                                itemName: group.workshopName,
                              );
                            },
                          ),
                        ),
                        Positioned(
                          left: 14.w,
                          bottom: 14.h,
                          right: 14.w,
                          child: Row(
                            children: [
                              Container(
                                width: 44.w,
                                height: 44.w,
                                decoration: BoxDecoration(
                                  color: hasLogo
                                      ? AppColors.white
                                      : base.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.white,
                                    width: 2,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: hasLogo
                                    ? ImageWidget(
                                        image: group.logoUrl,
                                        width: 44.w,
                                        height: 44.w,
                                        borderRadius: 12,
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(
                                        Icons.build_rounded,
                                        color: AppColors.secondaryColor,
                                        size: 22.sp,
                                      ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  group.workshopName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyle.labelLarge.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w800,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 15.sp,
                                    color: AppColors.grey,
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      group.location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyle.bodySmall.copyWith(
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'workshop_services_count'.tr(
                                  namedArgs: {'count': '${group.serviceCount}'},
                                ),
                                style: AppStyle.labelXSmall.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'services_starting_at'.tr(),
                              style: AppStyle.labelXSmall.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                            Text(
                              '\$${group.startingPrice.toStringAsFixed(2)}',
                              style: AppStyle.h6.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w800,
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
          ),
        ),
      ),
    );
  }
}
