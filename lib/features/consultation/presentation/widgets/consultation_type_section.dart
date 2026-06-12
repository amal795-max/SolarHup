import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/consultation/data/models/consultation_booking_model.dart';
import 'package:untitled1/features/consultation/presentation/bloc/book_consultation_bloc/book_consultation_bloc.dart';

class ConsultationTypeSection extends StatelessWidget {
  final List<ConsultationTypeModel> types;
  final String selectedTypeId;

  const ConsultationTypeSection({
    super.key,
    required this.types,
    required this.selectedTypeId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'consultation_type_title'.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        SizedBox(height: 12.h),
        ...types.map(
          (type) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: ConsultationTypeTile(
              type: type,
              isSelected: type.id == selectedTypeId,
              onTap: () => context.read<BookConsultationBloc>().add(
                    SelectConsultationTypeEvent(type.id),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class ConsultationTypeTile extends StatelessWidget {
  final ConsultationTypeModel type;
  final bool isSelected;
  final VoidCallback onTap;

  const ConsultationTypeTile({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon => switch (type.iconType) {
        'box' => Icons.inventory_2_outlined,
        'compass' => Icons.architecture_outlined,
        _ => Icons.solar_power_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isSelected
        ? AppColors.secondaryColor.withValues(alpha: isDark ? 0.18 : 0.22)
        : (isDark ? AppColors.darkContainer : AppColors.white);

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.secondaryColor
                  : theme.colorScheme.outline,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.secondaryColor.withValues(alpha: 0.35)
                      : theme.colorScheme.tertiaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _icon,
                  color: isSelected
                      ? AppColors.brown
                      : theme.textTheme.bodySmall?.color,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      type.description,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected
                    ? AppColors.secondaryColor
                    : theme.colorScheme.outline,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
