import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/extensions.dart';
import '../../../../core/helper/validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_style.dart';
import '../../../../widgets/custom_text_field.dart';
import '../bloc/cart_cubit.dart';

class ShippingAddressForm extends StatelessWidget {
  const ShippingAddressForm({super.key});

  @override
  Widget build(BuildContext context) {
    final CartCubit cubit = context.read<CartCubit>();
    final isDark = context.brightness;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkContainer : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Form(
        key: cubit.key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'shipping_address'.tr(),
                  style: AppStyle.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              controller: cubit.fullNameController,
              title: 'full_name'.tr(),
              hint: 'Johnathan Doe',
              validator: requiredValidator,
            ),
            CustomTextField(
              controller: cubit.streetController,
              title: 'street_address'.tr(),
              hint: '123 Solar Way',
              validator: requiredValidator,
            ),
            CustomTextField(
              controller: cubit.cityController,
              title: 'city'.tr(),
              hint: 'Palo Alto',
              validator: requiredValidator,
            ),
            Row(
              spacing: 16.w,
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: cubit.buildingController,
                    title: 'building'.tr(),
                    hint: '123',
                    validator: requiredValidator,
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    controller: cubit.floorController,
                    title: 'floor'.tr(),
                    hint: '2',
                    validator: requiredValidator,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
