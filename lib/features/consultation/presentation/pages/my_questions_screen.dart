import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/consultation/presentation/bloc/expert_consultation_cubit.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/error_widget.dart';
import 'package:untitled1/widgets/loader.dart';

class MyQuestionsScreen extends StatefulWidget {
  const MyQuestionsScreen({super.key});

  @override
  State<MyQuestionsScreen> createState() => _MyQuestionsScreenState();
}

class _MyQuestionsScreenState extends State<MyQuestionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExpertConsultationCubit>().getMyQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my_questions_title'.tr()),
      ),
      body: BlocBuilder<ExpertConsultationCubit, ExpertConsultationState>(
        builder: (context, state) {
          if (state is ExpertConsultationLoading) {
            return const LoadingIndicator();
          }

          if (state is ExpertConsultationError) {
            return errorWidget(
              message: state.message,
                hasButton: true,
                onPressed: () => context.read<ExpertConsultationCubit>().getMyQuestions(),

            );
          }

          if (state is ExpertConsultationSuccess) {
            final questions = state.questions;
            if (questions.isEmpty) {
              return EmptyWidget(
                icon: Icons.question_answer_outlined,
                title: 'no_questions_yet'.tr(),
                subtitle: 'ask_your_first_question_now'.tr(),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: questions.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final item = questions[index];
                final isAnswered = item.status == 'answered';

                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: isAnswered ? AppColors.green.withOpacity(0.1) : AppColors.lightYellow,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              item.status.tr(),
                              style: AppStyle.labelXSmall.copyWith(
                                color: isAnswered ? AppColors.green : AppColors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            DataHelper.dateFormat('dd MMM yyyy, HH:mm', item.createdAt,locale: context.locale),
                            style: AppStyle.labelXSmall.copyWith(color: AppColors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        item.question,
                        style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (isAnswered && item.answer != null) ...[
                        const Divider(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.support_agent_rounded, size: 16, color: AppColors.primaryColor),
                            SizedBox(width: 8.w),
                            Text(
                              item.answeredByName ?? 'Expert',
                              style: AppStyle.labelSmall.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          item.answer!,
                          style: AppStyle.bodySmall,
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
