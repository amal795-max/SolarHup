import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/presentation/bloc/blog_cubit.dart';
import 'package:untitled1/features/blog/presentation/widgets/blog_article_card.dart';
import 'package:untitled1/features/blog/presentation/widgets/blog_pagination_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/blog_search_section.dart';
import 'package:untitled1/widgets/app_refresh_indicator.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BlogCubit>()..loadBlog(),
      child: const _BlogView(),
    );
  }
}

class _BlogView extends StatelessWidget {
  const _BlogView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<BlogCubit, BlogState>(
          builder: (context, state) {
            return switch (state) {
              BlogLoading() => const LoadingIndicator(),
              BlogError(:final message) => EmptyWidget(
                  icon: Icons.error_outline_rounded,
                  iconSize: 48,
                  iconColor: AppColors.red,
                  title: 'stores_error_title'.tr(),
                  subtitle: message,
                  action: CustomButton(
                    text: 'stores_retry'.tr(),
                    onPressed: () => context.read<BlogCubit>().loadBlog(),
                    width: 160.w,
                  ),
                ),
              BlogLoaded() => _BlogLoadedBody(state: state),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _BlogLoadedBody extends StatelessWidget {
  final BlogLoaded state;

  const _BlogLoadedBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final articles = state.paginatedArticles;

    return AppRefreshIndicator(
      onRefresh: () => context.read<BlogCubit>().loadBlog(),
      child: SingleChildScrollView(
      physics: appRefreshPhysics,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BlogSearchSection(),
          SizedBox(height: 14.h),
          if (articles.isEmpty)
            EmptyWidget(
              icon: Icons.search_off_rounded,
              iconSize: 48,
              iconColor: AppColors.grey,
              title: 'blog_no_results'.tr(),
              subtitle: 'blog_no_results_hint'.tr(),
              padding: EdgeInsets.symmetric(vertical: 32.h),
            )
          else
            ...articles.map(
              (article) => Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: BlogArticleCard(
                  article: article,
                  onTap: () => context.push(
                    AppRoutes.blogArticleDetail(article.id),
                  ),
                ),
              ),
            ),
          SizedBox(height: 8.h),
          const BlogPaginationSection(),
        ],
      ),
    ),
    );
  }
}
