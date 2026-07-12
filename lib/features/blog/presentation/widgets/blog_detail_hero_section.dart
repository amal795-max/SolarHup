import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/blog/data/models/blog_article_detail_model.dart';
import 'package:untitled1/widgets/back_button_widget.dart';

class BlogDetailHeroSection extends StatelessWidget {
  final BlogArticleDetailModel article;

  const BlogDetailHeroSection({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 220.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(article.heroColorValue),
                  AppColors.primaryColor,
                ],
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.battery_charging_full_rounded,
                size: 72.sp,
                color: AppColors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.55),
                ],
              ),
            ),
          ),
          const SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topLeft,
              child: BackButtonWidget(),
            ),
          ),
          if (article.sponsoredProduct != null)
            Positioned(
              left: 16.w,
              right: 16.w,
              top: 56.h,
              child: _SponsoredProductCard(
                product: article.sponsoredProduct!,
              ),
            ),
          Positioned(
            left: 16.w,
            bottom: 14.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                article.categoryBadge,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.tertiaryColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SponsoredProductCard extends StatelessWidget {
  final BlogSponsoredProductModel product;

  const _SponsoredProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.96),
      borderRadius: BorderRadius.circular(12.r),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.battery_std_rounded,
                color: AppColors.primaryColor,
                size: 28.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWithIconRow(
                    label: '${'blog_sponsored_from'.tr()} ${product.storeName}',
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    product.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextWithIconRow extends StatelessWidget {
  final String label;

  const TextWithIconRow({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.wb_sunny_outlined,
          size: 14.sp,
          color: AppColors.secondaryColor,
        ),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
