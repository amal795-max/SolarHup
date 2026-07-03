import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/package_comparison/data/models/package_comparison_model.dart';
import 'package:untitled1/widgets/container_style_widget.dart';

class PackageComparisonEfficiencySection extends StatelessWidget {
  final SolarPackageModel starter;
  final SolarPackageModel premium;

  const PackageComparisonEfficiencySection({
    super.key,
    required this.starter,
    required this.premium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return container(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'label_efficiency_rating'.tr(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _StarRating(rating: starter.efficiencyRating),
              ),
              Expanded(
                child: _StarRating(rating: premium.efficiencyRating),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final double rating;

  const _StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isFilled = index < rating.round();
        return Icon(
          isFilled ? Icons.star_rounded : Icons.star_border_rounded,
          size: 22.sp,
          color: isFilled
              ? AppColors.secondaryColor
              : AppColors.secondaryColor.withValues(alpha: 0.45),
        );
      }),
    );
  }
}
