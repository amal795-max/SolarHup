import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/presentation/bloc/service_rating_bloc/service_rating_bloc.dart';
import 'package:untitled1/widgets/custom_text_field.dart';

class RateServiceExperienceSection extends StatelessWidget {
  final ServiceRatingLoaded state;

  const RateServiceExperienceSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return Column(
      children: [
        Text(
          'how_was_experience'.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isFilled = starIndex <= state.starRating;
            return GestureDetector(
              onTap: () => context
                  .read<ServiceRatingBloc>()
                  .add(UpdateStarRatingEvent(starIndex)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 36.sp,
                  color: isFilled
                      ? AppColors.secondaryColor
                      : AppColors.grey.withValues(alpha: 0.45),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          alignment: WrapAlignment.center,
          children: ServiceRatingBloc.attributeKeys.map((key) {
            final isSelected = state.selectedAttributes.contains(key);
            return GestureDetector(
              onTap: () => context
                  .read<ServiceRatingBloc>()
                  .add(ToggleAttributeChipEvent(key)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? titleColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? titleColor
                        : theme.colorScheme.outline.withValues(alpha: 0.45),
                  ),
                ),
                child: Text(
                  key.tr(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected ? AppColors.white : AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          title: '',
          hasTitle: false,
          hint: 'feedback_hint'.tr(),
          isMultiline: true,
          maxLines: 4,
          onChanged: (value) => context
              .read<ServiceRatingBloc>()
              .add(UpdateFeedbackEvent(value)),
        ),
      ],
    );
  }
}
