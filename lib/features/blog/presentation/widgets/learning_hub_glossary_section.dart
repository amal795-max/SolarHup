import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/models/learning_hub_model.dart';
import 'package:untitled1/features/blog/presentation/bloc/learning_hub_bloc/learning_hub_bloc.dart';
import 'package:untitled1/widgets/custom_text_field.dart';

class LearningHubGlossarySection extends StatefulWidget {
  final List<GlossaryTermModel> terms;

  const LearningHubGlossarySection({super.key, required this.terms});

  @override
  State<LearningHubGlossarySection> createState() =>
      _LearningHubGlossarySectionState();
}

class _LearningHubGlossarySectionState extends State<LearningHubGlossarySection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryColor,
            AppColors.deepPrimaryColor,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'learning_glossary_title'.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'learning_glossary_description'.tr(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.lightGray,
              height: 1.45,
            ),
          ),
          SizedBox(height: 14.h),
          Theme(
            data: theme.copyWith(
              inputDecorationTheme: theme.inputDecorationTheme.copyWith(
                filled: true,
                fillColor: AppColors.darkGray.withValues(alpha: 0.55),
              ),
            ),
            child: CustomTextField(
              hasTitle: false,
              title: '',
              controller: _controller,
              hint: 'learning_glossary_search_hint'.tr(),
              onChanged: (value) => context
                  .read<LearningHubBloc>()
                  .add(UpdateGlossarySearchEvent(value)),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.lightGray,
                size: 20.sp,
              ),
            ),
          ),
          if (widget.terms.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                'learning_glossary_no_results'.tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.lightGray,
                ),
              ),
            )
          else
            ...widget.terms.map(
              (entry) => Padding(
                padding: EdgeInsets.only(top: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.term,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      entry.definition,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.lightGray,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
