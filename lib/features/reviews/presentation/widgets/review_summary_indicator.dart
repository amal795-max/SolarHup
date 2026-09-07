import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/constants/debendency_injection.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/reviews/data/models/review_summary_model.dart';
import 'package:untitled1/features/reviews/data/repositories/reviews_repository.dart';

/// Fetches review summary from `GET /reviews/summary` and renders rating UI.
enum ReviewSummaryVariant {
  listCard,
  storeProfile,
  workshopBanner,
  workshopDetail,
}

class ReviewSummaryIndicator extends StatefulWidget {
  final String itemType;
  final int itemId;
  final ReviewSummaryVariant variant;
  final VoidCallback? onTap;
  final double fallbackRating;

  const ReviewSummaryIndicator({
    super.key,
    required this.itemType,
    required this.itemId,
    this.variant = ReviewSummaryVariant.listCard,
    this.onTap,
    this.fallbackRating = 0,
  });

  @override
  State<ReviewSummaryIndicator> createState() => _ReviewSummaryIndicatorState();
}

class _ReviewSummaryIndicatorState extends State<ReviewSummaryIndicator> {
  static final _cache = <String, ReviewSummaryModel>{};

  ReviewSummaryModel? _summary;
  bool _isLoading = false;

  String get _cacheKey => '${widget.itemType}:${widget.itemId}';

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  @override
  void didUpdateWidget(covariant ReviewSummaryIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemType != widget.itemType ||
        oldWidget.itemId != widget.itemId) {
      _loadSummary();
    }
  }

  Future<void> _loadSummary() async {
    if (widget.itemId <= 0) return;

    final cached = _cache[_cacheKey];
    if (cached != null) {
      setState(() => _summary = cached);
      return;
    }

    setState(() => _isLoading = true);

    final result = await getIt<ReviewsRepository>().getReviewSummary(
      widget.itemType,
      widget.itemId,
    );

    if (!mounted) return;

    result.fold(
      (_) => setState(() {
        _isLoading = false;
        _summary = null;
      }),
      (summary) {
        _cache[_cacheKey] = summary;
        setState(() {
          _isLoading = false;
          _summary = summary;
        });
      },
    );
  }

  double get _rating => _summary?.averageRating ?? widget.fallbackRating;

  int get _reviewCount => _summary?.reviewCount ?? 0;

  @override
  Widget build(BuildContext context) {
    switch (widget.variant) {
      case ReviewSummaryVariant.storeProfile:
        return _StoreProfileRatingBadge(
          rating: _rating,
          isLoading: _isLoading && widget.itemId > 0,
          onTap: widget.onTap,
        );
      case ReviewSummaryVariant.listCard:
        return _StoreListRatingBadge(
          rating: _rating,
          isLoading: _isLoading && widget.itemId > 0,
          onTap: widget.onTap,
        );
      case ReviewSummaryVariant.workshopBanner:
        return _WorkshopBannerRatingBadge(
          rating: _rating,
          reviewCount: _reviewCount,
          isLoading: _isLoading && widget.itemId > 0,
          onTap: widget.onTap,
        );
      case ReviewSummaryVariant.workshopDetail:
        return _WorkshopDetailRatingBadge(
          rating: _rating,
          reviewCount: _reviewCount,
          isLoading: _isLoading && widget.itemId > 0,
          onTap: widget.onTap,
        );
    }
  }
}

class _ProductReviewLink extends StatefulWidget {
  final double rating;
  final int reviewCount;
  final bool isLoading;
  final VoidCallback? onTap;

  const _ProductReviewLink({
    required this.rating,
    required this.reviewCount,
    required this.isLoading,
  });

  @override
  State<_ProductReviewLink> createState() => _ProductReviewLinkState();
}

class _ProductReviewLinkState extends State<_ProductReviewLink> {
  @override
  Widget build(BuildContext context) {
    final label =
        '${widget.rating.toStringAsFixed(1)} (${widget.reviewCount} ${'product_detail_reviews_suffix'.tr()})';

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: Colors.orange, size: 20.sp),
        SizedBox(width: 4.w),
        if (widget.isLoading)
          SizedBox(
            width: 12.w,
            height: 12.w,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: AppColors.primaryColor.withValues(alpha: 0.5),
            ),
          )
        else
          Text(
            label,
            style: AppStyle.labelSmall.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
      ],
    );

    if (widget.onTap == null) return child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: child,
    );
  }
}

class _StoreProfileRatingBadge extends StatelessWidget {
  final double rating;
  final bool isLoading;
  final VoidCallback? onTap;

  const _StoreProfileRatingBadge({
    required this.rating,
    required this.isLoading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: AppColors.brown,
            size: 16.sp,
          ),
          SizedBox(width: 4.w),
          if (isLoading)
            SizedBox(
              width: 10.w,
              height: 10.w,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppColors.brown.withValues(alpha: 0.5),
              ),
            )
          else
            Text(
              rating.toStringAsFixed(1),
              style: AppStyle.labelSmall.copyWith(
                color: AppColors.brown,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );

    if (onTap == null) return badge;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: badge,
    );
  }
}

class _WorkshopBannerRatingBadge extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final bool isLoading;
  final VoidCallback? onTap;

  const _WorkshopBannerRatingBadge({
    required this.rating,
    required this.reviewCount,
    required this.isLoading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: AppColors.secondaryColor,
            size: 14.sp,
          ),
          SizedBox(width: 4.w),
          if (isLoading)
            SizedBox(
              width: 10.w,
              height: 10.w,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppColors.black.withValues(alpha: 0.4),
              ),
            )
          else
            Text(
              '${rating.toStringAsFixed(1)} ($reviewCount)',
              style: AppStyle.labelXSmall.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );

    if (onTap == null) return badge;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: badge,
    );
  }
}

class _WorkshopDetailRatingBadge extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final bool isLoading;
  final VoidCallback? onTap;

  const _WorkshopDetailRatingBadge({
    required this.rating,
    required this.reviewCount,
    required this.isLoading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label =
        '${rating.toStringAsFixed(1)} ($reviewCount ${'product_detail_reviews_suffix'.tr()})';

    final child = Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: AppColors.brown, size: 16.sp),
          SizedBox(width: 4.w),
          if (isLoading)
            SizedBox(
              width: 10.w,
              height: 10.w,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppColors.brown.withValues(alpha: 0.5),
              ),
            )
          else
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.labelSmall.copyWith(
                  color: AppColors.brown,
                  fontWeight: FontWeight.w700,
                  decoration: onTap != null ? TextDecoration.underline : null,
                ),
              ),
            ),
        ],
      ),
    );

    if (onTap == null) return child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    );
  }
}

class _StoreListRatingBadge extends StatelessWidget {
  final double rating;
  final bool isLoading;
  final VoidCallback? onTap;

  const _StoreListRatingBadge({
    required this.rating,
    required this.isLoading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: AppColors.secondaryColor,
            size: 13.sp,
          ),
          SizedBox(width: 3.w),
          if (isLoading)
            SizedBox(
              width: 10.w,
              height: 10.w,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppColors.black.withValues(alpha: 0.4),
              ),
            )
          else
            Text(
              rating.toStringAsFixed(1),
              style: AppStyle.labelXSmall.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );

    if (onTap == null) return badge;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: badge,
    );
  }
}
