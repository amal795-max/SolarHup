import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/helper/validators.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/consultation/presentation/bloc/expert_consultation_cubit.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/primary_button.dart';

class AskExpertScreen extends StatefulWidget {
  const AskExpertScreen({super.key});

  @override
  State<AskExpertScreen> createState() => _AskExpertScreenState();
}

class _AskExpertScreenState extends State<AskExpertScreen> {
  final TextEditingController _questionController = TextEditingController();
  GlobalKey<FormState> key  = GlobalKey<FormState>();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('consult_expert_title'.tr()),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.myQuestionsScreen),
            icon: const Icon(Icons.question_answer_rounded),
          ),
        ],
      ),
      body: BlocConsumer<ExpertConsultationCubit, ExpertConsultationState>(
        listener: (context, state) {
          if (state is ExpertConsultationSent) {
            DataHelper.showSnackBar(
              context: context,
              message: 'question_sent_success'.tr(),
            );
            _questionController.clear();
          } else if (state is ExpertConsultationError) {
            DataHelper.showSnackBar(
              context: context,
              message: state.message,
              color: AppColors.red,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ask_expert_hint'.tr(),
                  style: AppStyle.labelMedium.copyWith(color: AppColors.grey),
                ),
                SizedBox(height: 16.h),
                Form(
                  key: key,
                  child: CustomTextField(
                    title: '',
                    hasTitle: false,
                    hint: 'type_your_question_here'.tr(),
                    maxLines: 8,
                    controller: _questionController,
                    validator: requiredValidator,
                  ),
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  text: 'send_question'.tr(),
                  isLoading: state is ExpertConsultationSending,
                  onPressed: () {
                    final q = _questionController.text.trim();
                    if (key.currentState!.validate()){
                      context.read<ExpertConsultationCubit>().sendQuestion(q);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
