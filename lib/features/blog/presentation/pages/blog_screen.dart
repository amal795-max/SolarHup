import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/data_source/blog_remote_data_source.dart';
import 'package:untitled1/features/blog/data/repositories/blog_repository.dart';
import 'package:untitled1/features/blog/presentation/bloc/blog_bloc/blog_bloc.dart';
import 'package:untitled1/features/blog/presentation/widgets/blog_article_card.dart';
import 'package:untitled1/features/blog/presentation/widgets/blog_category_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/blog_featured_card.dart';
import 'package:untitled1/features/blog/presentation/widgets/blog_pagination_section.dart';
import 'package:untitled1/features/blog/presentation/widgets/blog_search_section.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlogBloc(
        BlogRepositoryImpl(
          remote: const BlogRemoteDataSourceImpl(),
          networkInfo: NetworkInfoImpl(),
          useNetworkCheck: false,
        ),
      )..add(const LoadBlogEvent()),
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
        child: BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            return switch (state) {
              BlogLoading() => const LoadingWidget(),
              BlogError(:final message) => EmptyWidget(
                  icon: Icons.error_outline_rounded,
                  iconSize: 48,
                  iconColor: AppColors.red,
                  title: 'stores_error_title'.tr(),
                  subtitle: message,
                  action: CustomButton(
                    text: 'stores_retry'.tr(),
                    onPressed: () =>
                        context.read<BlogBloc>().add(const LoadBlogEvent()),
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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BlogSearchSection(),
          SizedBox(height: 14.h),
          const BlogCategorySection(),
          SizedBox(height: 16.h),
          BlogFeaturedCard(article: state.featured),
          SizedBox(height: 16.h),
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
                  onTap: () {},
                ),
              ),
            ),
          SizedBox(height: 8.h),
          const BlogPaginationSection(),
        ],
      ),
    );
  }
}
