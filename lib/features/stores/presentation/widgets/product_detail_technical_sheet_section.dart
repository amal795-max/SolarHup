import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_data_row_item.dart';

class ProductDetailTechnicalSheetSection extends StatelessWidget {
  final ProductTechnicalData data;

  const ProductDetailTechnicalSheetSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final rowBg = isDark
        ? AppColors.darkGray.withValues(alpha: 0.45)
        : AppColors.lightGrey;

    final rows = <({String label, String value})>[
      (label: 'product_detail_weight'.tr(), value: data.weight),
      (label: 'product_detail_dimensions'.tr(), value: data.dimensions),
      (label: 'product_detail_connectors'.tr(), value: data.connectors),
      (
        label: 'product_detail_max_system_voltage'.tr(),
        value: data.maxSystemVoltage,
      ),
      (label: 'product_detail_operating_temp'.tr(), value: data.operatingTemp),
      (label: 'product_detail_material'.tr(), value: data.material),
      (label: 'product_detail_output_type'.tr(), value: data.outputType),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'product_detail_technical_data_sheet'.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Column(
            children: List.generate(rows.length, (index) {
              final row = rows[index];
              return ProductDataRowItem(
                label: row.label,
                value: row.value,
                backgroundColor: rowBg,
                showDivider: index < rows.length - 1,
              );
            }),
          ),
        ),
      ],
    );
  }
}
