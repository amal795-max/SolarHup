import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/chatbot/data/model/recommend_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:untitled1/widgets/image_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';

import '../../../../core/helper/extensions.dart';
import '../../../services/presentation/pages/workshop_info_route_args.dart';

class ChatServiceCard extends StatelessWidget {
  final RecommendedService service;

  const ChatServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final s = service.service;

    return Container(
      margin: EdgeInsets.only(left: 44.w, bottom: 16.h),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.borderColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: (s.images.isNotEmpty)
                ? ImageWidget(image: s.images.first)
                : const SizedBox(),
          ),

          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.name,
                  style: AppStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(s.description, style: AppStyle.bodySmall),
                Text('${"price".tr()}: ${s.price}', style: AppStyle.bodyMedium),
                Text(
                  '${"duration".tr()}: ${s.estimatedDuration} ${"minutes".tr()}',
                  style: AppStyle.bodySmall,
                ),
                SizedBox(height: 8.h),
                Text(
                  service.reason,
                  style: AppStyle.bodySmall.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 8.h),
                CustomButton(
                    height: 40,
                    width: 200,
                    text: 'view_service'.tr(),
                    onPressed: () {
                      context.push(
                        AppRoutes.workshopInfoScreen,
                        extra: WorkshopInfoRouteArgs(
                          workshopId: s.businessId.toString(),
                          categoryId: s.categoryId,
                          highlightServiceId: s.id.toString(),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
