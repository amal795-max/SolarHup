import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/primary_button.dart';
import '../../widgets/drop_menu_widget.dart';
import '../../widgets/section_header.dart';

class TechnicalStep extends StatelessWidget {
  final VoidCallback onNext;
  const TechnicalStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'technical_info'.tr(), subtitle: 'technical_info_subtitle'.tr()),
          SizedBox(height: 24.h),
          Row(
            spacing: 16.w,
            children: [
              Expanded(child: CustomTextField(title: 'system_capacity'.tr(), hint: 'e.g. 5.0')),
              Expanded(child: CustomTextField(title: 'panel_count'.tr(), hint: '12')),
            ],
          ),
          Row(
            spacing: 16.w,
            children: [
              Expanded(child: CustomTextField(title: 'brand'.tr(), hint: 'brand_hint'.tr())),
              Expanded(child: CustomTextField(title: 'age_years'.tr(), hint: '2')),
            ],
          ),
          SizedBox(height: 16.h),
          _TechnicalCard(
            title: 'battery_details'.tr(),
            icon: Icons.battery_charging_full,
            child: Column(
              spacing: 16.h,
              children: [
                DropdownField(title: 'battery_type'.tr(), value: 'lithium'.tr()),
                CustomTextField(title: 'capacity_ah'.tr(), hint: '200'),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _TechnicalCard(
            title: 'inverter_details'.tr(),
            icon: Icons.settings_input_component,
            child: Column(
              spacing: 16.h,
              children: [
                DropdownField(title: 'inverter_type'.tr(), value: 'hybrid'.tr()),
                CustomTextField(title: 'inverter_power'.tr(), hint: '3.5'),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          CustomTextField(title: 'reason_selling'.tr(), hint: 'reason_selling_hint'.tr()),
          SizedBox(height: 32.h),
          CustomButton(text: 'next'.tr(), onPressed: onNext),
        ],
      ),
    );
  }
}
class _TechnicalCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _TechnicalCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: AppColors.primaryColor),
              SizedBox(width: 8.w),
              Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}
