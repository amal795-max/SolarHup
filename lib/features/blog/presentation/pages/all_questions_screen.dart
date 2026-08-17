import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/helper/refresh_loading.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/blog/data/models/faq_model.dart';
import 'package:untitled1/features/blog/presentation/bloc/faq_cubit.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/empty_widget.dart';

class AllQuestionsScreen extends StatefulWidget {
  const AllQuestionsScreen({super.key});

  @override
  State<AllQuestionsScreen> createState() => _AllQuestionsScreenState();
}

class _AllQuestionsScreenState extends State<AllQuestionsScreen> {
  @override
  void initState() {
    context.read<FaqCubit>().getFaqs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;

    return Scaffold(
      appBar: AppBar(title: Text('faq_all_questions_title'.tr())),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _FaqSearchField(),
            ),
            Expanded(
              child: BlocBuilder<FaqCubit, FaqState>(
                builder: (context, state) {
                  if (state is FaqError) {
                    return EmptyWidget(
                      icon: Icons.error_outline_rounded,
                      iconSize: 48,
                      iconColor: AppColors.red,
                      title: 'stores_error_title'.tr(),
                      subtitle: state.message,
                    );
                  }

                  final isLoading = state is FaqLoading;
                  final hasCachedData = state is FaqSuccess;
                  final showSkeleton = showInitialLoadingSkeleton(
                    isLoading: isLoading,
                    hasCachedData: hasCachedData,
                  );
                  final List<FaqModel> fakeFaqs = List.generate(
                    6,
                    (index) => FaqModel(
                      id: index,
                      question: '',
                      answer: '',
                      displayOrder: index,
                      isActive: true,
                    ),
                  );

                  final faqs = state is FaqSuccess
                      ? state.filteredFaqs
                      : fakeFaqs;

                  if (state is FaqSuccess && faqs.isEmpty) {
                    return AppRefreshIndicator(
                      onRefresh: () =>
                          context.read<FaqCubit>().getFaqs(),
                      child: ListView(
                        physics: appRefreshPhysics,
                        children: [
                          EmptyWidget(
                            icon: Icons.search_off_rounded,
                            title: 'faq_no_results'.tr(),
                            subtitle: 'blog_no_results_hint'.tr(),
                          ),
                        ],
                      ),
                    );
                  }

                  return AppRefreshIndicator(
                    onRefresh: () => context.read<FaqCubit>().getFaqs(),
                    child: Skeletonizer(
                      enabled: showSkeleton,
                      child: ListView.builder(
                        physics: appRefreshPhysics,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        itemCount: faqs.length,
                        itemBuilder: (context, index) {
                          final faq = faqs[index];
                          final isExpanded = state is FaqSuccess;
                          return _FaqTile(
                            faq: faq,
                            isExpanded: isExpanded,
                            isDark: isDark,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqSearchField extends StatefulWidget {
  const _FaqSearchField();

  @override
  State<_FaqSearchField> createState() => _FaqSearchFieldState();
}

class _FaqSearchFieldState extends State<_FaqSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      hasTitle: false,
      title: '',
      hint: 'faq_search_hint'.tr(),
      prefixIcon: const Icon(Icons.search),
      onChanged: (val) => context.read<FaqCubit>().updateSearch(val),
      suffixIcon: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          _controller.clear();
          context.read<FaqCubit>().updateSearch('');
        },
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final FaqModel faq;
  final bool isExpanded;
  final bool isDark;

  const _FaqTile({
    required this.faq,
    required this.isExpanded,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isExpanded ? AppColors.primaryColor : AppColors.borderColor,
        ),
      ),
      child: Column(
        children: [
          ExpansionTile(
            title: Text(
              faq.question,
              style: AppStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  faq.answer,
                  style: AppStyle.bodySmall.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
