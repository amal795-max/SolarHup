import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/package_comparison/data/models/package_comparison_model.dart';
import 'package:untitled1/widgets/container_style_widget.dart';

class PackageComparisonPricingSection extends StatelessWidget {
  final SolarPackageModel starter;
  final SolarPackageModel premium;

  const PackageComparisonPricingSection({
    super.key,
    required this.starter,
    required this.premium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final valueColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final starterPrice = NumberFormat.currency(symbol: r'$', decimalDigits: 0)
        .format(starter.price);
    final premiumPrice = NumberFormat.currency(symbol: r'$', decimalDigits: 0)
        .format(premium.price);

    return container(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payments_outlined, size: 18.sp, color: AppColors.grey),
              SizedBox(width: 8.w),
              Text(
                'label_system_pricing'.tr(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  starterPrice,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: valueColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  premiumPrice,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: valueColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
