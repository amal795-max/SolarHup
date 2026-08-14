import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_cubit.dart';
import 'package:untitled1/features/favorite/presentation/bloc/favorites_state.dart';
import 'package:untitled1/features/services/data/models/expert_service_model.dart';
import 'package:untitled1/features/services/data/models/service_booking_draft.dart';
import 'package:untitled1/widgets/primary_button.dart';
import 'package:untitled1/widgets/text_with_icon.dart';

import '../../../../core/helper/extensions.dart';

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
    final titleColor = context.brightness ? AppColors.blue : AppColors.primaryColor;

    return Material(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      elevation: context.brightness ? 0 : 1,
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
                    style:AppStyle.bodyMedium.copyWith(
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
                      Flexible(
                        child: Text(
                          service.title,
                          style: AppStyle.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                            height: 1.3,
                          ),
                        ),
                      ),
                      TextWithIcon(
                        title: service.rating.toStringAsFixed(1),
                        icon: Icons.star_rounded,
                        color: AppColors.tertiaryColor,
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
                              ? AppColors.blue.withValues(alpha: 0.19)
                              : (context.brightness
                                    ? context.colorScheme.tertiaryContainer
                                    : AppColors.lightGrey),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          badge,
                          style:AppStyle.bodyMedium.copyWith(
                            color: isPrimary
                                ? AppColors.primaryColor
                                : AppColors.deepGrey,
                            letterSpacing: 0.2,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    children: [
                      BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, state) {
                          final isFav = context.read<FavoritesCubit>().isFavorite('service', service.id);
                          return IconButton(
                            onPressed: () => context.read<FavoritesCubit>().toggleFavorite('service',  service.id),
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : AppColors.grey,
                              size: 24.sp,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          );
                        },
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 96.w,
                        height: 36.h,
                        child: CustomButton(
                          text: 'services_book_now'.tr(),
                          height: 36.h,
                          fontSize: 12.sp,
                          textColor: AppColors.blue,
                          onPressed:
                              onBookTap ??
                              () => context.push(
                                    AppRoutes.scheduleService(
                                      service.id.toString(),
                                    ),
                                    extra: ServiceBookingDraft(
                                      serviceId: service.id,
                                      serviceName: service.title,
                                      servicePrice: service.price,
                                    ),
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
