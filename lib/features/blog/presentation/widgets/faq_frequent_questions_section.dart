import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/models/faq_hub_model.dart';
import 'package:untitled1/features/blog/presentation/bloc/faq_hub_bloc/faq_hub_bloc.dart';

class FaqFrequentQuestionsSection extends StatelessWidget {
  final List<FaqQuestionModel> questions;

  const FaqFrequentQuestionsSection({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headingColor = isDark ? AppColors.blue : AppColors.primaryColor;

    if (questions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'faq_frequent_questions'.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: headingColor,
          ),
        ),
        SizedBox(height: 12.h),
        BlocBuilder<FaqHubBloc, FaqHubState>(
          buildWhen: (prev, curr) =>
              curr is FaqHubLoaded &&
              (prev is! FaqHubLoaded ||
                  prev.expandedQuestionIds != curr.expandedQuestionIds),
          builder: (context, state) {
            if (state is! FaqHubLoaded) return const SizedBox.shrink();

            return Column(
              children: questions.map((question) {
                final isExpanded =
                    state.expandedQuestionIds.contains(question.id);
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _FaqAccordionTile(
                    question: question,
                    isExpanded: isExpanded,
                    isDark: isDark,
                    onTap: () => context
                        .read<FaqHubBloc>()
                        .add(ToggleFaqExpandedEvent(question.id)),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _FaqAccordionTile extends StatelessWidget {
  final FaqQuestionModel question;
  final bool isExpanded;
  final bool isDark;
  final VoidCallback onTap;

  const _FaqAccordionTile({
    required this.question,
    required this.isExpanded,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor =
        isDark ? theme.colorScheme.outline : AppColors.borderColor;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor.withValues(alpha: 0.6)),
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.fromLTRB(14.w, 12.h, 10.w, 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      question.question,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.grey,
                    size: 22.sp,
                  ),
                ],
              ),
              if (isExpanded) ...[
                SizedBox(height: 10.h),
                Text(
                  question.answer,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.blue : AppColors.deepGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
