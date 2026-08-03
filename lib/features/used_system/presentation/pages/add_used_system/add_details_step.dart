import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/core/enums/product_category.dart';
import 'package:untitled1/core/enums/product_status_enum.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/helper/validators.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/used_system/presentation/bloc/used_system_cubit.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/primary_button.dart';
import '../../widgets/drop_menu_widget.dart';
import '../../widgets/section_header.dart';

class DetailsStep extends StatelessWidget {
  const DetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsedSystemCubit>();
    return BlocListener<UsedSystemCubit, UsedSystemState>(
      listenWhen: (previous, current) =>
          current is AddUsedProductSuccess || current is AddUsedProductFailure,
      listener: (context, state) {
        if (state is AddUsedProductSuccess) {
          DataHelper.showSnackBar(
            message: state.message,
            context: context,
          );
          Navigator.pop(context);
          context.read<UsedSystemCubit>().getUsedProducts();
        }
        else if (state is AddUsedProductFailure) {
          DataHelper.showSnackBar(
            context: context,
            message: state.message,
            color: AppColors.red,
          );
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: cubit.addProductKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32.h),
              SectionHeader(
                title: 'system_info'.tr(),
                subtitle: 'system_info_subtitle'.tr(),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                validator: requiredValidator,
                title: 'title'.tr(),
                hint: 'title_hint'.tr(),
                controller: cubit.nameController,
              ),
              DropdownField(
                title: 'category'.tr(),
                value: cubit.selectedCategory,
                items:ProductCategoryEnum.values.map((e)=>e.category).toList(),
                onChanged: (value) {
                  if (value != null) {
                    cubit.selectedCategory = value;
                  }
                },
              ),
              SizedBox(height: 16.h),
              Text(
                'condition'.tr(),
                style: AppStyle.labelSmall,
              ),
              SizedBox(height: 12.h),
              StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 8.w,
                      children:
                        ProductStatusEnum.values.map((e)=>
                        GestureDetector(
                          onTap: () =>
                              setState(() => cubit.selectedCondition = e.status),
                          child: _ChoiceChip(
                            label: e.status.tr(),
                            isSelected: cubit.selectedCondition == e.status,
                          ),
                        )).toList(),

                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                validator: requiredValidator,
                title: 'price_usd'.tr(),
                hint: 'price_hint'.tr(),
                controller: cubit.priceController,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                validator: requiredValidator,
                title: 'location'.tr(),
                hint: 'location_hint'.tr(),
                controller: cubit.regionController,
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                validator: requiredValidator,
                title: 'description'.tr(),
                hint: 'description_hint'.tr(),
                controller: cubit.descriptionController,
                maxLines: 4,
              ),
              SizedBox(height: 24.h),
              _MediaPlaceholder(
                cubit: cubit,
                label: 'add_photos'.tr(),
                icon: Icons.camera_alt_outlined,
              ),
              SizedBox(height: 16.h),
              BlocBuilder<UsedSystemCubit, UsedSystemState>(
                buildWhen: (previous, current) => current is UploadImage,
                builder: (context, state) {
                  return Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: cubit.images
                        .asMap()
                        .entries
                        .map((entry) => _AddedMediaItem(
                              image: entry.value,
                              onDelete: () => cubit.removeImage(entry.key),
                            ))
                        .toList(),
                  );
                },
              ),
              SizedBox(height: 32.h),
              BlocBuilder<UsedSystemCubit, UsedSystemState>(
                builder: (context, state) {
                  return CustomButton(
                    text: 'post_listing'.tr(),
                    isLoading: state is AddUsedProductLoading,
                    onPressed: () {
                      cubit.addUsedProduct();
                    },
                  );
                },
              ),
              SizedBox(height: 12.h),
              CustomButton(
                text: 'save_draft'.tr(),
                onPressed: () {},
                backgroundColor: AppColors.backGroundGrey,
                textColor: AppColors.primaryColor,
                borderColor: AppColors.primaryColor,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
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
        border: Border.all(
          color: isSelected ? AppColors.brown : AppColors.lightGrey,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.brown : AppColors.grey,
          fontWeight: isSelected ? FontWeight.bold : null,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

class _MediaPlaceholder extends StatelessWidget {
  final String label;
  final IconData icon;
  final UsedSystemCubit cubit;

  const _MediaPlaceholder({
    required this.label,
    required this.icon,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => cubit.pickImage(),
      child: Container(
        height: 100.h,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.borderColor,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.grey),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddedMediaItem extends StatelessWidget {
  final String image;
  final VoidCallback onDelete;

  const _AddedMediaItem({required this.image, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.file(
            File(image),
            height: 100.r,
            width: 100.r,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 4,
          top: 4,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 14.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
