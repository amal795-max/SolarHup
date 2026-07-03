import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/services/presentation/widgets/step_instruction_card.dart';

class BookingWhatsNextSection extends StatelessWidget {
  const BookingWhatsNextSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'section_whats_next'.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: titleColor,
          ),
        ),
        SizedBox(height: 12.h),
        StepInstructionCard(
          stepNumber: 1,
          title: 'step_1_title'.tr(),
          description: 'step_1_desc'.tr(),
          isActive: true,
        ),
        SizedBox(height: 10.h),
        StepInstructionCard(
          stepNumber: 2,
          title: 'step_2_title'.tr(),
          description: 'step_2_desc'.tr(),
        ),
      ],
    );
  }
}
