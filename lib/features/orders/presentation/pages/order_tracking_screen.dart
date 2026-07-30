import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/widgets/primary_button.dart';
import '../../../../core/helper/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('order_tracking'.tr()),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          spacing: 16.h,
          children: [
            const _OrderHeaderCard(),
            CustomButton(text: 'text',
            onPressed: (){
              context.push(AppRoutes.activityScreen);
            },),
            const _EstimatedDeliveryBanner(),
            const _OrderTrackingTimeline(),
            const _ShippingAddressSection(),
            const _OrderSummarySection(),
            SizedBox(height: 24.h),

          ],
        ),
      ),
    );
  }
}

class _OrderHeaderCard extends StatelessWidget {
  const _OrderHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (!context.brightness)
           const BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset:Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'order_id_label'.tr(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.grey),
          ),
          Text(
            '#SH-98234-LX',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
          ),
          SizedBox(height: 16.h),
          Row(
            spacing: 40.w,
            children: [
              _HeaderItem(label: 'date_label'.tr(), value: 'Oct 24, 2023'),
              _HeaderItem(label: 'items_label'.tr(), value: 'units_count'.tr(args: ['3'])),
            ],
          )
        ],
      ),
    );
  }
}

class _HeaderItem extends StatelessWidget {
  final String label;
  final String value;
  const _HeaderItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyle.labelSmall.copyWith(color: AppColors.grey, letterSpacing: 1.2),
        ),
        Text(
          value,
          style:AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _EstimatedDeliveryBanner extends StatelessWidget {
  const _EstimatedDeliveryBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        spacing: 4.h,
        children: [
          Row(
            spacing: 8.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_shipping, color: AppColors.primaryColor, size: 20),
              Text(
                'estimated_delivery'.tr(),
                style: AppStyle.labelSmall.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            'Oct 28',
            style: AppStyle.h3.copyWith(color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}

class _OrderTrackingTimeline extends StatelessWidget {
  const _OrderTrackingTimeline();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'order_tracking_title'.tr(),
            style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24.h),
          _TimelineItem(
            title: 'tracking_created'.tr(),
            subtitle: 'Order placed successfully on Oct 24, 09:12 AM',
            isCompleted: true,
          ),
          _TimelineItem(
            title: 'tracking_processing'.tr(),
            subtitle: 'Payment confirmed and order verified.',
            isCompleted: true,
          ),
          _TimelineItem(
            title: 'tracking_packed'.tr(),
            subtitle: 'Items have been securely packed and ready for dispatch.',
            isCompleted: true,
          ),
          _TimelineItem(
            title: 'tracking_shipped'.tr(),
            subtitle: 'Package left the distribution center in Portland.',
            isCurrent: true,
            isCompleted: true,
            trackingId: '9400111899562410',
          ),
          _TimelineItem(
            title: 'tracking_out_delivery'.tr(),
            subtitle: 'Courier is on the way to your location.',
            isLast: false,
          ),
          _TimelineItem(
            title: 'tracking_delivered'.tr(),
            subtitle: 'Order reached the destination.',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;
  final String? trackingId;

  const _TimelineItem({
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isLast = false,
    this.trackingId,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrent
                      ? AppColors.secondaryColor
                      : isCompleted
                          ? AppColors.darkMode
                          : AppColors.lightGrey,
                ),
                child: isCurrent
                    ? Center(child: Container(width: 8.w, height: 8.w, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryColor)))
                    : isCompleted
                        ? Icon(Icons.check, color: Colors.white, size: 12.sp)
                        : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: isCompleted ? AppColors.darkMode : AppColors.lightGrey,
                  ),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyle.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? null : AppColors.grey,
                      ),
                ),
                Text(
                  subtitle,
                  style: AppStyle.bodySmall.copyWith(color: AppColors.grey, fontSize: 12.sp),
                ),
                if (trackingId != null) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text('ID: $trackingId', style: AppStyle.labelSmall),

                  ),
                ],
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShippingAddressSection extends StatelessWidget {
  const _ShippingAddressSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color:context.colorScheme.surface,
      borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        spacing: 16.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'shipping_address_title'.tr(),
            style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            spacing: 12.w,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.primaryColor),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Robert J. Henderson', style: AppStyle.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                    Text(
                      '4522 Oakridge Lane, Portland, OR 97201\n+1 (503) 555-0128',
                      style: AppStyle.bodySmall.copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _OrderSummarySection extends StatelessWidget {
  const _OrderSummarySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            'order_summary_label'.tr(),
            style: AppStyle.labelSmall.copyWith(color: AppColors.grey, letterSpacing: 1.2),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: const Column(
            children: [
              _SummaryItem(
                name: 'SolarMax 400W Panel',
                desc: 'Qty: 2 • Black Frame',
                price: r'$899.00',
                imageIcon: Icons.solar_power_outlined,
              ),
              Divider(),
              _SummaryItem(
                name: 'SmartSync Inverter',
                desc: 'Qty: 1 • 5kW Cloud-Link',
                price: r'$1,245.00',
                imageIcon: Icons.settings_input_component_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String name;
  final String desc;
  final String price;
  final IconData imageIcon;

  const _SummaryItem({
    required this.name,
    required this.desc,
    required this.price,
    required this.imageIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(imageIcon, color: AppColors.grey),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                Text(desc, style: AppStyle.bodySmall.copyWith(color: AppColors.grey, fontSize: 10.sp)),
              ],
            ),
          ),
          Text(price, style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

