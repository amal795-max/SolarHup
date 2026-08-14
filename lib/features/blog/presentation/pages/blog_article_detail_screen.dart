import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/models/blog_article_detail_model.dart';
import 'package:untitled1/features/blog/presentation/bloc/blog_detail_cubit.dart';
import 'package:untitled1/features/blog/presentation/widgets/blog_detail_author_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/blog_detail_content_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/blog_detail_hero_section.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class BlogArticleDetailScreen extends StatelessWidget {
  final String articleId;

  const BlogArticleDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BlogDetailCubit>()
        ..loadArticleDetail(articleId),
      child: _BlogArticleDetailView(articleId: articleId),
    );
  }
}

class _BlogArticleDetailView extends StatelessWidget {
  final String articleId;

  const _BlogArticleDetailView({required this.articleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<BlogDetailCubit, BlogDetailState>(
        builder: (context, state) {
          return switch (state) {
            BlogDetailLoading() => const LoadingIndicator(),
            BlogDetailError(:final message) => SafeArea(
                child: EmptyWidget(
                  icon: Icons.error_outline_rounded,
                  iconSize: 48,
                  iconColor: AppColors.red,
                  title: 'stores_error_title'.tr(),
                  subtitle: message,
                  action: CustomButton(
                    text: 'stores_retry'.tr(),
                    onPressed: () => context.read<BlogDetailCubit>().loadArticleDetail(
                          articleId,
                        ),
                    width: 160.w,
                  ),
                ),
              ),
            BlogDetailLoaded(:final article) => _BlogDetailBody(
                article: article,
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _BlogDetailBody extends StatelessWidget {
  final BlogArticleDetailModel article;

  const _BlogDetailBody({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final headingColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlogDetailHeroSection(article: article),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    color: headingColor,
                  ),
                ),
                SizedBox(height: 16.h),
                BlogDetailAuthorSection(author: article.author),
                SizedBox(height: 20.h),
                BlogDetailContentSection(content: article.content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
