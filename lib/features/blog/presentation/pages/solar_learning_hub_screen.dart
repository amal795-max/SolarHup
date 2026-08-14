import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/data_source/learning_hub_remote_data_source.dart';
import 'package:untitled1/features/blog/data/repositories/learning_hub_repository.dart';
import 'package:untitled1/features/blog/presentation/bloc/learning_hub_bloc/learning_hub_bloc.dart';
import 'package:untitled1/features/blog/presentation/widgets/learning_hub_faqs_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/learning_hub_glossary_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/learning_hub_header_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/learning_hub_quick_guides_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/learning_hub_safety_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/learning_hub_troubleshooting_section.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class SolarLearningHubScreen extends StatelessWidget {
  const SolarLearningHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LearningHubBloc(
        LearningHubRepositoryImpl(
          remote: const LearningHubRemoteDataSourceImpl(),
          networkInfo: NetworkInfoImpl(),
          useNetworkCheck: false,
        ),
      )..add(const LoadLearningHubEvent()),
      child: const _SolarLearningHubView(),
    );
  }
}

class _SolarLearningHubView extends StatelessWidget {
  const _SolarLearningHubView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<LearningHubBloc, LearningHubState>(
          builder: (context, state) {
            return switch (state) {
              LearningHubLoading() => const LoadingIndicator(),
              LearningHubError(:final message) => EmptyWidget(
                  icon: Icons.error_outline_rounded,
                  iconSize: 48,
                  iconColor: AppColors.red,
                  title: 'stores_error_title'.tr(),
                  subtitle: message,
                  action: CustomButton(
                    text: 'stores_retry'.tr(),
                    onPressed: () => context
                        .read<LearningHubBloc>()
                        .add(const LoadLearningHubEvent()),
                    width: 160.w,
                  ),
                ),
              LearningHubLoaded() => _LearningHubBody(state: state),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _LearningHubBody extends StatelessWidget {
  final LearningHubLoaded state;

  const _LearningHubBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final hub = state.hub;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LearningHubHeaderSection(),
                SizedBox(height: 20.h),
                LearningHubQuickGuidesSection(
                  guides: hub.quickGuides,
                  onGuideTap: (guide) => context.push(
                    AppRoutes.blogArticleDetail(guide.id),
                  ),
                ),
                SizedBox(height: 14.h),
                LearningHubSafetySection(tips: hub.safetyTips),
                SizedBox(height: 14.h),
                LearningHubTroubleshootingSection(
                  items: hub.troubleshootingItems,
                ),
                SizedBox(height: 14.h),
                LearningHubFaqsSection(
                  questions: hub.faqQuestions,
                  onViewAllTap: () =>
                      context.push(AppRoutes.allQuestionsScreen),
                ),
                SizedBox(height: 14.h),
                LearningHubGlossarySection(
                  terms: state.filteredGlossaryTerms,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
