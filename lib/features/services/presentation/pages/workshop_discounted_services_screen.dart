import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/home/presentation/widgets/product_card.dart';
import 'package:untitled1/features/services/presentation/mappers/workshop_info_mapper.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_discounted_services_route_args.dart';
import 'package:untitled1/widgets/empty_widget.dart';

class WorkshopDiscountedServicesScreen extends StatelessWidget {
  final WorkshopDiscountedServicesRouteArgs args;

  const WorkshopDiscountedServicesScreen({super.key, required this.args});

  int get _businessId => int.tryParse(args.workshopId) ?? 0;

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;

    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : AppColors.backGroundGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'workshop_info_special_offers'.tr(),
                          style: AppStyle.h6.copyWith(fontWeight: FontWeight.w800),
                        ),
                        if (args.workshopName.isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            args.workshopName,
                            style: AppStyle.bodySmall.copyWith(
                              color: AppColors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: args.services.isEmpty
                  ? EmptyWidget(
                      icon: Icons.local_offer_outlined,
                      iconSize: 48,
                      iconColor: AppColors.grey,
                      title: 'discounted_products_empty'.tr(),
                      subtitle: 'discounted_products_empty_hint'.tr(),
                      padding: EdgeInsets.symmetric(vertical: 32.h),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 0.72.r,
                      ),
                      itemCount: args.services.length,
                      itemBuilder: (context, index) {
                        final service = args.services[index];
                        return ProductCard(
                          data: workshopServiceToCardData(
                            service: service,
                            businessId: _businessId,
                          ),
                          fillWidth: true,
                          onTap: () => context.pop(service.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
