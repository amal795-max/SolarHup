import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/theme/app_colors.dart';

class PackageComparisonHeaderSection extends StatelessWidget {
  const PackageComparisonHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'comparison_subtitle'.tr(),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.grey,
            height: 1.45,
          ),
    );
  }
}
