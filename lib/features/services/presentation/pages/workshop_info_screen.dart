import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/helper/image_url_utils.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/services/data/models/service_booking_draft.dart';
import 'package:untitled1/features/services/presentation/bloc/workshop_detail_cubit/workshop_detail_cubit.dart';
import 'package:untitled1/features/services/presentation/mappers/workshop_info_mapper.dart';
import 'package:untitled1/features/services/presentation/pages/workshop_info_route_args.dart';
import 'package:untitled1/features/services/presentation/widgets/workshop_info_discounts_section.dart';
import 'package:untitled1/features/services/presentation/widgets/workshop_info_services_section.dart';
import 'package:untitled1/widgets/app_skeletonizer.dart';
import 'package:untitled1/widgets/back_button_widget.dart';
import 'package:untitled1/widgets/error_widget.dart';
import 'package:untitled1/widgets/image_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';

class WorkshopInfoData {
  final String id;
  final String name;
  final String description;
  final String location;
  final String phone;
  final String region;
  final int imagePlaceholderColorValue;
  final String? logoUrl;
  final String? coverImageUrl;
  final List<WorkshopServiceItem> services;
  final List<WorkshopServiceItem> discountedServices;

  const WorkshopInfoData({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.phone,
    required this.region,
    required this.imagePlaceholderColorValue,
    this.logoUrl,
    this.coverImageUrl,
    required this.services,
    this.discountedServices = const [],
  });
}

class WorkshopServiceItem {
  final String id;
  final String name;
  final String? description;
  final double price;
  final double? originalPrice;
  final int? discountPercent;
  final String? badgeText;
  final String? discountDescription;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;
  final int durationMinutes;
  final String? imageUrl;
  final int imagePlaceholderColorValue;

  const WorkshopServiceItem({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    this.badgeText,
    this.discountDescription,
    this.discountStartDate,
    this.discountEndDate,
    required this.durationMinutes,
    this.imageUrl,
    required this.imagePlaceholderColorValue,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
}

final WorkshopInfoData sampleWorkshopInfo = const WorkshopInfoData(
  id: 'workshop-001',
  name: 'Solar Fix Workshop',
  description: 'Professional solar maintenance and repair services.',
  location: 'Damascus, Syria',
  phone: '+963912345678',
  region: 'Damascus',
  imagePlaceholderColorValue: 0xFF0A2A43,
  services: [
    WorkshopServiceItem(
      id: '1',
      name: 'Inverter Repair Visit',
      description: 'On-site inverter diagnostics and repair.',
      price: 200,
      durationMinutes: 120,
      imagePlaceholderColorValue: 0xFF0A2A43,
    ),
  ],
);

class WorkshopInfoScreen extends StatelessWidget {
  final WorkshopInfoRouteArgs args;

  const WorkshopInfoScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<WorkshopDetailCubit>()
            ..loadWorkshop(args.workshopId, categoryId: args.categoryId),
      child: _WorkshopInfoView(args: args),
    );
  }
}

class _WorkshopInfoView extends StatelessWidget {
  final WorkshopInfoRouteArgs args;

  const _WorkshopInfoView({required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WorkshopDetailCubit, WorkshopDetailState>(
        builder: (context, state) {
          return switch (state) {
            WorkshopDetailLoading() => AppSkeletonizer(
              child: _WorkshopInfoContent(
                data: sampleWorkshopInfo,
                initialSelectedServiceId: args.highlightServiceId,
              ),
            ),
            WorkshopDetailError(:final message) => errorWidget(
              message: message,
              hasButton: true,
              onPressed: () => context.read<WorkshopDetailCubit>().loadWorkshop(
                args.workshopId,
                categoryId: args.categoryId,
              ),
            ),
            WorkshopDetailLoaded(
              :final workshop,
              :final services,
              :final discounts,
            ) =>
              _WorkshopInfoContent(
                data: workshopDetailToInfoData(
                  workshop,
                  services,
                  discounts: discounts,
                ),
                initialSelectedServiceId: args.highlightServiceId,
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _WorkshopInfoContent extends StatefulWidget {
  final WorkshopInfoData data;
  final String? initialSelectedServiceId;

  const _WorkshopInfoContent({
    required this.data,
    this.initialSelectedServiceId,
  });

  @override
  State<_WorkshopInfoContent> createState() => _WorkshopInfoContentState();
}

class _WorkshopInfoContentState extends State<_WorkshopInfoContent> {
  String? _selectedServiceId;

  @override
  void initState() {
    super.initState();
    _selectedServiceId = widget.initialSelectedServiceId;
    if (_selectedServiceId == null && widget.data.services.length == 1) {
      _selectedServiceId = widget.data.services.first.id;
    }
  }

  WorkshopServiceItem? get _selectedService {
    if (_selectedServiceId == null) return null;
    for (final service in widget.data.services) {
      if (service.id == _selectedServiceId) return service;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    final data = widget.data;
    final selected = _selectedService;

    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : AppColors.backGroundGrey,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _WorkshopHeroSliver(data: data),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverToBoxAdapter(child: _WorkshopProfileSection(data: data)),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverToBoxAdapter(child: _WorkshopAboutSection(data: data)),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverToBoxAdapter(child: _WorkshopContactSection(data: data)),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverToBoxAdapter(
                child: WorkshopInfoDiscountsSection(
                  workshopId: data.id,
                  workshopName: data.name,
                  services: data.discountedServices,
                  onServiceTap: (id) => setState(() => _selectedServiceId = id),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 8.h)),
              SliverToBoxAdapter(
                child: WorkshopInfoServicesSection(
                  workshopId: data.id,
                  workshopName: data.name,
                  services: data.services,
                  selectedServiceId: _selectedServiceId,
                  onServiceSelected: (id) =>
                      setState(() => _selectedServiceId = id),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: selected != null ? 100.h : 32.h),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h),
              child: const BackButtonWidget(),
            ),
          ),
          if (selected != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _WorkshopRequestBar(
                service: selected,
                onRequest: () => _startBooking(context, selected),
              ),
            ),
        ],
      ),
    );
  }

  void _startBooking(BuildContext context, WorkshopServiceItem service) {
    final serviceId = int.tryParse(service.id);
    if (serviceId == null) return;

    context.push(
      AppRoutes.scheduleService(service.id),
      extra: ServiceBookingDraft(
        serviceId: serviceId,
        businessId: int.tryParse(widget.data.id),
        serviceName: service.name,
        servicePrice: service.price,
      ),
    );
  }
}

class _WorkshopHeroSliver extends StatelessWidget {
  final WorkshopInfoData data;

  const _WorkshopHeroSliver({required this.data});

  bool get _hasCover => isDisplayableImageUrl(data.coverImageUrl);

  @override
  Widget build(BuildContext context) {
    final base = Color(data.imagePlaceholderColorValue);
    final darker = Color.fromARGB(
      255,
      (base.r * 0.35).round(),
      (base.g * 0.35).round(),
      (base.b * 0.35).round(),
    );

    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      stretch: true,
      automaticallyImplyLeading: false,
      backgroundColor: base,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (_hasCover)
              ImageWidget(
                image: data.coverImageUrl,
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
                    Colors.black.withValues(alpha: 0.35),
                    Colors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
            if (!_hasCover)
              Positioned(
                right: -16.w,
                bottom: -16.h,
                child: Icon(
                  Icons.handyman_rounded,
                  size: 140.sp,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WorkshopProfileSection extends StatelessWidget {
  final WorkshopInfoData data;

  const _WorkshopProfileSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    final hasLogo = isDisplayableImageUrl(data.logoUrl);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: hasLogo
                  ? AppColors.white
                  : Color(data.imagePlaceholderColorValue),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: isDark ? AppColors.darkGray : AppColors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: hasLogo
                ? ImageWidget(
                    image: data.logoUrl,
                    width: 72.w,
                    height: 72.w,
                    borderRadius: 18,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.build_circle_outlined,
                    color: AppColors.secondaryColor,
                    size: 34.sp,
                  ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: AppStyle.h5.copyWith(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightYellow,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 14.sp,
                        color: AppColors.tertiaryColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'store_info_certified_vendor'.tr(),
                        style: AppStyle.labelXSmall.copyWith(
                          color: AppColors.tertiaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkshopAboutSection extends StatelessWidget {
  final WorkshopInfoData data;

  const _WorkshopAboutSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    final description = data.description.isNotEmpty
        ? data.description
        : 'workshop_info_default_description'.tr();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkContainer : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'workshop_info_about'.tr(),
              style: AppStyle.labelMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: AppStyle.bodySmall.copyWith(
                color: AppColors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkshopContactSection extends StatelessWidget {
  final WorkshopInfoData data;

  const _WorkshopContactSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _ContactChip(icon: Icons.location_on_rounded, label: data.location),
          if (data.region.isNotEmpty && data.region != data.location) ...[
            SizedBox(width: 8.w),
            _ContactChip(icon: Icons.map_outlined, label: data.region),
          ],
          if (data.phone.isNotEmpty) ...[
            SizedBox(width: 8.w),
            _ContactChip(icon: Icons.phone_rounded, label: data.phone),
          ],
        ],
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ContactChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkContainer : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.darkGray : AppColors.lightGrey,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: AppColors.primaryColor),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppStyle.labelSmall.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _WorkshopRequestBar extends StatelessWidget {
  final WorkshopServiceItem service;
  final VoidCallback onRequest;

  const _WorkshopRequestBar({required this.service, required this.onRequest});

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBottomNav : AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    service.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  if (service.hasDiscount)
                    Row(
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
                          style: AppStyle.h6.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      '\$${service.price.toStringAsFixed(2)}',
                      style: AppStyle.h6.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            SizedBox(
              width: 170.w,
              child: CustomButton(
                text: 'services_request_service'.tr(),
                onPressed: onRequest,
                icon: Icons.send_rounded,
                iconLeft: false,
                height: 48.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
