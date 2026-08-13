import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/widgets/primary_button.dart';

import '../../../../core/routing/app_routes.dart';

// ---------------------------------------------------------------------------
// UI model — keeps the widget layer decoupled from the data_source layer
// ---------------------------------------------------------------------------

class StoreCardData {
  final int id;
  final String name;
  final String location;
  final double rating;
  final List<String> tags;
  final IconData iconData;
  final int iconColorValue;
  final int imagePlaceholderColorValue;
  final String? imageUrl;

  const StoreCardData({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.tags,
    required this.iconData,
    required this.iconColorValue,
    required this.imagePlaceholderColorValue,
    this.imageUrl,
  });
}

// ---------------------------------------------------------------------------
// StoreCard — the main reusable card widget
// ---------------------------------------------------------------------------

class StoreCard extends StatelessWidget {
  final StoreCardData data;
  final VoidCallback? onTap;

  const StoreCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.brightness;
    final cardColor = isDark ? AppColors.darkContainer : AppColors.white;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StoreImageSection(data: data),
                _StoreInfoSection(data: data, onTap: onTap, isDark: isDark),
              ],
            ),
            // Stacked logo badge (overlaps image + white info section)
            Positioned(
              left: 20.w,
              top: 100.h,
              child: _StoreIconBadge(
                iconData: data.iconData,
                colorValue: data.iconColorValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Image section — gradient background + rating badge + store icon
// ---------------------------------------------------------------------------

class _StoreImageSection extends StatelessWidget {
  final StoreCardData data;

  const _StoreImageSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final base = Color(data.imagePlaceholderColorValue);
    final darker = Color.fromARGB(
      255,
      (base.r * 0.55).round(),
      (base.g * 0.55).round(),
      (base.b * 0.55).round(),
    );

    return SizedBox(
      height: 140.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background (replaces network image until real API is wired)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [darker, base],
              ),
            ),
          ),
          // Subtle radial highlight overlay
          Opacity(
            opacity: 0.12,
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.6, -0.4),
                  radius: 1.1,
                  colors: [Colors.white, Colors.transparent],
                ),
              ),
            ),
          ),
          // Rating badge — top-right
          Positioned(
            top: 10.h,
            right: 10.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ComplaintButton(data: data),
                SizedBox(width: 8.w),
                _RatingBadge(rating: data.rating),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComplaintButton extends StatelessWidget {
  final StoreCardData data;

  const _ComplaintButton({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('${AppRoutes.addComplaintScreen}/${data.id}');

      },
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.report_problem_outlined,
          color: AppColors.red,
          size: 16.sp,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Rating badge
// ---------------------------------------------------------------------------

class _RatingBadge extends StatelessWidget {
  final double rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
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
  }
}

// ---------------------------------------------------------------------------
// Store icon badge (overlaid on the image, bottom-left)
// ---------------------------------------------------------------------------

class _StoreIconBadge extends StatelessWidget {
  final IconData iconData;
  final int colorValue;

  const _StoreIconBadge({required this.iconData, required this.colorValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: Color(colorValue),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.85),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(iconData, color: AppColors.secondaryColor, size: 24.sp),
    );
  }
}

// ---------------------------------------------------------------------------
// Info section — name, location, tags, CTA button
// ---------------------------------------------------------------------------

class _StoreInfoSection extends StatelessWidget {
  final StoreCardData data;
  final VoidCallback? onTap;
  final bool isDark;

  const _StoreInfoSection({
    required this.data,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(minHeight: 220.h),
      padding: EdgeInsets.fromLTRB(14.w, 30.h, 14.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store name
          Text(
            data.name,
            style: theme.textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5.h),
          // Location row
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 13.sp,
                color: AppColors.grey,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  data.location,
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Tag chips
          _TagsRow(tags: data.tags, isDark: isDark),
          SizedBox(height: 18.h),
          // CTA button — tap navigates to the store detail
          CustomButton(
            text: 'stores_view_store'.tr(),
            onPressed: onTap,
            icon: Icons.arrow_forward_rounded,
            iconLeft: false,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tags row
// ---------------------------------------------------------------------------

class _TagsRow extends StatelessWidget {
  final List<String> tags;
  final bool isDark;

  const _TagsRow({required this.tags, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 6.h,
      children: tags
          .map((tag) => _TagChip(label: tag, isDark: isDark))
          .toList(),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _TagChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkGray : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: AppStyle.labelXSmall.copyWith(
          color: isDark ? AppColors.blue : AppColors.deepGrey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
