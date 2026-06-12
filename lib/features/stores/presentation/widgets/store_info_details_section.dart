import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_info_bloc/store_info_bloc.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';

/// Store details card — sits inside the white sheet that slides over the hero.
/// Layout (top to bottom):
///   1. Row: store icon badge (left) + Follow Store pill button (right)
///   2. Row: store name (left) + star rating badge (right)
///   3. Description text
///   4. Row: location + Certified Vendor badge
///   5. Divider
class StoreInfoDetailsSection extends StatelessWidget {
  final StoreInfoData data;

  const StoreInfoDetailsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: follow button aligned to the right ────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const _FollowStoreButton(),
            ],
          ),

          SizedBox(height: 12.h),

          // ── Row 2: store name + star rating ─────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  data.name,
                  style: theme.textTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 10.w),
              _RatingBadge(rating: data.rating),
            ],
          ),

          SizedBox(height: 6.h),

          // ── Row 3: description ───────────────────────────────────────────
          Text(
            data.description,
            style: theme.textTheme.bodySmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 10.h),

          // ── Row 4: location + certified vendor ───────────────────────────
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.sp,
                color: AppColors.grey,
              ),
              SizedBox(width: 3.w),
              Flexible(
                child: Text(
                  data.location,
                  style: AppStyle.labelSmall.copyWith(color: AppColors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (data.isVerified) ...[
                SizedBox(width: 14.w),
                _VerifiedBadge(),
              ],
            ],
          ),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Follow Store pill button — visual only, wired to API later
// ---------------------------------------------------------------------------

class _FollowStoreButton extends StatelessWidget {
  const _FollowStoreButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreInfoBloc, StoreInfoState>(
      builder: (context, state) {
        final isFollowing = state.isFollowing;

        return Material(
          color: isFollowing ? AppColors.lightGrey : AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20.r),
          elevation: isFollowing ? 0 : 2,
          shadowColor: AppColors.primaryColor.withValues(alpha: 0.28),
          child: InkWell(
            onTap: () => context
                .read<StoreInfoBloc>()
                .add(const ToggleFollowStoreEvent()),
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isFollowing ? Icons.check_rounded : Icons.add_rounded,
                    color: isFollowing ? AppColors.deepGrey : AppColors.white,
                    size: 15.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    isFollowing
                        ? 'store_info_following'.tr()
                        : 'store_info_follow_store'.tr(),
                    style: AppStyle.labelSmall.copyWith(
                      color: isFollowing ? AppColors.deepGrey : AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Star rating badge
// ---------------------------------------------------------------------------

class _RatingBadge extends StatelessWidget {
  final double rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: AppColors.secondaryColor,
            size: 14.sp,
          ),
          SizedBox(width: 3.w),
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
  }
}

// ---------------------------------------------------------------------------
// Certified Vendor badge
// ---------------------------------------------------------------------------

class _VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.verified_rounded,
          size: 13.sp,
          color: AppColors.primaryColor,
        ),
        SizedBox(width: 4.w),
        Text(
          'store_info_certified_vendor'.tr(),
          style: AppStyle.labelSmall.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
