import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/features/home/presentation/widgets/product_card.dart';
import 'package:untitled1/features/services/presentation/mappers/workshop_info_mapper.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_discounted_services_route_args.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_info_screen.dart';
import 'package:untitled1/widgets/label_title_widget.dart';

class WorkshopInfoDiscountsSection extends StatelessWidget {
  final String workshopId;
  final String workshopName;
  final List<WorkshopServiceItem> services;
  final ValueChanged<String> onServiceTap;

  const WorkshopInfoDiscountsSection({
    super.key,
    required this.workshopId,
    required this.workshopName,
    required this.services,
    required this.onServiceTap,
  });

  int get _businessId => int.tryParse(workshopId) ?? 0;

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: LabelWidget(
              title: 'workshop_info_special_offers'.tr(),
              more: 'home_view_all'.tr(),
              onTap: () async {
                final selectedId = await context.push<String>(
                  AppRoutes.workshopDiscountedServicesScreen,
                  extra: WorkshopDiscountedServicesRouteArgs(
                    workshopId: workshopId,
                    workshopName: workshopName,
                    services: services,
                  ),
                );
                if (selectedId != null) onServiceTap(selectedId);
              },
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 260.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: services.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final service = services[index];
                return ProductCard(
                  data: workshopServiceToCardData(
                    service: service,
                    businessId: _businessId,
                  ),
                  onTap: () => onServiceTap(service.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
