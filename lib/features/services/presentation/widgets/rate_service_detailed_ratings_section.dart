import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/services/presentation/bloc/service_rating_bloc/service_rating_bloc.dart';

class RateServiceDetailedRatingsSection extends StatelessWidget {
  final ServiceRatingLoaded state;

  const RateServiceDetailedRatingsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness ;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final cardColor = isDark
        ? AppColors.darkGray.withValues(alpha: 0.5)
        : AppColors.lightGrey.withValues(alpha: 0.55);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _RatingSliderRow(
            label: 'service_quality'.tr(),
            value: state.serviceQuality,
            valueColor: titleColor,
            onChanged: (value) => context
                .read<ServiceRatingBloc>()
                .add(UpdateServiceQualityEvent(value)),
          ),
          SizedBox(height: 12.h),
          _RatingSliderRow(
            label: 'label_technician_behavior'.tr(),
            value: state.technicianBehavior,
            valueColor: titleColor,
            onChanged: (value) => context
                .read<ServiceRatingBloc>()
                .add(UpdateTechnicianBehaviorEvent(value)),
          ),
          SizedBox(height: 12.h),
          _RatingSliderRow(
            label: 'label_value_for_money'.tr(),
            value: state.valueForMoney,
            valueColor: titleColor,
            onChanged: (value) => context
                .read<ServiceRatingBloc>()
                .add(UpdateValueForMoneyEvent(value)),
          ),
        ],
      ),
    );
  }
}

class _RatingSliderRow extends StatelessWidget {
  final String label;
  final double value;
  final Color valueColor;
  final ValueChanged<double> onChanged;

  const _RatingSliderRow({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppStyle.labelMedium.copyWith(
                color: AppColors.grey,
              ),
            ),
            Text(
              value.round().toString(),
              style: AppStyle.labelSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
            activeTrackColor: isDark
                ? AppColors.darkGray
                : AppColors.borderColor.withValues(alpha: 0.5),
            inactiveTrackColor: isDark
                ? AppColors.darkContainer
                : AppColors.white.withValues(alpha: 0.8),
            thumbColor: valueColor,
            overlayColor: valueColor.withValues(alpha: 0.12),
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
