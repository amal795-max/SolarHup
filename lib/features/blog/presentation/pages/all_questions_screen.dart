import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/data_source/faq_hub_remote_data_source.dart';
import 'package:untitled1/features/blog/data/repositories/faq_hub_repository.dart';
import 'package:untitled1/features/blog/presentation/bloc/faq_hub_bloc/faq_hub_bloc.dart';
import 'package:untitled1/features/blog/presentation/widgets/faq_category_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/faq_frequent_questions_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/faq_glossary_banner.dart';
import 'package:untitled1/features/blog/presentation/widgets/faq_popular_topics_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/faq_search_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/faq_support_section.dart';
import 'package:untitled1/widgets/back_button_widget.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class AllQuestionsScreen extends StatelessWidget {
  const AllQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FaqHubBloc(
        FaqHubRepositoryImpl(
          remote: const FaqHubRemoteDataSourceImpl(),
          networkInfo: NetworkInfoImpl(),
          useNetworkCheck: false,
        ),
      )..add(const LoadFaqHubEvent()),
      child: const _AllQuestionsView(),
    );
  }
}

class _AllQuestionsView extends StatelessWidget {
  const _AllQuestionsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<FaqHubBloc, FaqHubState>(
          builder: (context, state) {
            return switch (state) {
              FaqHubLoading() => const LoadingIndicator(),
              FaqHubError(:final message) => EmptyWidget(
                  icon: Icons.error_outline_rounded,
                  iconSize: 48,
                  iconColor: AppColors.red,
                  title: 'stores_error_title'.tr(),
                  subtitle: message,
                  action: CustomButton(
                    text: 'stores_retry'.tr(),
                    onPressed: () =>
                        context.read<FaqHubBloc>().add(const LoadFaqHubEvent()),
                    width: 160.w,
                  ),
                ),
              FaqHubLoaded() => _AllQuestionsBody(state: state),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _AllQuestionsBody extends StatelessWidget {
  final FaqHubLoaded state;

  const _AllQuestionsBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headingColor = isDark ? AppColors.blue : AppColors.primaryColor;
    final popular = state.popularTopics;
    final frequent = state.frequentQuestions;
    final hasResults = popular.isNotEmpty || frequent.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 0),
          child: Row(
            children: [
              const BackButtonWidget(),
              Expanded(
                child: Text(
                  'faq_all_questions_title'.tr(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: headingColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FaqSearchSection(),
                SizedBox(height: 12.h),
                FaqCategorySection(categories: state.hub.categories),
                SizedBox(height: 16.h),
                FaqGlossaryBanner(
                  onTap: () => context.pop(),
                ),
                SizedBox(height: 20.h),
                if (!hasResults)
                  EmptyWidget(
                    icon: Icons.search_off_rounded,
                    iconSize: 48,
                    iconColor: AppColors.grey,
                    title: 'faq_no_results'.tr(),
                    subtitle: 'blog_no_results_hint'.tr(),
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                  )
                else ...[
                  FaqPopularTopicsSection(topics: popular),
                  SizedBox(height: 20.h),
                  FaqFrequentQuestionsSection(questions: frequent),
                ],
                SizedBox(height: 20.h),
                FaqSupportSection(onContactTap: () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
