import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/helper/image_url_utils.dart';
import 'package:untitled1/core/helper/product_hero.dart';
import 'package:untitled1/core/routing/app_routes.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/stores/presentation/pages/store_info_screen.dart';
import 'package:untitled1/widgets/image_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';

/// Full-width product card used inside the Featured Products section.
/// Handles three display modes automatically based on [StoreProductItem] data_source:
///   - Standard  : image + category + name + price + optional "New" badge
///   - Discounted: same as above with crossed-out original price + %-off badge
///   - Kit       : image + category + name + description + price + "Configure Kit" button
class StoreInfoProductCard extends StatelessWidget {
  final StoreProductItem product;
  final VoidCallback? onTap;

  const StoreInfoProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkContainer : AppColors.white;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: AppColors.primaryColor.withValues(alpha: 0.08),
            highlightColor: AppColors.primaryColor.withValues(alpha: 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductImageSection(product: product),
                _ProductInfoSection(product: product, isDark: isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Image section — gradient background + category label + optional badge
// ---------------------------------------------------------------------------

class _ProductImageSection extends StatelessWidget {
  final StoreProductItem product;

  const _ProductImageSection({required this.product});

  @override
  Widget build(BuildContext context) {
    final base = Color(product.imagePlaceholderColorValue);
    final darker = Color.fromARGB(
      255,
      (base.r * 0.50).round(),
      (base.g * 0.50).round(),
      (base.b * 0.50).round(),
    );
    final hasImage = isDisplayableImageUrl(product.imageUrl);

    return SizedBox(
      height: 160.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasImage)
            ImageWidget(
              image: product.imageUrl,
              fit: BoxFit.cover,
              borderRadius: 0,
              enableHero: productHeroTag(product.id) != null,
              heroTag: productHeroTag(product.id),
            )
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [darker, base],
                ),
              ),
            ),

          if (hasImage)
            Container(
              color: Colors.black.withValues(alpha: 0.15),
            )
          else
            Opacity(
              opacity: 0.10,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0.5, -0.5),
                    radius: 1.1,
                    colors: [Colors.white, Colors.transparent],
                  ),
                ),
              ),
            ),

          if (!hasImage)
            Positioned(
              right: -12.w,
              bottom: -12.h,
              child: Icon(
                product.imageIcon,
                size: 110.sp,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),

          // Category label — bottom left (lifted when offer-used banner shows)
          Positioned(
            bottom: product.promotionAlreadyUsed ? 38.h : 10.h,
            left: 12.w,
            child: _CategoryLabel(label: product.categoryLabel),
          ),

          // Badge — top right (either "New" text or "−X%" discount)
          if (product.badgeText != null)
            Positioned(
              top: 10.h,
              right: 10.w,
              child: _NewBadge(text: product.badgeText!),
            )
          else if (product.discountPercent != null)
            Positioned(
              top: 10.h,
              right: 10.w,
              child: _DiscountBadge(percent: product.discountPercent!),
            ),

          if (product.promotionAlreadyUsed)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                color: AppColors.red.withValues(alpha: 0.92),
                child: Text(
                  'promotion_offer_used_banner'.tr(),
                  style: AppStyle.labelSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }
}


// ---------------------------------------------------------------------------
// Category label chip on top of the image
// ---------------------------------------------------------------------------

class _CategoryLabel extends StatelessWidget {
  final String label;

  const _CategoryLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: AppStyle.labelXSmall.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// "New" badge
// ---------------------------------------------------------------------------

class _NewBadge extends StatelessWidget {
  final String text;

  const _NewBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: AppStyle.labelXSmall.copyWith(
          color: AppColors.tertiaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Discount percentage badge
// ---------------------------------------------------------------------------

class _DiscountBadge extends StatelessWidget {
  final int percent;

  const _DiscountBadge({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        '-$percent%',
        style: AppStyle.labelXSmall.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info section — name, pricing, optional configure-kit button
// ---------------------------------------------------------------------------

class _ProductInfoSection extends StatelessWidget {
  final StoreProductItem product;
  final bool isDark;

  const _ProductInfoSection({
    required this.product,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          Text(
            product.name,
            style: theme.textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Optional description (kit products only)
          if (product.description != null) ...[
            SizedBox(height: 6.h),
            Text(
              product.description!,
              style: theme.textTheme.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          SizedBox(height: 10.h),

          // Price row
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: AppStyle.h6.copyWith(
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                  ),
                  if (product.originalPrice != null) ...[
                    SizedBox(width: 8.w),
                    Text(
                      '\$${product.originalPrice!.toStringAsFixed(2)}',
                      style: AppStyle.labelSmall.copyWith(
                        color: AppColors.grey,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.grey,
                      ),
                    ),
                  ],
                  if (product.isKitProduct) ...[
                    const Spacer(),
                    _ConfigureKitButton(),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// "Configure Kit" yellow button (kit products)
// ---------------------------------------------------------------------------

class _ConfigureKitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'store_info_configure_kit'.tr(),
      onPressed: () {
        context.push(AppRoutes.storeKitScreen);
      },
      backgroundColor: AppColors.secondaryColor,
      textColor: AppColors.tertiaryColor,
      height: 38.h,
      width: 130.w,
      borderRadius: 10,
      fontWeight: FontWeight.w700,
    );
  }
}
