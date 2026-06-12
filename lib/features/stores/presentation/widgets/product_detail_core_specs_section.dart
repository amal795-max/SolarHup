import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_spec_card.dart';

class ProductDetailCoreSpecsSection extends StatelessWidget {
  final ProductCoreSpecs specs;

  const ProductDetailCoreSpecsSection({super.key, required this.specs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor =
        isDark ? AppColors.darkContainer : AppColors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'product_detail_core_specs_title'.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        ProductSpecCard(
          label: 'product_detail_max_power_output'.tr(),
          value: specs.maxPowerOutput,
          isFullWidth: true,
          leadingIcon: Icons.bolt_rounded,
          backgroundColor: surfaceColor,
          iconBackgroundColor: AppColors.secondaryColor,
          iconColor: AppColors.tertiaryColor,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: ProductSpecCard(
                label: 'product_detail_efficiency'.tr(),
                value: specs.efficiency,
                backgroundColor: surfaceColor,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: ProductSpecCard(
                label: 'product_detail_warranty'.tr(),
                value: specs.warranty,
                backgroundColor: surfaceColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: ProductSpecCard(
                label: 'brand'.tr(),
                value: specs.brand,
                backgroundColor: AppColors.secondaryColor,
                labelColor: AppColors.tertiaryColor,
                valueColor: AppColors.tertiaryColor,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: ProductSpecCard(
                label: 'product_detail_cell_technology'.tr(),
                value: specs.cellTechnology,
                backgroundColor: AppColors.primaryColor,
                labelColor: AppColors.white.withValues(alpha: 0.75),
                valueColor: AppColors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
