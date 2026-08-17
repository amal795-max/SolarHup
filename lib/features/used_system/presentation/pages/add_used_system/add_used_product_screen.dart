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
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';
import 'package:untitled1/widgets/image_widget.dart';
import 'package:untitled1/widgets/loader.dart';

import '../../../../../core/enums/region_enum.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/primary_button.dart';
import '../../widgets/drop_menu_widget.dart';
import '../../widgets/section_header.dart';

class AddUsedProductScreen extends StatefulWidget {
  final UsedProductModel? product;

  const AddUsedProductScreen({super.key, this.product});

  @override
  State<AddUsedProductScreen> createState() => _AddUsedProductScreenState();
}

class _AddUsedProductScreenState extends State<AddUsedProductScreen> {
  @override
  void initState() {
    super.initState();

    context.read<UsedSystemCubit>().initForm(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsedSystemCubit>();

    return BlocConsumer<UsedSystemCubit, UsedSystemState>(
      listenWhen: _listenWhen,
      listener: _listener,
      builder: (context, state) {
        if (state is AddUsedProductLoading || state is UpdateProductLoading) {
          return const LoadingIndicator();
        }

        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: cubit.addProductKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),

                  SectionHeader(
                    title: widget.product == null
                        ? 'system_info'.tr()
                        : 'edit_product'.tr(),
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
                    items: ProductCategoryEnum.values
                        .map((e) => e.category)
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        cubit.selectedCategory = value;
                      });
                    },
                  ),

                  SizedBox(height: 16.h),
                  Text('condition'.tr(), style: AppStyle.labelSmall),

                  SizedBox(height: 12.h),

                  StatefulBuilder(
                    builder: (context, setState) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 8.w,
                          children: ProductStatusEnum.values
                              .map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      cubit.selectedCondition = e.status;
                                    });
                                  },
                                  child: _ChoiceChip(
                                    label: e.status.tr(),
                                    isSelected:
                                        cubit.selectedCondition == e.status,
                                  ),
                                ),
                              )
                              .toList(),
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

                  DropdownField(
                    title: 'region'.tr(),
                    value: cubit.selectedRegion,
                    items: RegionEnum.values.map((e) => e.region).toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        cubit.selectedRegion = value;
                      });
                    },
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

                  // ----------------------------------------------------------
                  // ADD PHOTOS
                  // ----------------------------------------------------------
                  _MediaPlaceholder(
                    cubit: cubit,
                    label: 'add_photos'.tr(),
                    icon: Icons.camera_alt_outlined,
                  ),

                  SizedBox(height: 16.h),

                  // ----------------------------------------------------------
                  // SELECTED IMAGES
                  // ----------------------------------------------------------
                  BlocBuilder<UsedSystemCubit, UsedSystemState>(
                    builder: (context, state) {
                      final selectedImages = cubit.images
                          .asMap()
                          .entries
                          .where((entry) => entry.value != null)
                          .toList();

                      if (selectedImages.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: selectedImages.map((entry) {
                          return _AddedMediaItem(
                            image: entry.value!,
                            onDelete: () {
                              cubit.removeImage(entry.key);
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),

                  SizedBox(height: 16.h),

                  // ----------------------------------------------------------
                  // SUBMIT BUTTON
                  // ----------------------------------------------------------
                  BlocBuilder<UsedSystemCubit, UsedSystemState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: widget.product == null
                            ? 'post_listing'.tr()
                            : 'update_listing'.tr(),
                        onPressed: () {
                          if (widget.product == null) {
                            cubit.addUsedProduct();
                          } else {
                            cubit.updateProduct(widget.product!.id);
                          }
                        },
                      );
                    },
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _listener(BuildContext context, UsedSystemState state) {
    if (state is AddUsedProductSuccess) {
      DataHelper.showSnackBar(message: state.message, context: context);

      Navigator.pop(context);
    } else if (state is UpdateProductSuccess) {
      DataHelper.showSnackBar(message: state.message, context: context);

      Navigator.pop(context);
    } else if (state is AddUsedProductFailure) {
      DataHelper.showSnackBar(
        context: context,
        message: state.message,
        color: AppColors.red,
      );
    } else if (state is UpdateProductFailure) {
      DataHelper.showSnackBar(
        context: context,
        message: state.message,
        color: AppColors.red,
      );
    }
  }
}

bool _listenWhen(UsedSystemState previous, UsedSystemState current) {
  return current is AddUsedProductSuccess ||
      current is AddUsedProductFailure ||
      current is UpdateProductSuccess ||
      current is UpdateProductFailure;
}

// ============================================================================
// CHOICE CHIP
// ============================================================================

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

// ============================================================================
// MEDIA PLACEHOLDER
// ============================================================================

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
      onTap: cubit.pickImages,
      child: Container(
        height: 100.h,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
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

// ============================================================================
// ADDED MEDIA ITEM
// ============================================================================

class _AddedMediaItem extends StatelessWidget {
  final String image;
  final VoidCallback onDelete;

  const _AddedMediaItem({required this.image, required this.onDelete});
  bool get isLocal => !image.startsWith('/data/');
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: isLocal
              ? ImageWidget(
                  image: image,
                  height: 100.r,
                  width: 100.r,
                  fit: BoxFit.cover,
                )
              : Image.file(
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
