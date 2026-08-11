import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_spec_card.dart';

class ProductDetailCoreSpecsSection extends StatelessWidget {
  final List<ProductSpecHighlight> specs;

  const ProductDetailCoreSpecsSection({super.key, required this.specs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkContainer : AppColors.white;

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
        ..._buildSpecWidgets(context, surfaceColor),
      ],
    );
  }

  List<Widget> _buildSpecWidgets(BuildContext context, Color surfaceColor) {
    final widgets = <Widget>[];
    final regular = <ProductSpecHighlight>[];

    for (final spec in specs) {
      if (spec.fullWidth) {
        if (regular.isNotEmpty) {
          widgets.add(_buildRow(context, regular, surfaceColor));
          widgets.add(SizedBox(height: 8.h));
          regular.clear();
        }
        widgets.add(_buildCard(context, spec, surfaceColor, fullWidth: true));
        widgets.add(SizedBox(height: 8.h));
      } else {
        regular.add(spec);
        if (regular.length == 2) {
          widgets.add(_buildRow(context, regular, surfaceColor));
          widgets.add(SizedBox(height: 8.h));
          regular.clear();
        }
      }
    }

    if (regular.isNotEmpty) {
      widgets.add(_buildRow(context, regular, surfaceColor));
    }

    if (widgets.isNotEmpty && widgets.last is SizedBox) {
      widgets.removeLast();
    }

    return widgets;
  }

  Widget _buildRow(
    BuildContext context,
    List<ProductSpecHighlight> rowSpecs,
    Color surfaceColor,
  ) {
    return Row(
      children: [
        for (var i = 0; i < rowSpecs.length; i++) ...[
          if (i > 0) SizedBox(width: 8.w),
          Expanded(child: _buildCard(context, rowSpecs[i], surfaceColor)),
        ],
        if (rowSpecs.length == 1) const Expanded(child: SizedBox.shrink()),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context,
    ProductSpecHighlight spec,
    Color surfaceColor, {
    bool fullWidth = false,
  }) {
    final isBrand = spec.labelKey == 'brand';
    final isWarranty = spec.labelKey == 'product_detail_warranty';
    final isCellTech = spec.labelKey == 'product_detail_cell_technology';

    return ProductSpecCard(
      label: spec.labelKey.tr(),
      value: spec.value,
      isFullWidth: fullWidth,
      leadingIcon: spec.icon,
      backgroundColor: isWarranty
          ? AppColors.primaryColor
          : isBrand
          ? AppColors.secondaryColor
          : isCellTech
          ? AppColors.primaryColor
          : surfaceColor,
      iconBackgroundColor: AppColors.secondaryColor,
      iconColor: AppColors.tertiaryColor,
      labelColor: isWarranty
          ? AppColors.blue :isBrand || isCellTech
          ? (isCellTech
                ? AppColors.white.withValues(alpha: 0.75)
                : AppColors.brown)
          : null,
      valueColor: isWarranty
          ? AppColors.lightGrey
          : isBrand
          ? AppColors.tertiaryColor
          : isCellTech
          ? AppColors.white
          : null,
    );
  }
}
