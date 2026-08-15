import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/enums/favorite_category_enum.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';
import 'package:untitled1/widgets/favorite_heart_button.dart';

/// Store details card — sits inside the white sheet that slides over the hero.
/// Layout (top to bottom):
///   1. Row: store icon badge (left) + favorite heart (right)
///   2. Row: store name (left) + star rating badge (right)
///   3. Description text
///   4. Row: location + Certified Vendor badge
///   5. Divider
class StoreInfoDetailsSection extends StatelessWidget {
  final StoreInfoData data;

  const StoreInfoDetailsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: FavoriteHeartButton(
              itemType: FavoriteCategoryEnum.store.name,
              itemId: data.id,
              iconSize: 22.sp,
              elevation: 2,
            ),
          ),

          SizedBox(height: 14.h),

          // ─────────────── Store Name + Rating ───────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  data.name,
                  style: AppStyle.h5.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 10.w),
              _RatingBadge(
                rating: data.rating,
                onTap: () {
                  context.push(
                    AppRoutes.reviewsScreen,
                    extra: {
                      'itemType': 'store',
                      'itemId': data.id.toString(),
                      'itemName': data.name,
                    },
                  );
                },
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // ─────────────── Description ───────────────
          Text(
            data.description,
            style: AppStyle.bodySmall.copyWith(
              color: AppColors.grey,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 8.h),
          const Divider(),
          SizedBox(height: 8.h),
          // ─────────────── Location + Verified Badge ───────────────
          Row(
            spacing: 4.w,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16.sp,
                color: AppColors.grey,
              ),
              Expanded(
                child: Text(
                  data.location,
                  style: AppStyle.labelSmall.copyWith(
                    color: AppColors.grey,
                    fontSize: 13.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (data.isVerified) ...[SizedBox(width: 12.w), _VerifiedBadge()],
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Star rating badge
// ---------------------------------------------------------------------------

class _RatingBadge extends StatelessWidget {
  final double rating;
  final VoidCallback? onTap;

  const _RatingBadge({required this.rating, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.lightOrange,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_rounded,
              color: AppColors.brown,
              size: 16.sp,
            ),
            Text(
              rating.toStringAsFixed(1),
              style: AppStyle.labelSmall.copyWith(
                color: AppColors.brown,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
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
