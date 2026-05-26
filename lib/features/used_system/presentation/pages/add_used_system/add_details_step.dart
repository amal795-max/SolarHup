import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/primary_button.dart';
import '../../widgets/drop_menu_widget.dart';
import '../../widgets/section_header.dart';

class DetailsStep extends StatelessWidget {
  final VoidCallback onNext;
  const DetailsStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'system_info'.tr(), subtitle: 'system_info_subtitle'.tr()),
          SizedBox(height: 24.h),
          CustomTextField(
            title: 'title'.tr(),
            hint: 'title_hint'.tr(),
          ),
          DropdownField(title: 'category'.tr(), value: 'complete_system'.tr()),
          SizedBox(height: 16.h),
          Text('condition'.tr(), style: Theme.of(context).textTheme.titleSmall),
          SizedBox(height: 12.h),
          Row(
            children: [
              _ChoiceChip(label: 'good'.tr(), isSelected: true),
              SizedBox(width: 8.w),
              _ChoiceChip(label: 'acceptable'.tr()),
              SizedBox(width: 8.w),
              _ChoiceChip(label: 'refurbished'.tr()),
            ],
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            title: 'price_usd'.tr(),
            hint: 'price_hint'.tr(),
            keyboardType: TextInputType.number,
          ),
          DropdownField(title: 'location'.tr(), value: 'location_hint'.tr(), icon: Icons.location_on_outlined),
          SizedBox(height: 16.h),
          CustomTextField(
            title: 'description'.tr(),
            hint: 'description_hint'.tr(),
            maxLines: 4,
          ),
          SizedBox(height: 32.h),
          CustomButton(text: 'next'.tr(), onPressed: onNext),
        ],
      ),
    );
  }
}
class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _ChoiceChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.lightYellow : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isSelected ? AppColors.brown : AppColors.lightGrey),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.brown: AppColors.grey,
          fontWeight: isSelected ? FontWeight.bold : null,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
