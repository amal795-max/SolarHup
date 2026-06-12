import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/consultation/data/models/consultation_booking_model.dart';
import 'package:untitled1/features/consultation/presentation/bloc/book_consultation_bloc/book_consultation_bloc.dart';
import 'package:untitled1/widgets/primary_button.dart';

class ConsultationExpertSection extends StatelessWidget {
  final List<ExpertModel> experts;
  final String selectedExpertId;

  const ConsultationExpertSection({
    super.key,
    required this.experts,
    required this.selectedExpertId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'consultation_select_expert'.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 210.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: experts.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final expert = experts[index];
              final isSelected = expert.id == selectedExpertId;
              return ConsultationExpertCard(
                expert: expert,
                isSelected: isSelected,
                onSelect: () => context.read<BookConsultationBloc>().add(
                      SelectExpertEvent(expert.id),
                    ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ConsultationExpertCard extends StatelessWidget {
  final ExpertModel expert;
  final bool isSelected;
  final VoidCallback onSelect;

  const ConsultationExpertCard({
    super.key,
    required this.expert,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkContainer : AppColors.white;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: 160.w,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color:
                  isSelected ? AppColors.secondaryColor : theme.colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundColor: Color(expert.avatarColorValue),
                child: Icon(
                  Icons.person_rounded,
                  color: AppColors.white,
                  size: 32.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                expert.name,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                expert.role,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: AppColors.secondaryColor,
                    size: 14.sp,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    expert.rating.toStringAsFixed(1),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              isSelected
                  ? CustomButton(
                      text: 'consultation_selected_btn'.tr(),
                      onPressed: onSelect,
                      height: 34.h,
                      backgroundColor: AppColors.primaryColor,
                      textColor: AppColors.white,
                      fontWeight: FontWeight.w600,
                      borderRadius: 10,
                    )
                  : CustomButton(
                      text: 'consultation_select_btn'.tr(),
                      onPressed: onSelect,
                      height: 34.h,
                      type: ButtonType.outlined,
                      borderColor: theme.colorScheme.outline,
                      textColor: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      borderRadius: 10,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
