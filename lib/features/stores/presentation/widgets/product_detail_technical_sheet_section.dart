import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';
import 'package:untitled1/features/stores/presentation/widgets/product_data_row_item.dart';

class ProductDetailTechnicalSheetSection extends StatelessWidget {
  final List<ProductDetailDataRow> rows;

  const ProductDetailTechnicalSheetSection({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    final rowBg = isDark
        ? AppColors.darkGray.withValues(alpha: 0.45)
        : AppColors.lightGrey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'product_detail_technical_data_sheet'.tr(),
          style: AppStyle.h6.copyWith(
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
                label: row.labelKey.tr(),
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
